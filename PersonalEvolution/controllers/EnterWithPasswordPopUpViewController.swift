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
        print("1.Search for habit with this exact password in CloudKit")
        
        print("2. Join habit making references beetween user and habit")
        
        self.dismiss(animated: true, completion: nil)
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
