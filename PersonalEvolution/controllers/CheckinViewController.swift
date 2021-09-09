//
//  CheckinViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 06/09/21.
//

import UIKit

class CheckinViewController: UIViewController {

    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var descriptionTextField: UITextField!
    
    var newCheckin = Checkin(image: nil, description: "", user: nil, date: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addImageButton.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 10
    }
    
    @IBAction func addImage(_ sender: Any) {
        print("Adicionar imagem ao checkin")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func saveCheckin(_ sender: Any) {
        newCheckin.image = addImageButton.currentBackgroundImage
        newCheckin.description = descriptionTextField.text!
        CloudKitHelper.save(checkin: newCheckin)
        print("Checkin done at \(Date())")
        self.dismiss(animated: true)
    }
}

extension CheckinViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            addImageButton.setBackgroundImage(image, for: .normal)
            newCheckin.image = image
            addImageButton.setTitle("", for: .normal)
            addImageButton.setImage(nil, for: .normal)
            addImageButton.layer.cornerRadius = 10
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
