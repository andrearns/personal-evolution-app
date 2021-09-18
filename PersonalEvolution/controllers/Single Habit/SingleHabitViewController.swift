//
//  SingleHabitViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 30/08/21.
//

import UIKit
import CloudKit

class SingleHabitViewController: UIViewController {

    var habit: Habit!
    var currentUser = User(name: "", imageData: nil, recordID: nil)
    
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
        Checkin(image: UIImage(named: "galleryImageTest"), description: "descrição 1", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest2"), description: "descrição 2", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest3"), description: "descrição 3", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest4"), description: "descrição 4", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest3"), description: "descrição 5", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest2"), description: "descrição 6", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest"), description: "descrição 1", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest2"), description: "descrição 2", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest3"), description: "descrição 3", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest4"), description: "descrição 4", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest3"), description: "descrição 5", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest2"), description: "descrição 6", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest"), description: "descrição 1", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest2"), description: "descrição 2", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest3"), description: "descrição 3", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest4"), description: "descrição 4", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest3"), description: "descrição 5", date: Date()),
        Checkin(image: UIImage(named: "galleryImageTest2"), description: "descrição 6", date: Date()),
    ]
    
    var groupCheckins: [Checkin] = []
    
    var usersParticipating: [User] = [
        User(name: "André", imageData: UIImage(named: "profileImageTest")?.pngData()),
        User(name: "Bruno", imageData: UIImage(named: "profileImageTest")?.pngData()),
        User(name: "Carol", imageData: UIImage(named: "profileImageTest")?.pngData()),
        User(name: "Nati", imageData: UIImage(named: "profileImageTest")?.pngData()),
        User(name: "Rafael", imageData: UIImage(named: "profileImageTest")?.pngData()),
        User(name: "Alfredo", imageData: UIImage(named: "profileImageTest")?.pngData()),
        User(name: "Jorginho", imageData: UIImage(named: "profileImageTest")?.pngData()),
        User(name: "Babiruba", imageData: UIImage(named: "profileImageTest")?.pngData()),
        User(name: "Jujubinha", imageData: UIImage(named: "profileImageTest")?.pngData()),
        User(name: "Princesa caroço", imageData: UIImage(named: "profileImageTest")?.pngData()),
        User(name: "Rei gelado", imageData: UIImage(named: "profileImageTest")?.pngData()),
        User(name: "Flin", imageData: UIImage(named: "profileImageTest")?.pngData()),
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
        
        self.currentUser.name = UserSingleton.shared.name!
        self.currentUser.imageData = UserSingleton.shared.imageData!
        self.currentUser.recordID = UserSingleton.shared.recordID ?? UserSingleton.shared.fetchUserRecordID()
        print(self.currentUser)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.fetchHabitCheckinList()
            self.drawGallery(buttons: self.personalGalleryButtons, checkins: self.personalCheckins)
            self.drawUserImages(buttons: self.usersProfileImageButtons, users: self.usersParticipating)
        }
    }
    
    func fetchHabitCheckinList() {
        DispatchQueue.main.async {
            var checkinList: [Checkin] = []
            CloudKitHelper.fetchCheckins { (result) in
                switch result {
                case .success(let newItem):
                    checkinList.append(newItem)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.groupCheckins = checkinList.filter {
                    $0.habitRef?.recordID == self.habit.recordID
                }
                self.drawGallery(buttons: self.groupGalleryButtons, checkins: self.groupCheckins)
                print(self.groupCheckins)
            }
        }
    }
    
    func drawGallery(buttons: [UIButton], checkins: [Checkin]) {
        
        if checkins.count > 5 {
            
            for i in 0..<4 {
                buttons[i].setBackgroundImage(checkins[i].image, for: .normal)
            }
            buttons[4].backgroundColor = UIColor(named: "TextFieldBackgroundColor")
            buttons[4].setImage(UIImage(systemName: "chevron.right"), for: .normal)
            
        } else if checkins.count == 5 {
            
            for i in 0..<5 {
                buttons[i].setBackgroundImage(checkins[i].image, for: .normal)
            }
            
        } else {
            for i in 0..<checkins.count {
                buttons[i].setBackgroundImage(checkins[i].image, for: .normal)
            }
        }
    }
    
    func drawUserImages(buttons: [UIButton], users: [User]) {
        if users.count > 7 {
            for i in 0..<7 {
                buttons[i].setBackgroundImage(UIImage(data: users[i].imageData!), for: .normal)
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
                buttons[i].setBackgroundImage(UIImage(data: users[i].imageData!), for: .normal)
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
        vc?.popUp = PopUp(image: UIImage(named: "defaultpopupImage")!, title: "Convide seus amiguinhos pra participar!", subtitle: "Evoluir em conjunto é mais legal e pode te ajudar a se motivar em momentos difíceis :)", buttonTitle: "   Compartilhar", type: .inviteFriends)
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
        vc?.habit = self.habit
        
        if sender.tag == 0 {
            vc?.retrospectiveType = .personal
            vc?.checkinsList = self.personalCheckins
        } else if sender.tag == 1 {
            vc?.retrospectiveType = .group
            vc?.checkinsList = self.groupCheckins
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
