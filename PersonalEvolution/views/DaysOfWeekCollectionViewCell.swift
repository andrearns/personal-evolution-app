//
//  DaysOfWeekCollectionViewCell.swift
//  PersonalEvolution
//
//  Created by André Arns on 12/09/21.
//

import UIKit

class DaysOfWeekCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var dayBackgroundView: UIView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.4) {
                    self.dayBackgroundView.layer.backgroundColor = UIColor(named: "Lilas")?.cgColor
                    self.dayLabel.textColor = UIColor.white
                }
            } else {
                UIView.animate(withDuration: 0.4) {
                    self.dayBackgroundView.layer.backgroundColor = UIColor(named: "TextFieldBackgroundColor")?.cgColor
                    self.dayLabel.textColor = UIColor.systemGray2
                }
                
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.dayBackgroundView.layer.cornerRadius = 22
    }
    
}
