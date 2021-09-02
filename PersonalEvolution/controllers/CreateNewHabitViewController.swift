//
//  CreateNewHabitViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 01/09/21.
//
import CloudKit
import UIKit

class CreateNewHabitViewController: UIViewController {

    private let database = CKContainer(identifier: "iCloud.PersonalEvolution").publicCloudDatabase
    
    var onSave: (() -> Void)?
    
    @IBOutlet var habitNameTextField: UITextField!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var isPublicSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createButton.layer.cornerRadius = 10
        descriptionTextView.layer.cornerRadius = 10
    }

    @IBAction func saveHabit(_ sender: Any) {
        let record = CKRecord(recordType: "Habit")
        record.setValue(habitNameTextField.text, forKey: "Name")
        record.setValue(descriptionTextView.text, forKey: "Description")
        
        // Using Int because CloudKit does not accept Bool
        // 0 -> False
        // 1 -> True
        var isPublic: Int = 0
        
        if isPublicSwitch.isOn {
            isPublic = 1
        }
        
        record.setValue(isPublic, forKey: "isPublic")
        
        database.save(record) { record, error in
            if record != nil, error == nil {
                print("Salvo")
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
