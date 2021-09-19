//
//  EnterWithPasswordPopUpViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 19/09/21.
//

import UIKit

class EnterWithPasswordPopUpViewController: UIViewController {

    @IBOutlet var popUpBackgroundView: UIView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUpBackgroundView.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
        joinButton.layer.cornerRadius = 15
        
        passwordTextField.delegate = self
        passwordTextField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func joinGroup(_ sender: Any) {
        print(passwordTextField.text)
        var searchedHabit = Habit(recordID: nil, name: "", image: nil, description: "", checkinRefs: nil, frequency: [], password: "")
        print("1.Search for habit with this exact password in CloudKit")
        CloudKitHelper.searchHabitWithPassword(password: passwordTextField.text!) { result in
            switch result {
            case .success(let habit):
                print(habit)
                searchedHabit = habit
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if searchedHabit.recordID == nil {
                print("Nenhum grupo encontrado")
                self.dismiss(animated: true, completion: nil)
            }
            else {
                DispatchQueue.main.async {
                    print("2. Join habit making references beetween user and habit")
                    
                    print("3. Show SingleHabitVC with habit found")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "singleHabit") as! SingleHabitViewController
                    vc.habit = searchedHabit
                    self.present(vc, animated: true)
                }
            }
        }
    }
}

extension EnterWithPasswordPopUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 4
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
