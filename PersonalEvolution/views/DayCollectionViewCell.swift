//
//  DayCollectionViewCell.swift
//  PersonalEvolution
//
//  Created by Bruno Imai on 08/09/21.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayNumber: UILabel!
    
    var day : Day! {
            didSet {
                self.update ()
            }
        }
    
    func update(){
        if let day = day {
                   
            dayNumber.text = day.number
            
        } else {
            dayNumber.text = nil
        
        }
    }
}
