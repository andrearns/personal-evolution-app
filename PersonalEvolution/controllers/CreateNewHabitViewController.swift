//
//  CreateNewHabitViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 01/09/21.
//
import UIKit

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
        print("Adicionar imagem ao hábito")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
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

extension CreateNewHabitViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            addImageButton.setBackgroundImage(image, for: .normal)
            addImageButton.setTitle("", for: .normal)
            addImageButton.setImage(nil, for: .normal)
            addImageButton.layer.cornerRadius = 10
            newHabit.imageData = image.pngData()
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
