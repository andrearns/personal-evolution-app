//
//  PhotoGalleryViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 14/09/21.
//

import UIKit

class PhotoGalleryViewController: UIViewController {

    @IBOutlet var photosCountLabel: UILabel!
    @IBOutlet var galleryTitleLabel: UILabel!
    
    var checkinList: [Checkin]!
    var galleryType: GalleryType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photosCountLabel.text = "\(checkinList.count) fotos"
        
        if galleryType == .group {
            galleryTitleLabel.text = "Galeria do grupo"
        } else {
            galleryTitleLabel.text = "Galeria pessoal"
        }
    }


}

enum GalleryType {
    case personal
    case group
}
