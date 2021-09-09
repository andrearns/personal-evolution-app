//
//  MonthTableViewCell.swift
//  PersonalEvolution
//
//  Created by Bruno Imai on 02/09/21.
//

import UIKit

class MonthCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var monthName: UILabel!
    
    
    var month : Month! {
            didSet {
                self.update ()
            }
        }
    
    func update(){
        if let month = month {
                   
            monthName.text = month.name
            
        } else {
            monthName.text = nil
        
        }
    }
}
