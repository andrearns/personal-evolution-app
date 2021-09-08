//
//  PopUpViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 08/09/21.
//

import UIKit

class PopUpViewController: UIViewController {

    var popUp: PopUp!
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var popUpImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 10
        actionButton.layer.cornerRadius = 10
        
        popUpImageView.image = popUp.image
        titleLabel.text = popUp.title
        subtitleLabel.text = popUp.subtitle
        actionButton.setTitle(popUp.buttonTitle, for: .normal)
    }
    
    @IBAction func pressButton(_ sender: Any) {
        if popUp.type == .inviteFriends {
            print("Abrir compartilhamento")
            
        }
        
        self.dismiss(animated: true)
    }
    
    @IBAction func touchOutsidePopup(_ sender: Any) {
        print("Pop up closed")
        self.dismiss(animated: true)
    }
    
}

struct PopUp {
    var image: UIImage
    var title: String
    var subtitle: String
    var buttonTitle: String
    var type: PopUpType
}

enum PopUpType {
    case inviteFriends
}
