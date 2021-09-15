//
//  Checkin.swift
//  PersonalEvolution
//
//  Created by André Arns on 06/09/21.
//

import Foundation
import UIKit

struct Checkin: Identifiable {
    var id = UUID()
    var image: UIImage?
    var description: String
    var user: User?
    var date: Date
}
