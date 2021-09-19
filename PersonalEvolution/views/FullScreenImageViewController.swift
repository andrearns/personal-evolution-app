//
//  FullScreenImageViewController.swift
//  PersonalEvolution
//
//  Created by Luísa Bacichett Trabulci on 16/09/21.
//

import UIKit

class FullScreenImageViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageSubtitle: UILabel!
    @IBOutlet var imageUser: UILabel!
    @IBOutlet var userImageView: UIImageView!
    var user = User(name: "claudin", imageData: UIImage(named: "defaultpopupImage")?.pngData())
    var checkin: Checkin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = checkin.image
        imageSubtitle.text = checkin.description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        imageUser.text = "\(user.name) - \(dateFormatter.string(from: checkin.date))"
        userImageView.image = UIImage(data: user.imageData!)
    }
}
