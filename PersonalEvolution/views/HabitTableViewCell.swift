//
//  HabitTableViewCell.swift
//  PersonalEvolution
//
//  Created by André Arns on 30/08/21.
//

import UIKit

class HabitTableViewCell: UITableViewCell {

    var habit: Habit!
    
    @IBOutlet var habitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(habit: Habit) {
        self.habit = habit
        
        self.habitLabel.text = habit.name
    }

}
