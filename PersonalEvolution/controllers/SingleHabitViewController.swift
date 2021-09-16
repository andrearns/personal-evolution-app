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
    @IBOutlet var usersProfileImageButtons: [UIButton]!
    
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
    
    var usersParticipating: [User] = [
        User(name: "André", image: UIImage(named: "profileImageTest")),
        User(name: "Bruno", image: UIImage(named: "profileImageTest")),
        User(name: "Carol", image: UIImage(named: "profileImageTest")),
        User(name: "Nati", image: UIImage(named: "profileImageTest")),
        User(name: "Rafael", image: UIImage(named: "profileImageTest")),
        User(name: "Alfredo", image: UIImage(named: "profileImageTest")),
        User(name: "Jorginho", image: UIImage(named: "profileImageTest")),
        User(name: "Babiruba", image: UIImage(named: "profileImageTest")),
//        User(name: "Jujubinha", image: UIImage(named: "profileImageTest")),
//        User(name: "Princesa caroço", image: UIImage(named: "profileImageTest")),
//        User(name: "Rei gelado", image: UIImage(named: "profileImageTest")),
//        User(name: "Flin", image: UIImage(named: "profileImageTest")),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        habitTitleLabel.text = habit.name
        habitDescriptionLabel.text = habit.description
        checkinButton.layer.cornerRadius = 15
        inviteButton.layer.cornerRadius = 15
        playPersonalRetrospectiveButton.layer.cornerRadius = 15
        playGroupRetrospectiveButton.layer.cornerRadius = 15
        checkinButton.dropShadow()
        playGroupRetrospectiveButton.dropShadow()
        playPersonalRetrospectiveButton.dropShadow()
        inviteButton.dropShadow()
        
        if habit.image != nil {
            habitImageView.image = CropImage.shared.crop(image: habit.image!, aspectRatio: 1.5)
        }
        
        drawGallery(buttons: personalGalleryButtons, checkins: personalCheckins)
        drawGallery(buttons: groupGalleryButtons, checkins: groupCheckins)
        drawUserImages(buttons: usersProfileImageButtons, users: usersParticipating)
    }
    
    func drawGallery(buttons: [UIButton], checkins: [Checkin]) {
        for i in 0..<4 {
            buttons[i].setBackgroundImage(checkins[i].image, for: .normal)
            buttons[i].layer.cornerRadius = 15
        }
    }
    
    func drawUserImages(buttons: [UIButton], users: [User]) {
        if users.count > 7 {
            for i in 0..<7 {
                buttons[i].setBackgroundImage(users[i].image, for: .normal)
                buttons[i].tag = 1
            }
            buttons[7].layer.borderWidth = 2
            buttons[7].layer.borderColor = UIColor.systemGray3.cgColor
            buttons[7].setTitle("+\(users.count - 7)", for: .normal)
            buttons[7].setTitleColor(UIColor.systemGray3, for: .normal)
            buttons[7].layer.cornerRadius = buttons[7].frame.width / 2
            buttons[7].tag = 1
        } else {
            for i in 0..<users.count {
                buttons[i].setBackgroundImage(users[i].image, for: .normal)
                buttons[i].tag = 1
            }
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
    
    @IBAction func openUsersParticipatingList(_ sender: UIButton) {
        if sender.tag == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "usersParticipating") as? UsersParticipatingListViewController
            vc?.usersList = usersParticipating
            navigationController?.showDetailViewController(vc!, sender: self)
        }
    }
}

enum RetrospectiveType {
    case personal
    case group
}
