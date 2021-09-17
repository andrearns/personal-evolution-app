//
//  PopUpDailyMoodViewController.swift
//  PersonalEvolution
//
//  Created by Bruno Imai on 16/09/21.
//

import UIKit

class PopUpDailyMoodViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var touchOutButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentDailyMood: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.layer.cornerRadius = 15
        container.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendComment(_ sender: Any) {
        print("Comentário enviado")
        self.dismiss(animated: true)
    }
    
    @IBAction func toutchOutside(_ sender: Any) {
        print("PopUp fechado")
        self.dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
