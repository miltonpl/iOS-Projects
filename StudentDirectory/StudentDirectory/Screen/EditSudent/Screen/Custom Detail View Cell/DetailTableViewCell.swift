//
//  DetailTableViewCell.swift
//  StudentTableView
//
//  Created by Milton Palaguachi on 9/23/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit
protocol DetailTableViewCellDelagation: class {
    func updateTextField(text: String, whichTextField: String)
    func currentTextFied(textField: UITextField)
}

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dataNameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    static let identifier = "DetailTableViewCell"
    weak var delegation:DetailTableViewCellDelagation?
    
    func setProperties(dataName: String, textField: String) {
        self.dataNameLabel.text = dataName
        self.textField.text = textField
        self.textField.clearButtonMode = .whileEditing
        self.textField.delegate = self
    }
    static func nib() -> UINib {
        return UINib(nibName: "DetailTableViewCell", bundle: nil)
    }
}

extension DetailTableViewCell: UITextFieldDelegate {
    //MARK: - shouldChangeCharactersIn Method Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        // make sure the result is under allowed and valid characters
        var count = false
        if updatedText.hasSuffix(" "){ return false } //not empty space allowed
        self.textField.textColor = .black
        
        switch dataNameLabel.text {
        case "First Name", "Last Name":
            if !updatedText.isValidName { self.textField.textColor = .red }
            count = updatedText.count <= Constant.maxNameCharacters
            break
        case "Number":
            if !updatedText.isPhoneNumber { return false }
            if updatedText.count <= Constant.minNumberCharacters { self.textField.textColor = .red }
            count = updatedText.count <= Constant.maxNumberCharacters
            break
        case "Email":
            if !updatedText.isValidEmail { self.textField.textColor = .red }
            count = updatedText.count <= Constant.maxEmailCharacters
            break
        default:
            break
        }
        return count
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let whichtextField = dataNameLabel.text, let text = self.textField.text {
            delegation?.updateTextField(text: text, whichTextField: whichtextField )
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegation?.currentTextFied(textField: textField)
    }
}
