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
    
    var user = User(name: "", imageData: nil)
    var checkin: Checkin!
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = checkin.image
        imageSubtitle.text = checkin.description
        dateFormatter.dateFormat = "dd/MM/yyyy"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            CloudKitHelper.searchUserWithRecordID(recordID: self.checkin.userRef!.recordID) { result in
                switch result {
                case .success(let user):
                    print("Usuário dono do checkin:")
                    print(user)
                    print("_________________________")
                    self.user = user
                    self.imageUser.text = "\(self.user.name) - \(self.dateFormatter.string(from: self.checkin.date))"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        if self.user.imageData != nil {
                            self.userImageView.image = UIImage(data: self.user.imageData!)
                            self.userImageView.clipsToBounds = true
                            self.userImageView.autoresizesSubviews = true
                            print(self.user.imageData!)
                        } else {
                            self.userImageView.image = UIImage(named: "defaultpopupImage")
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
