//
//  ImageCollectionViewCell.swift
//  Unsplash Kraken
//
//  Created by William Santoso on 25/11/20.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var imageBackgroundVIew: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageBackgroundVIew.layer.shadowRadius = 5
        imageBackgroundVIew.layer.cornerRadius = 10
        imageBackgroundVIew.layer.masksToBounds = true
    }

}
