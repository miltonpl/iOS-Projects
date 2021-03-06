//
//  StudentTableViewCell.swift
//  StudentDirectory
//
//  Created by Milton Palaguachi on 9/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    @IBOutlet private weak var profileImageView:UIImageView!
    @IBOutlet private weak var fullnameLabel:UILabel!
    
    func setProperties(student: Student) {
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.image = student.image
        fullnameLabel.text = "\(student.fname )  \(student.lname )"
        
        
        
    }

}
