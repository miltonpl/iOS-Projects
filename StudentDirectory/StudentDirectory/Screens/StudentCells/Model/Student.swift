//
//  Student.swift
//  StudentDirectory
//
//  Created by Milton Palaguachi on 9/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit
struct Student {
    var studentId: String
    var fname: String
    var lname: String
    var image: UIImage
    var phone: String
    var email: String
}
struct Image {
    static let defaultImage = UIImage(named: "default")
    static let callIcon = UIImage(named: "call")
    static let emailIcon = UIImage(named: "email")
    static let messageIcon = UIImage(named: "message")
    static let startIcon = UIImage(named: "star")


}
