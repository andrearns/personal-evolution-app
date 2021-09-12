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
    @IBOutlet var cellBackgroundView: UIView!
    @IBOutlet var habitImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellBackgroundView.layer.cornerRadius = 5
        cellBackgroundView.layer.shadowColor = UIColor.black.cgColor
        cellBackgroundView.layer.shadowOpacity = 0.1
        cellBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cellBackgroundView.layer.shadowRadius = 5
        cellBackgroundView.layer.shadowPath = UIBezierPath(rect: cellBackgroundView.bounds).cgPath
        
        habitImageView.layer.cornerRadius = 31
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(habit: Habit) {
        self.habit = habit
        self.habitLabel.text = habit.name
        self.habitImageView.image = habit.image
    }

}
