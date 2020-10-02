//
//  EditInfoViewController.swift
//  StudentDirectory
//
//  Created by Milton Palaguachi on 9/23/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit
protocol EditViewControllerDelegate: AnyObject {
    func addNewStudent( student: Student)
}
protocol UpdateDelegate: AnyObject {
    func update(student: Student, _ studentId: String, _ firstOldName: String)
}

class EditInfoViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak private var editTableView: UITableView!
    @IBOutlet weak private var imageButton: UIButton!
    weak var delegation: EditViewControllerDelegate?
    weak var delegationUpdateStudent: UpdateDelegate?
    //MARK: - Store Properties
    var student: Student?
    var firstName: String = ""
    var lastName: String = ""
    var phone: String = ""
    var email: String = ""
    var studentId: String = ""
    var studentImage: UIImage?
    var activeTextField: UITextField?
    var useImage:UIImage = UIImage(named: "default")!
    var studentInfo = [Info]() {
        didSet {
            self.editTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInfo()
        setupEditTableView()
    }
    //MARK: - ACTIONS
    @IBAction func backgroundTab(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func cancelActionBar(_ sender: UIBarButtonItem ){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func setPhoto(_ sender: UIButton){
        let actionAlert = UIAlertController(title: "Pick an Image", message: "", preferredStyle: .actionSheet)
        actionAlert.addAction( UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionAlert.addAction( UIAlertAction(title: "From Library", style: .default) { action in
            self.setImagePickerFromPhotoAlbum()
        })
        actionAlert.addAction( UIAlertAction(title: "Take Photo", style: .default) { action in
            self.setImagePickerFromCamera()
        })
        
        self.present(actionAlert, animated: true)
        
    }
    //MARK: - Save Action Bar
    @objc func saveActionBar(_ sender: UIBarButtonItem ) {
        
        var passValidation = true
        for typeField in studentInfo {
            
            switch typeField {
            case .firstName:
                if !firstName.isValidName {
                    alertFunction (title: "Invalid " + typeField.rawValue, message: firstName  )
                    passValidation = false
                }
                break
            case .lastName:
                if !lastName.isValidName {
                    alertFunction (title: "Invalid " + typeField.rawValue, message: lastName)
                    passValidation = false
                }
                break
            case .phone:
                if !phone.isValidPhone {
                    alertFunction (title: "Invalid " + typeField.rawValue, message: phone)
                    passValidation = false
                }
                break
            case .email:
                if !email.isValidEmail {
                    alertFunction (title: "Invalid " + typeField.rawValue, message: email)
                    passValidation = false
                }
                break
            }
        }
        if passValidation {
            var didUpdate = false
            if student != nil {
                if studentImage != student?.image {
                    didUpdate = true
                }
                for detail in studentInfo {
                    switch detail {
                    case .email:
                        if student?.email != email {
                            didUpdate = true
                        }
                        break
                    case .phone:
                        if student?.phone != phone {
                            didUpdate = true
                        }
                        break
                    case .lastName:
                        if student?.lname != lastName {
                            didUpdate = true
                        }
                        break
                    case .firstName:
                        if student?.fname != firstName {
                            didUpdate = true
                        }
                        break
                    }
                    if didUpdate {
                        break
                    }
                    
                }
            }
            
            let newStudentId = firstName + lastName
            if let image = studentImage {
                useImage = image
            }
            let newStudent = Student(studentId: newStudentId, fname: firstName, lname: lastName, image: useImage , phone: phone, email: email)
            //MARK: - Update/New Student Pass Delegation
            if didUpdate {
                self.delegationUpdateStudent?.update(student: newStudent, student?.fname ?? "", student?.studentId ?? "")
            }
            /**
             the delegation?.addNewStudent  is use to
             A. add new student in the StudentViewController
             B. To update in the student details info in the DetailViewController
             (A) will happen whe calling from the add Action Function from StudentViewController
             (B) will happen when calling from Edit Action Function from DetailViewController
             **/
            self.delegation?.addNewStudent(student:  newStudent)
            self.dismiss(animated: true, completion: nil)
        }
    }
    //MARK: - SetupUI
    func setupUI() {
        
        //Notifications setup for keyword-> willShow, willChange and willHide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        imageButton.layer.masksToBounds = true
        imageButton.layer.cornerRadius = imageButton.bounds.width/2
        imageButton.layer.borderWidth = 3
        imageButton.layer.borderColor = UIColor.green.cgColor
        self.navigationController?.navigationBar.tintColor = .systemGreen
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveActionBar(_:)))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelActionBar(_:)))
    }
    func setupInfo() {
        studentInfo.append(.firstName)
        studentInfo.append(.lastName)
        studentInfo.append(.phone)
        studentInfo.append(.email)
        
        if let user = self.student {
            studentId = user.studentId
            firstName = user.fname
            lastName = user.lname
            email = user.email
            phone = user.phone
            studentImage = user.image
            imageButton.setImage(user.image, for: .normal)
            
            self.title = "Edit Student"
        } else {
            
            self.title = "Add Student"
        }
    }
    //MARK: - setupEditTableView
    func setupEditTableView() {
        self.editTableView.register(DetailTableViewCell.nib(), forCellReuseIdentifier: DetailTableViewCell.identifier)
        self.editTableView.allowsSelection = false
        self.editTableView.isScrollEnabled = false
        self.editTableView.tableFooterView = UIView()
        if #available(iOS 13.0, *) {
            self.editTableView.backgroundColor = .systemGray6
        }
    }
    
    func setImagePickerFromPhotoAlbum() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = true
        imagePickerVC.sourceType = .savedPhotosAlbum
        present(imagePickerVC, animated: true, completion: nil)
    }
    func setImagePickerFromCamera() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerVC.sourceType = .camera
        }
        else {
            return
        }
        present(imagePickerVC, animated: true, completion: nil)
    }
    //MARK: - Move Keyword Method
    @objc func keyboardWillHide(notification: Notification) {
        self.editTableView.contentOffset = .zero
                self.activeTextField = nil
    }
    @objc func keyboardWillShow(notification: Notification) {
        
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
            
            editTableView.contentInset = UIEdgeInsets(top: self.editTableView.contentInset.top, left: 0, bottom: keyboardHeight, right: 0)
            if let texField = self.activeTextField, let activeTextFieldRect = texField.superview?.superview?.frame {
                self.editTableView.scrollRectToVisible(activeTextFieldRect, animated: true)
            }
        }
    }
    
    //MARK: - Alert Function Implementation
    func alertFunction (title: String, message: String){
        // Create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension EditInfoViewController: UINavigationControllerDelegate  ,UIImagePickerControllerDelegate {
    //MARK: - imagePickerController Delegate Method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let capturedImage = info[.editedImage] as? UIImage {
            
            imageButton.setImage(capturedImage, for: .normal)
            studentImage = capturedImage
            
        }
        dismiss(animated: true, completion: nil)
    }
}
extension EditInfoViewController: UITableViewDelegate {
    
}
extension EditInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInfo.count
    }
    //MARK: - CellRowAt Method DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else {
            fatalError("Unable to dequeueReusableCell with withIdentifier: StudentTableViewCell")
        }
        
        cell.textField.keyboardType = .default
        let type = studentInfo[indexPath.row]
        switch type {
        case .firstName:
            cell.setProperties(dataName: type.rawValue, textField: firstName)
            cell.textField.autocapitalizationType = .words
            break
        case .lastName:
            cell.setProperties(dataName: type.rawValue, textField: lastName)
            cell.textField.autocapitalizationType = .words
            break
        case .phone:
            cell.setProperties(dataName: type.rawValue, textField: phone)
            cell.textField.keyboardType = .phonePad
            break
        case .email:
            cell.setProperties(dataName: type.rawValue, textField: email)
            cell.textField.keyboardType = .emailAddress
            break
        }
        cell.delegation = self
        return cell
    }
}
extension EditInfoViewController: DetailTableViewCellDelagation {
    func currentTextFied(textField: UITextField) {
        self.activeTextField = textField
    }
    func updateTextField(text: String, whichTextField: String) {
        switch whichTextField {
        case "First Name":
            firstName = text
            break
        case "Last Name":
            lastName = text
            break
        case "Number":
            phone = text
            break
        case "Email":
            email = text
            break
        default:
            break
        }
    }
}
