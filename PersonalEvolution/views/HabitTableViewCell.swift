//
//  HabitTableViewCell.swift
//  PersonalEvolution
//
//  Created by André Arns on 30/08/21.
//

import UIKit

class HabitTableViewCell: UITableViewCell {

    var habit: String!
    
    @IBOutlet var habitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(habit: String) {
        self.habit = habit
        
        self.habitLabel.text = habit
    }

}
