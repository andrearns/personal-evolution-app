//
//  LoginViewController.swift
//  PersonalEvolution
//
//  Created by Caroline Revay on 17/09/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var saveUserButton: UIButton!
    @IBOutlet var userNameTextField: CustomTextField!
    @IBOutlet var photoButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        photoButton.layer.cornerRadius = photoButton.frame.width/2
        userNameTextField.layer.cornerRadius = 15
        saveUserButton.layer.cornerRadius = 15
        
    }

}
