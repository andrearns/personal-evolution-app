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
    @IBOutlet var personalGalleryButtons: [UIButton]!
    
    var checkins: [Checkin] = [
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
        
        if habit.image != nil {
            habitImageView.image = CropImage.shared.crop(image: habit.image!, aspectRatio: 1.5)
        }
        drawPersonalGallery()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func drawPersonalGallery() {
        for i in 0..<personalGalleryButtons.count - 1 {
            personalGalleryButtons[i].setBackgroundImage(checkins[i].image, for: .normal)
            // Not working
            personalGalleryButtons[i].layer.cornerRadius = 15
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
    
    @IBAction func modifyHabit(_ sender: Any) {
        let updatedHabit = Habit(id: self.habit.id, recordID: self.habit.recordID, name: "AAAA", image: nil, description: "AAAA", checkinList: [])
        CloudKitHelper.modify(habit: updatedHabit) { (result) in
            switch result {
            case .success(let habit):
                print("Successfuly edited habit")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func openPersonalGallery(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "PhotoGallery") as? PhotoGalleryViewController
        vc?.checkinList = self.checkins
        vc?.galleryType = .personal
        present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func playRestrospective(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Retrospective") as? RetrospectiveViewController
        present(vc!, animated: true, completion: nil)
    }
    
}
