//
//  CheckinViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 06/09/21.
//

import UIKit
import ALCameraViewController

class CheckinViewController: UIViewController {

    var habit: Habit!
    
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var descriptionTextField: CustomTextField!
    @IBOutlet var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    var newCheckin = Checkin(image: nil, description: "", date: Date())
    var currentUser = User(name: "", imageData: nil, recordID: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUser.name = UserSingleton.shared.name!
        self.currentUser.imageData = UserSingleton.shared.imageData!
        self.currentUser.recordID = UserSingleton.shared.recordID ?? UserSingleton.shared.fetchUserRecordID()
        
        print(self.currentUser)
        
        addImageButton.layer.cornerRadius = 15
        saveButton.layer.cornerRadius = 15
        descriptionTextField.layer.cornerRadius = 15
        descriptionTextField.delegate = self
        
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
            self.topLayoutConstraint.constant = 30.0
        } else {
            self.keyboardHeightLayoutConstraint?.constant = (endFrame?.size.height)!/2
            self.topLayoutConstraint.constant = -(endFrame?.size.height)!/2
        }
        
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil)
    }
    
    @IBAction func addImage(_ sender: Any) {
        let croppingParameters = CroppingParameters(isEnabled: true, allowResizing: false, allowMoving: true, minimumSize: CGSize(width: 300, height: 300))
        
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: false, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true) { [weak self] image, asset in
            self?.addImageButton.setBackgroundImage(image, for: .normal)
            self?.newCheckin.image = image
            self?.addImageButton.setTitle("", for: .normal)
            self?.addImageButton.setImage(nil, for: .normal)
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func saveCheckin(_ sender: Any) {
        newCheckin.image = addImageButton.currentBackgroundImage
        newCheckin.description = descriptionTextField.text!
        CloudKitHelper.save(checkin: newCheckin, habit: self.habit, userRecordID: self.currentUser.recordID!)
        print("Checkin done at \(Date())")
        self.dismiss(animated: true)
    }
}

extension CheckinViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

