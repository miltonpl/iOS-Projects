//
//  ViewController.swift
//  PassDataBetweenViewControllers
//
//  Created by Milton Palaguachi on 9/29/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - IBAction
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    //MARK: - Store Properties
    var setColor: UIColor?
    var whichColor = false
    var message:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Screen 1"
        self.setupUI()
    }
    //MARK: - Action Fuctions
    @IBAction func tappedNext(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let screen2VC = storyboard.instantiateViewController(withIdentifier: "ViewController2") as? ViewController2 else {return }
        let msg = message ?? ""
        if let color = setColor {
            screen2VC.configure(color: color, message: msg)
        }
        self.observerData()
        self.navigationController?.pushViewController(screen2VC, animated: true)
    }
    
    @IBAction func tapColor(_ sender: UIButton) {
        self.message = "Color was set in Screen 1"
        whichColor = whichColor ? false:true
        if whichColor {
            setColor =  .green
            colorButton.backgroundColor =  .white
            messageLabel.text = "Current Color is green you can change to white "
        }
        else {
            setColor =  .white
            colorButton.backgroundColor =  .green
            messageLabel.text = "Current Color is white you can change to green "
        }
        self.view.backgroundColor = setColor
    }
    //MARK: - setuUI
    func setupUI() {
        colorButton.setTitle("Change Color", for: .normal)
        colorButton.layer.cornerRadius = colorButton.bounds.width/2
        colorButton.layer.borderWidth = 3
        colorButton.layer.borderColor = UIColor.black.cgColor
        colorButton.setTitle("Change Color", for: .normal)
        messageLabel.layer.borderColor = UIColor.brown.cgColor
        messageLabel.layer.borderWidth = 4
        messageLabel.text = "Hello Welcome to Screen 1\n The default color is white but it can be change to green "
        nextButton.layer.borderWidth = 3
        nextButton.layer.borderColor = UIColor.gray.cgColor
    }
}

//MARK:- Abserver Function
extension ViewController {
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
    
}
