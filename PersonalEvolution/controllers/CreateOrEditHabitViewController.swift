import UIKit
import ALCameraViewController

class CreateOrEditHabitViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var habitNameTextField: CustomTextField!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var descriptionPlaceholderLabel: UILabel!
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var daysOfWeekCollectionView: UICollectionView!
    
    var onSave: (() -> Void)?
    var currentMode: CreateOrEditMode {
        if self.habit != nil {
            return .edit
        } else {
            return .create
        }
    }
    var habit: Habit?
    
    var newHabit = Habit(name: "", image: nil, description: "")
    
    var daysOfWeek: [DayOfWeek] = [DayOfWeek(name: "Dom"), DayOfWeek(name: "Seg"), DayOfWeek(name: "Ter"), DayOfWeek(name: "Qua"), DayOfWeek(name: "Qui"), DayOfWeek(name: "Sex"), DayOfWeek(name: "Sáb")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegates and datasources
        habitNameTextField.delegate = self
        descriptionTextView.delegate = self
        daysOfWeekCollectionView.delegate = self
        daysOfWeekCollectionView.dataSource = self
        
        // UI
        daysOfWeekCollectionView.layer.cornerRadius = 15
        habitNameTextField.layer.cornerRadius = 15
        habitNameTextField.attributedPlaceholder = NSAttributedString(string: "Nome do hábito", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        addImageButton.layer.cornerRadius = 15
        createButton.layer.cornerRadius = 15
        descriptionTextView.layer.cornerRadius = 15
        descriptionTextView.leftSpace()
        descriptionTextView.addDoneButton(title: "Pronto", target: self, selector: #selector(tapDone(sender:)))
        let layout = UICollectionViewFlowLayout()
        let cellWidth = 45
        layout.itemSize = CGSize(width: cellWidth, height: 45)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.sectionInsetReference = .fromContentInset
        daysOfWeekCollectionView.collectionViewLayout = layout
        
        // Fill fields if edit mode is on
        if currentMode == .create {
            titleLabel.text = "Criar novo hábito"
            descriptionTextView.text = "Digite aqui a descrição e as regras"
            descriptionTextView.textColor = UIColor.systemGray
            createButton.setTitle("Criar hábito", for: .normal)
        } else if currentMode == .edit {
            titleLabel.text = "Editar hábito"
            habitNameTextField.text = habit?.name
            descriptionTextView.text = habit?.description
            descriptionTextView.textColor = UIColor.black
            let buttonImage = CropImage.shared.crop(image: (habit?.image)!, aspectRatio: 1.5)
            addImageButton.setBackgroundImage(buttonImage, for: .normal)
            createButton.setTitle("Salvar", for: .normal)
            self.newHabit = self.habit!
        }
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
                self!.addImageButton.layer.cornerRadius = 15
                self!.newHabit.image = image
            }
            
            self?.dismiss(animated: true, completion: nil)
        }
        cameraViewController.modalPresentationStyle = .fullScreen
        present(cameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func saveHabit(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        newHabit.name = habitNameTextField.text!
        newHabit.description = descriptionTextView.text
        
        if currentMode == .create {
            CloudKitHelper.save(habit: newHabit)
            let vc = storyboard.instantiateViewController(identifier: "singleHabit") as! SingleHabitViewController
            vc.habit = newHabit
            present(vc, animated: true)
        } else if currentMode == .edit {
            let updatedHabit = Habit(id: newHabit.id, recordID: newHabit.recordID, name: newHabit.name, image: newHabit.image, description: newHabit.description, frequency: newHabit.frequency)
            
            CloudKitHelper.modify(habit: updatedHabit) { (result) in
                switch result {
                case .success(_):
                    print("Successfuly edited habit")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
 
extension CreateOrEditHabitViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
}

extension CreateOrEditHabitViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        daysOfWeek[indexPath.row].isSelected = true
        newHabit.frequency[indexPath.row] = 1
        print(newHabit.frequency)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        daysOfWeek[indexPath.row].isSelected = false
        newHabit.frequency[indexPath.row] = 0
        print(newHabit.frequency)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.allowsMultipleSelection = true
        collectionView.allowsSelection = true
        let cell = daysOfWeekCollectionView.dequeueReusableCell(withReuseIdentifier: "DaysOfWeekCell", for: indexPath) as! DaysOfWeekCollectionViewCell
        cell.dayLabel.text = daysOfWeek[indexPath.row].name
        
        if currentMode == .edit {
            if habit?.frequency[indexPath.row] == 1 {
                cell.dayBackgroundView.backgroundColor = UIColor(named: "Lilas")
                cell.dayLabel.textColor = .white
            }
        }
        
        return cell
    }
    
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

enum CreateOrEditMode {
    case create
    case edit
}
