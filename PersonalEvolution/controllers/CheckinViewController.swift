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
    
    var newCheckin = Checkin(image: nil, description: "", user: nil, date: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addImageButton.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 10
        descriptionTextField.layer.cornerRadius = 10
        descriptionTextField.delegate = self
    }
    
    @IBAction func addImage(_ sender: Any) {
        let croppingParameters = CroppingParameters(isEnabled: true, allowResizing: false, allowMoving: true, minimumSize: CGSize(width: 300, height: 150))
        
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
        CloudKitHelper.save(checkin: newCheckin, habit: self.habit)
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
