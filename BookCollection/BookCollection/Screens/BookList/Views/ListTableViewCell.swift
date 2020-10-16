// ListTableViewCell.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 9/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageBookView: UIImageView! {
        didSet {
            imageBookView.layer.cornerRadius = imageBookView.frame.width/8
            imageBookView.layer.borderWidth = 2
            imageBookView.layer.borderColor = UIColor.black.cgColor
            imageBookView.layer.backgroundColor = UIColor.green.cgColor
            imageBookView.contentMode = .scaleToFill
        }
    }
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var booksubtitleLabel: UILabel!
    
    func setProterties( item: VolumeInfo) {
       
        bookTitleLabel.text = item.title
        bookTitleLabel.numberOfLines = 0
        booksubtitleLabel.text = item.subtitle
        bookTitleLabel.numberOfLines = 0
        booksubtitleLabel.isHidden = item.subtitle?.isEmpty ?? true
        
        guard let thumbNail = item.imageLinks?.smallThumbnail, let url = URL(string: thumbNail) else { return }
        self.imageBookView.downloadImage(with: url)
    }
}

extension UIImageView {
    
    func downloadImage(with url: URL) {
        DispatchQueue.global().async {
            do {
                let data  = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            } catch {
                print(error)
            }
        }
    }
}
