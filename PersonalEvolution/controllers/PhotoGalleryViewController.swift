//
//  PhotoGalleryViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 14/09/21.
//

import UIKit

class PhotoGalleryViewController: UIViewController {
    
    var checkinList: [Checkin]!
    var galleryType: GalleryType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

enum GalleryType {
    case personal
    case group
}
