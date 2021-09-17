//
//  GalleryCollectionViewCell.swift
//  PersonalEvolution
//
//  Created by Luísa Bacichett Trabulci on 15/09/21.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var photoImageView: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = contentView.bounds
    }
}
