//
//  PhotoGalleryViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 14/09/21.
//

import UIKit

class PhotoGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var checkinList: [Checkin]!
    var galleryType: GalleryType!
    let collectionSpacing = CGFloat(1)
    
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
        let checkin = checkinList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FullScreenImageView") as! FullScreenImageViewController
        vc.checkin = checkin
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.width
        let columns = CGFloat(4)
        let cellWidth = (collectionWidth - (columns - 1) * collectionSpacing) / columns
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    
}

enum GalleryType {
    case personal
    case group
}


