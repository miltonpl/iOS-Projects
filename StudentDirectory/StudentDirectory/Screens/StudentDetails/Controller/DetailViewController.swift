//
//  DetailViewController.swift
//  StudentDirectory
//
//  Created by Milton Palaguachi on 9/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController {
    
    weak var updateDelegate: UpdateDelegate?
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var studentImageView: UIImageView!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    var studentDetails: Student?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .systemGreen
        setupUI()
        configure()
    }
    //MARK: - Edit Action Tab Bar
    @objc func editActionTabBar(_ sender: UIBarButtonItem ){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       guard let editVC = storyboard.instantiateViewController(withIdentifier: "EditInfoViewController") as? EditInfoViewController else { return }
        
        editVC.student = studentDetails
        
        editVC.delegationUpdateStudent = self.updateDelegate
        editVC.delegation = self
        
       let navController = UINavigationController(rootViewController: editVC)
       self.navigationController?.present(navController, animated: true, completion: nil)
       }
    //MARK: - message Action
    @IBAction func messageStudentButton(_ sender: UIButton ) {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.delegate = self
            guard let recipientPhonenumber = studentDetails?.phone else { return }
            messageVC.recipients = [recipientPhonenumber]
            self.present(messageVC, animated: true, completion: nil)
        }
    }
    //MARK: - call Action

    @IBAction func callAction(_ sender: UIButton ) {
        guard let number = studentDetails?.phone, let phoneUrl = URL(string: "tel://\(number)")
            , UIApplication.shared.canOpenURL(phoneUrl ) else { return }
        if #available(iOS 13, *) {
            UIApplication.shared.open(phoneUrl )
        }
    }
    //MARK: - email Action

    @IBAction func emailAction(_ sender: UIButton ) {
        if let studentEmailAddress = studentDetails?.email {
            if MFMailComposeViewController.canSendMail() {
                let mailVC = MFMailComposeViewController()
                mailVC.mailComposeDelegate = self
                mailVC.setToRecipients([studentEmailAddress])
                self.present(mailVC, animated: true)
            }
        }
    }
    
    //MARK: - setupUI Action
    func setupUI () {
        studentImageView.layer.cornerRadius = studentImageView.frame.width/2
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editActionTabBar(_:)))
    }
    //MARK: - Set up Properties
    func configure() {
        if let tempStudent = studentDetails {
            fullNameLabel.text = tempStudent.fname + " " + tempStudent.lname
            numberLabel.text = "Phone: " + tempStudent.phone
            emailLabel.text  = "Email: " + tempStudent.email
            studentImageView.image = tempStudent.image
        }
    }
}
//MARK: - Delegation add New Student is used to update the detailView screen
extension DetailViewController: EditViewControllerDelegate {
    func addNewStudent(student: Student) {
        self.studentDetails = student
        configure()
    }
}

extension DetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
extension DetailViewController: MFMessageComposeViewControllerDelegate,  UINavigationControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

