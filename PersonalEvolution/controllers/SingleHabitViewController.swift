//
//  SingleHabitViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 30/08/21.
//

import UIKit

class SingleHabitViewController: UIViewController {

    var habit: String!

    @IBOutlet var habitTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        habitTitleLabel.text = habit
    }
    
    @IBAction func backToHabits(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
