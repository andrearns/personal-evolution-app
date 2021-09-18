//
//  LoginViewController.swift
//  PersonalEvolution
//
//  Created by Caroline Revay on 17/09/21.
//

import UIKit
import ALCameraViewController

class LoginViewController: UIViewController {

    @IBOutlet var saveUserButton: UIButton!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var photoButton: UIButton!
    @IBOutlet var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    var newUser = User(name: "", image: nil, recordID: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoButton.layer.cornerRadius = photoButton.frame.width / 2
        photoButton.clipsToBounds = true
        userNameTextField.layer.cornerRadius = 15
        userNameTextField.delegate = self
        userNameTextField.text = ""
        saveUserButton.layer.cornerRadius = 15
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)

        if endFrameY >= UIScreen.main.bounds.size.height {
            self.keyboardHeightLayoutConstraint?.constant = 0.0
            self.topLayoutConstraint.constant = 100.0
        } else {
            self.keyboardHeightLayoutConstraint?.constant = (endFrame?.size.height)!/4
            self.topLayoutConstraint.constant = -(endFrame?.size.height)!/4
        }

        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil)
    }
    
    @IBAction func chooseUserImage(_ sender: Any) {
        let croppingParameters = CroppingParameters(isEnabled: true, allowResizing: false, allowMoving: true, minimumSize: CGSize(width: 300, height: 150))
        
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true) { [weak self] image, asset in
            self?.photoButton.setImage(image, for: .normal)
            self?.newUser.image = image
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func createUser(_ sender: Any) {
        newUser.name = userNameTextField.text ?? ""
        
        CloudKitHelper.save(user: newUser)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
        present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func verifyIfUsernameAlreadyExist(_ sender: Any) {
//        CloudKitHelper.doesNameAlreadyExist(username: userNameTextField.text!, equalTo: userNameTextField.text!) { (result) in
//            print(result)
//        }
        print("Verificar se o nome já existe")
        
    }
    @IBAction func editingDidBegin(_ sender: Any) {
        if !userNameTextField.text!.starts(with: "@") {
            userNameTextField.text = "@\(userNameTextField.text ?? "")"
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
