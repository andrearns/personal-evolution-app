//
//  Day.swift
//  PersonalEvolution
//
//  Created by Bruno Imai on 08/09/21.
//

import Foundation
class Day {
    var number = ""
    
    init(number: String) {
        self.number = number
    }
    
    static func FetchDay() -> [Day]{
        
        var dayArray = [Day]()
        for day in 1...30 {
            dayArray.append(Day(number: String(day)))
        }
        
        return dayArray
    }
}
