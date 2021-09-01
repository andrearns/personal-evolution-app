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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createButton.layer.cornerRadius = 10
    }

    @IBAction func saveHabit(_ sender: Any) {
        let record = CKRecord(recordType: "Habit")
        record.setValue(habitNameTextField.text, forKey: "Name")
        
        database.save(record) { record, error in
            if record != nil, error == nil {
                print("Salvo")
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }

}
