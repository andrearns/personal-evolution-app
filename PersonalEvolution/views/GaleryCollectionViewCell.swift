//
//  galeryCollectionViewCell.swift
//  PersonalEvolution
//
//  Created by André Arns on 14/09/21.
//

import UIKit

class GaleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var checkinImageView: UIImageView!
    
    override func draw(_ rect: CGRect) {
        self.checkinImageView.layer.cornerRadius = 15
    }
}
