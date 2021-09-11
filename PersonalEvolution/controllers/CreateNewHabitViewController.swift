//
//  CreateNewHabitViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 01/09/21.
//
import UIKit
import ALCameraViewController
import Photos

class CreateNewHabitViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var habitNameTextField: CustomTextField!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var descriptionPlaceholderLabel: UILabel!
    @IBOutlet var addImageButton: UIButton!
    
    var onSave: (() -> Void)?
    
    var newHabit = Habit(name: "", description: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        habitNameTextField.layer.cornerRadius = 10
        habitNameTextField.attributedPlaceholder = NSAttributedString(string: "Nome do hábito", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        
        addImageButton.layer.cornerRadius = 10
        
        createButton.layer.cornerRadius = 10
        
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.delegate = self
        descriptionTextView.text = "Digite aqui a descrição e as regras"
        descriptionTextView.textColor = UIColor.systemGray
        descriptionTextView.leftSpace()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Digite aqui a descrição e as regras"
            textView.textColor = UIColor.systemGray
        }
    }

    @IBAction func addImage(_ sender: Any) {
        let croppingParameters = CroppingParameters(isEnabled: true, allowResizing: false, allowMoving: true, minimumSize: CGSize(width: 300, height: 150))

        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true) { [weak self] image, asset in

            // Do something with your image here
            self?.addImageButton.setBackgroundImage(image, for: .normal)
            self!.addImageButton.setImage(nil, for: .normal)
            self!.addImageButton.layer.cornerRadius = 10
            if image?.pngData() != nil {
                self!.newHabit.imageData = image!.pngData()
            }
            self?.dismiss(animated: true, completion: nil)
        }
        cameraViewController.modalPresentationStyle = .fullScreen

        present(cameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func createNewHabit(_ sender: Any) {
        newHabit.name = habitNameTextField.text!
        newHabit.description = descriptionTextView.text
        CloudKitHelper.save(habit: newHabit)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "singleHabit") as! SingleHabitViewController
        vc.habit = newHabit
        present(vc, animated: true)
    }
}
