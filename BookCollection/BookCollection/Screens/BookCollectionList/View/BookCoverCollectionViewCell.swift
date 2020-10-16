//
//  BookCoverCollectionViewCell.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 9/27/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class BookCoverCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
  
    public func configure(volumeInfo: VolumeInfo) {
        titleLabel.text = volumeInfo.title
        subtitleLabel.text = volumeInfo.subtitle
        
        subtitleLabel.isHidden = volumeInfo.subtitle?.isEmpty ?? true
        titleLabel.isHidden = volumeInfo.title?.isEmpty ?? true
        
        guard let thumbNail = volumeInfo.imageLinks?.smallThumbnail,
            let url = URL(string: thumbNail) else { return }
        self.imageView.downloadImage(with: url)
    }
}
