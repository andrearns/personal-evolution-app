//
//  CreateNewHabitViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 01/09/21.
//
import UIKit
import ALCameraViewController

class CreateNewHabitViewController: UIViewController {
    
    @IBOutlet var habitNameTextField: CustomTextField!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var descriptionPlaceholderLabel: UILabel!
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var daysOfWeekCollectionView: UICollectionView!
    
    var onSave: (() -> Void)?
    
    var newHabit = Habit(name: "", image: nil, description: "")
    
    var daysOfWeek: [DayOfWeek] = [DayOfWeek(name: "Dom"), DayOfWeek(name: "Seg"), DayOfWeek(name: "Ter"), DayOfWeek(name: "Qua"), DayOfWeek(name: "Qui"), DayOfWeek(name: "Sex"), DayOfWeek(name: "Sáb")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        habitNameTextField.delegate = self
        descriptionTextView.delegate = self
        daysOfWeekCollectionView.delegate = self
        daysOfWeekCollectionView.dataSource = self
        
        daysOfWeekCollectionView.layer.cornerRadius = 10
        
        habitNameTextField.layer.cornerRadius = 10
        habitNameTextField.attributedPlaceholder = NSAttributedString(string: "Nome do hábito", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        addImageButton.layer.cornerRadius = 10
        createButton.layer.cornerRadius = 10
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.text = "Digite aqui a descrição e as regras"
        descriptionTextView.textColor = UIColor.systemGray
        descriptionTextView.leftSpace()
        descriptionTextView.addDoneButton(title: "Pronto", target: self, selector: #selector(tapDone(sender:)))
        
        let layout = UICollectionViewFlowLayout()
        let cellWidth = 45
        print(cellWidth)
        layout.itemSize = CGSize(width: cellWidth, height: 45)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.sectionInsetReference = .fromContentInset
        daysOfWeekCollectionView.collectionViewLayout = layout
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }

    @IBAction func addImage(_ sender: Any) {
        let croppingParameters = CroppingParameters(isEnabled: true, allowResizing: false, allowMoving: true, minimumSize: CGSize(width: 300, height: 150))

        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true) { [weak self] image, asset in

            // Do something with your image here
            if image != nil {
                let croppedImage = CropImage.shared.crop(image: image!, aspectRatio: 1.5)
                self?.addImageButton.setBackgroundImage(croppedImage, for: .normal)
                self!.addImageButton.setImage(nil, for: .normal)
                self!.addImageButton.layer.cornerRadius = 10
                self!.newHabit.image = image
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

extension CreateNewHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateNewHabitViewController: UITextViewDelegate {
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
}

extension CreateNewHabitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.allowsMultipleSelection = true
    
        daysOfWeek[indexPath.row].isSelected = true
        
        print(daysOfWeek[indexPath.row].isSelected)

        print("You tapped me")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        daysOfWeek[indexPath.row].isSelected = false
        print(daysOfWeek[indexPath.row].isSelected)
    }
}

extension CreateNewHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = daysOfWeekCollectionView.dequeueReusableCell(withReuseIdentifier: "DaysOfWeekCell", for: indexPath) as! DaysOfWeekCollectionViewCell
        
        cell.dayLabel.text = daysOfWeek[indexPath.row].name
        
        return cell
    }
}

extension CreateNewHabitViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 45, height: 45)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
}
