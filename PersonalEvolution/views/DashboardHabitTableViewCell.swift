//
//  DashboardHabitTableViewCell.swift
//  PersonalEvolution
//
//  Created by Bruno Imai on 03/09/21.
//

import UIKit

class DashboardHabitTableViewCell: UITableViewCell {

    var habitName: String!
    
    @IBOutlet weak var habitNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(habit: String) {
        self.habitName = habit
        
        self.habitNameLabel.text = habit
    }
}
