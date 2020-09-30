//
//  ViewController2.swift
//  PassDataBetweenViewControllers
//
//  Created by Milton Palaguachi on 9/29/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    //MARK: - Store Properties
    var setColor: UIColor?
    var whichColor = false
    var message:String?
     //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Screen 2"
        self.setupUI()
    }
    //MARK: - Configure
    func configure(color: UIColor,message: String){
        self.view.backgroundColor = color
        self.messageLabel.text = message
        self.setColor = color
        self.message = message
    }
    
    //MARK: - IBAction functions
    @IBAction func tappedNext(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let screen3VC = storyboard.instantiateViewController(withIdentifier: "ViewController3") as? ViewController3 else {return }
                
        if let color = setColor {
            screen3VC.configure(color: color, message: message ?? "")
        }
        self.observerData()
        self.navigationController?.pushViewController(screen3VC, animated: true)
        
    }
    
    @IBAction func tapColor(_ sender: UIButton) {
        self.message = "Color was set in Screen 2"
        whichColor = whichColor ? false:true
        if whichColor {
            setColor =  .systemIndigo
            colorButton.backgroundColor =  .systemTeal
            messageLabel.text = "Current Color is sytemIndigo you can change to systemTeal "
        }
        else {
            setColor =  .systemTeal
            colorButton.backgroundColor =  .systemIndigo
            messageLabel.text = "Current Color is  systemTeal you can change to  systemIndigo "
        }
        self.view.backgroundColor = setColor
        if let color = setColor, let msg = message {
            passData(dataId: "data", info: DataToPass(message: msg , color: color))
        }
    }
    //MARK: - setupUI Method
    func setupUI(){
        colorButton.backgroundColor =  .systemIndigo
        colorButton.layer.borderWidth = 3
        colorButton.layer.borderColor = UIColor.black.cgColor
        colorButton.layer.cornerRadius = colorButton.bounds.width/2
        colorButton.setTitle("Change Color", for: .normal)
        messageLabel.layer.borderColor = UIColor.brown.cgColor
        messageLabel.layer.borderWidth = 4
        messageLabel.text = "Hello Welcome to Screen 2\n The default color is white but it can be change to systemTeal "
        nextButton.layer.borderWidth = 3
        nextButton.layer.borderColor = UIColor.gray.cgColor
    }
}
//MARK:- Abserver Function
extension ViewController2 {
    func observerData() {
        //MARK: - Notification addObserver
        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(getNotification(_:)), name: .myNotification, object: nil)
    }
    @objc func getNotification(_ notification: Notification) {
        guard let data = notification.userInfo?["data"] as? DataToPass else {return }
        
        self.view.backgroundColor = data.color
        self.setColor = data.color
        messageLabel.text = data.message
        message = data.message
        
    }
    func passData(dataId:String, info: DataToPass)  {
        let data:[String: DataToPass] = [dataId: info]
        //post a Notification to screen 1 only
        NotificationCenter.default.post(name: .myNotification, object: nil, userInfo: data)
        
    }
    
}
