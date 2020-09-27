//
//  TextFieldTableViewCell.swift
//  URLDataParsing
//
//  Created by Milton Palaguachi on 9/23/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var textViewHeight: NSLayoutConstraint!

       func setProperties(data: String) {
        textView.text = data
        
        textViewHeight.constant = textView.contentSize.height + 100
//        textViewHeight.constant = 20
        
        

       }

}
