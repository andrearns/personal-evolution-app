//
//  PopUpDailyMoodViewController.swift
//  PersonalEvolution
//
//  Created by Bruno Imai on 16/09/21.
//

import UIKit

class PopUpDailyMoodViewController: UIViewController {

    var mood: Int!
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var touchOutButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentDailyMood: UITextView!
    
    var dailyMood = DailyMood(mood: 0, commentary: "", date: nil, userRef: nil, recordID: nil)
    
    var currentUser = User(name: "", imageData: nil, recordID: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.layer.cornerRadius = 15
        container.layer.cornerRadius = 15
        commentDailyMood.delegate = self
        commentDailyMood.leftSpace()
        commentDailyMood.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        // Do any additional setup after loading the view.
        print(mood)
        
        self.currentUser.name = UserSingleton.shared.name!
        self.currentUser.imageData = UserSingleton.shared.imageData!
        self.currentUser.recordID = UserSingleton.shared.recordID ?? UserSingleton.shared.fetchUserRecordID()
        
        commentDailyMood.text = "Add a memory" 
        commentDailyMood.textColor = UIColor.systemGray
        
        print(self.currentUser)
    }
    
    @IBAction func sendComment(_ sender: Any) {
        print("Comentário enviado")
        dailyMood.commentary = commentDailyMood.text
        dailyMood.mood = mood
        
//        var date = Date()
        
        CloudKitHelper.save(dailyMood: dailyMood, userRecordID: currentUser.recordID!)
        
        self.dismiss(animated: true)
    }
    
    @IBAction func toutchOutside(_ sender: Any) {
        print("PopUp fechado")
        self.dismiss(animated: true)
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }

}

extension PopUpDailyMoodViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add a memory"
            textView.textColor = UIColor.systemGray
        }
    }
}
