//
//  CreateNewHabitViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 01/09/21.
//
import UIKit

class CreateNewHabitViewController: UIViewController {
    
    @IBOutlet var habitNameTextField: UITextField!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var descriptionPlaceholderLabel: UILabel!
    @IBOutlet var isPublicSwitch: UISwitch!
    
    var onSave: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createButton.layer.cornerRadius = 10
        descriptionTextView.layer.cornerRadius = 10
    }

    @IBAction func createNewHabit(_ sender: Any) {
        // Using Int because CloudKit does not accept Bool
        // 0 -> False
        // 1 -> True
        var isPublic: Int = 0
        if isPublicSwitch.isOn {
            isPublic = 1
        }
        
        let newHabit = Habit(name: habitNameTextField.text!, description: descriptionTextView.text, isPublic: isPublic)
        CloudKitHelper.save(habit: newHabit)
        
        self.dismiss(animated: true, completion: nil)
    }
}
