//
//  BookDetailTableViewCell.swift
//  URLDataParsing
//
//  Created by Milton Palaguachi on 9/23/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    @IBOutlet weak var firstTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add keyword
        self.firstTextField.becomeFirstResponder()
    }
    
    @IBAction func toggle(_ switch: UISwitch) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.firstTextField.resignFirstResponder()
        }
    }
    


}
extension BookCollectionViewController: UITextFieldDelegate {
    
    
}
extension BookCollectionViewController: UITextViewDelegate {
    
}
extension BookCollectionViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        10
    }
    
    
}
extension BookCollectionViewController: UIPickerViewDelegate{
    
}
