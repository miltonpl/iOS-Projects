//
//  StudentViewController.swift
//  StudentTableView
//
//  Created by Milton Palaguachi on 9/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import Foundation
import UIKit

class StudentViewController: UIViewController {
    @IBOutlet weak var tableView:UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    var studentDictionary = [String: [Student]]()
    {
        didSet {
            self.tableView.reloadData()
        }
    }
    var studentSelectionTitle = [String]()
    {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = .systemGray6
        }
        setupTableViewProperties()
        super.viewDidLoad()
        self.title = "Students"
    }
    //MARK: - add New Student
    @IBAction func addActionTabBar(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let editVC = storyboard.instantiateViewController(withIdentifier: "EditInfoViewController") as? EditInfoViewController else { return }
        //It delegates when returing from addActionTabBar
        editVC.delegation = self
        let navController = UINavigationController(rootViewController: editVC)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
}

extension StudentViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let studentKey = studentSelectionTitle[indexPath.section]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController,
            let studentValues = studentDictionary[studentKey] else {return}
        
        detailVC.studentDetails = studentValues[indexPath.row]
        detailVC.updateDelegate = self
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
extension StudentViewController: UITableViewDataSource {
    
    func sectionIndexTitlesForTableView(for tableView: UITableView) -> [String]? {
        studentSelectionTitle
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        studentSelectionTitle
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        studentSelectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        studentSelectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if studentSelectionTitle.count == 0 {
            self.setupTableViewProperties()
        } else {
            tableView.disableEmtyView()
        }
        let studentKey = studentSelectionTitle[section]
        return studentDictionary[studentKey]?.count ?? 0
    }
    
    //MARK: CellForRowAt Method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath) as? StudentTableViewCell else {
            fatalError("Unable to dequeueReusableCell with withIdentifier: StudentTableViewCell")
        }
        let studentKey = studentSelectionTitle[indexPath.section]
        if let studentValues = studentDictionary[studentKey] {
            cell.setProperties(student: studentValues[indexPath.row])
            return cell
        }
        return cell
    }
    
    func setupTableViewProperties() {
        self.tableView.setEmptyView(title: "Add Students", message: "tap the [+] button on your\nright top conner of the screen")
    }
    
}
//MARK: - Update Student
//UITableView
extension StudentViewController: UpdateDelegate {
    
    func update( student: Student, _ firstOldName: String,_ studentId: String) {
        let studentKey = String(firstOldName.prefix(1))
        if studentKey.isAlphabet {
            studentDictionary[studentKey]?.removeAll(where: { $0.studentId == studentId })
        }
        else {
            studentDictionary["#"]?.removeAll(where: { $0.studentId == studentId })
        }
        if studentDictionary[studentKey]?.count == 0 {
            studentDictionary.removeValue(forKey: studentKey)
            studentSelectionTitle.removeAll { $0 == studentKey }
        }
        addNewStudent(student: student)
    }
}
//MARK: - addNewStudent
extension StudentViewController: EditViewControllerDelegate {
    
    func addNewStudent(student: Student ) {
        let studentKey = String(student.fname.prefix(1))
        if studentKey.isAlphabet {
            if var studentValues = studentDictionary[studentKey]{
                studentValues.append(student)
                studentDictionary[studentKey] = studentValues
            }
            else{
                studentDictionary[studentKey] = [student]
            }
        }
        else {
            if var studentValues = studentDictionary["#"]{
                studentValues.append(student)
                studentDictionary[studentKey] = studentValues
            }
            else{
                studentDictionary["#"] = [student]
            }
        }
        studentSelectionTitle = [String](studentDictionary.keys)
        studentSelectionTitle = studentSelectionTitle.sorted(by: {$0 < $1})
    }
}
