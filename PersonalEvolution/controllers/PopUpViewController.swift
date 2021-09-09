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
            
            let message = "Descrição"
            let image : UIImage = popUp.image
            
            if let link = NSURL(string: "https://andrearns.com.br") {
                let objectsToShare = [message, link, image] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
//                activityVC.popoverPresentationController?.sourceView = self.view
//                activityVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
//                activityVC.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
//
//                activityVC.isModalInPresentation = true
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.postToTencentWeibo]
                self.present(activityVC, animated: true, completion: nil)
            }
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
