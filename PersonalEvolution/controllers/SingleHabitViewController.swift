//
//  SingleHabitViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 30/08/21.
//

import UIKit

class SingleHabitViewController: UIViewController {

    var habit: Habit!

    @IBOutlet var habitTitleLabel: UILabel!
    @IBOutlet var habitImageView: UIImageView!
    @IBOutlet var habitDescriptionLabel: UILabel!
    @IBOutlet var checkinButton: UIButton!
    @IBOutlet var inviteButton: UIButton!
    @IBOutlet var playPersonalRetrospectiveButton: UIButton!
    @IBOutlet var playGroupRetrospectiveButton: UIButton!
    @IBOutlet var personalGalleryButtons: [UIButton]!
    @IBOutlet var groupGalleryButtons: [UIButton]!
    
    var personalCheckins: [Checkin] = [
        Checkin(image: UIImage(named: "galeryImageTest"), description: "descrição 1", user: nil, date: Date()),
        Checkin(image: UIImage(named: "galeryImageTest"), description: "descrição 2", user: nil, date: Date()),
        Checkin(image: UIImage(named: "galeryImageTest"), description: "descrição 3", user: nil, date: Date()),
        Checkin(image: UIImage(named: "galeryImageTest"), description: "descrição 4", user: nil, date: Date()),
        Checkin(image: UIImage(named: "galeryImageTest"), description: "descrição 5", user: nil, date: Date()),
        Checkin(image: UIImage(named: "galeryImageTest"), description: "descrição 6", user: nil, date: Date()),
    ]
    
    var groupCheckins: [Checkin] = [
        Checkin(image: UIImage(named: "galeryImageTest"), description: "descrição 1", user: nil, date: Date()),
        Checkin(image: UIImage(named: "galeryImageTest"), description: "descrição 2", user: nil, date: Date()),
        Checkin(image: UIImage(named: "galeryImageTest"), description: "descrição 3", user: nil, date: Date()),
        Checkin(image: UIImage(named: "galeryImageTest"), description: "descrição 4", user: nil, date: Date()),
        Checkin(image: UIImage(named: "galeryImageTest"), description: "descrição 5", user: nil, date: Date()),
        Checkin(image: UIImage(named: "galeryImageTest"), description: "descrição 6", user: nil, date: Date()),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        habitTitleLabel.text = habit.name
        habitDescriptionLabel.text = habit.description
        checkinButton.layer.cornerRadius = 15
        inviteButton.layer.cornerRadius = 15
        playPersonalRetrospectiveButton.layer.cornerRadius = 15
        playGroupRetrospectiveButton.layer.cornerRadius = 15
        
        if habit.image != nil {
            habitImageView.image = CropImage.shared.crop(image: habit.image!, aspectRatio: 1.5)
        }
        drawGallery(buttons: personalGalleryButtons, checkins: personalCheckins)
        drawGallery(buttons: groupGalleryButtons, checkins: groupCheckins)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func drawGallery(buttons: [UIButton], checkins: [Checkin]) {
        for i in 0..<4 {
            buttons[i].setBackgroundImage(checkins[i].image, for: .normal)
        }
    }
    
    @IBAction func backToHabits(_ sender: Any) {
        if navigationController?.viewControllers == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "TabBar") as? UITabBarController
            vc?.tabBarController?.selectedIndex = 2
            present(vc!, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func checkin(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Checkin") as? CheckinViewController
        vc!.habit = self.habit
        navigationController?.showDetailViewController(vc!, sender: self)
    }
    
    @IBAction func inviteFriends(_ sender: Any) {
        print("Open pop up")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Pop Up") as? PopUpViewController
        vc?.habit = self.habit
        vc?.popUp = PopUp(image: UIImage(named: "defaultPopupImage")!, title: "Convide seus amiguinhos pra participar!", subtitle: "Evoluir em conjunto é mais legal e pode te ajudar a se motivar em momentos difíceis :)", buttonTitle: "   Compartilhar", type: .inviteFriends)
        present(vc!, animated: true)
    }
    
    @IBAction func editHabit(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "CreateOrEditHabit") as? CreateOrEditHabitViewController
        vc?.habit = self.habit
        navigationController?.showDetailViewController(vc!, sender: self)
    }
    
    @IBAction func openPhotoGallery(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "PhotoGallery") as? PhotoGalleryViewController
        
        if sender.tag == 0 {
            vc?.galleryType = .personal
            vc?.checkinList = personalCheckins
        } else if sender.tag == 1 {
            vc?.galleryType = .group
            vc?.checkinList = groupCheckins
        }
        present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func playRetrospective(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Retrospective") as? RetrospectiveViewController
        
        if sender.tag == 0 {
            vc?.retrospectiveType = .personal
        } else if sender.tag == 1 {
            vc?.retrospectiveType = .group
        }
        
        present(vc!, animated: true, completion: nil)
    }
}

enum RetrospectiveType {
    case personal
    case group
}
