//
//  BookListTableViewCell.swift
//  URLDataParsing
//
//  Created by Milton Palaguachi on 9/22/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class BookListTableViewCell: ListTableViewCell {

    static let identifier = "BookListTableViewCell"

         
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
      static func nib() -> UINib {
          return UINib(nibName: "BookListTableViewCell", bundle: nil)
          
      }
    
}
