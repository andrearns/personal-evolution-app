//
//  Month.swift
//  PersonalEvolution
//
//  Created by Bruno Imai on 02/09/21.
//

import UIKit

class Month {
    var name = ""
    
    init(name: String) {
        self.name = name
    }
    
    static func FetchMonth() -> [Month]{
        return [ Month(name: "Janeiro"), Month(name: "Fevereiro"),Month(name: "Março"),Month(name: "Abril"),Month(name: "Maio"),Month(name: "Junho"),Month(name: "Julho"),Month(name: "Agosto"),Month(name: "Setembro"),Month(name: "Outubro"),Month(name: "Novembro"),Month(name: "Dezembro")]
    }
}

