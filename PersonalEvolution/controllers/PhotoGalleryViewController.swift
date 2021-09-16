//
//  PhotoGalleryViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 14/09/21.
//

import UIKit

class PhotoGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var checkinList: [Checkin]!
    var galleryType: GalleryType!
    
    @IBOutlet var galleryCollectionView: UICollectionView!
    @IBOutlet var galleryCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        
        if galleryType == .personal {
            titleLabel.text = "Galeria pessoal"
        }
        else {
            titleLabel.text = "Galeria do grupo"
        }
        galleryCountLabel.text = "\(checkinList.count) Fotos"

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return checkinList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryCollectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? GalleryCollectionViewCell
        cell?.photoImageView.image = checkinList[indexPath.row].image
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

enum GalleryType {
    case personal
    case group
}


