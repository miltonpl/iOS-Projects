//
//  ViewController3.swift
//  PassDataBetweenViewControllers
//
//  Created by Milton Palaguachi on 9/29/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {
    //MARK:- @IBOutlet
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var colorButton: UIButton!
    //MARK:- Store Properites
    var setColor:UIColor?
    var whichColor = false
    var message:String?
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Screen 3"
        self.setupUI()
    }
    func configure(color: UIColor, message: String){
        self.view.backgroundColor = color
        messageLabel.text = message
    }
    //MARK:- @IBAction
    @IBAction func tapColor(_ sender: UIButton) {
        self.message = "Color was set from screen3"
        whichColor = whichColor ? false : true
        if whichColor {
            setColor =  .systemPink
            colorButton.backgroundColor =  .purple
            messageLabel.text = "Current Color is Pink you can change to purple "
        }
        else {
            setColor =  .purple
            colorButton.backgroundColor =  .systemPink
            messageLabel.text = "Current Color is purple you can change to pink "
            
        }
        self.view.backgroundColor = setColor
        if let color = setColor, let msg = message {
            passData(dataId: "data", info: DataToPass(message: msg , color: color))
        }
    }
    //MARK:- setupUI
    func setupUI() {
        colorButton.setTitle("Change Color", for: .normal)
        messageLabel.text = "Hello Welcome to Screen 3\n The default color is white but it can be change to pick "
        messageLabel.layer.borderColor = UIColor.brown.cgColor
        messageLabel.layer.borderWidth = 4
        colorButton.layer.cornerRadius = colorButton.bounds.width/2
        colorButton.layer.borderColor = UIColor.black.cgColor
        colorButton.layer.borderWidth = 3
    }
}
//MARK:- passData Function
extension ViewController3 {
    func passData(dataId:String, info: DataToPass) {
        let data:[String: DataToPass] = [dataId: info]
        //post a Notification to screen1 and screen2
        NotificationCenter.default.post(name: .myNotification, object: nil, userInfo: data)
    }
}
extension Notification.Name {
    static let myNotification = Notification.Name("myNotification")
}
