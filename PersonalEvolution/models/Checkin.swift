//
//  Checkin.swift
//  PersonalEvolution
//
//  Created by André Arns on 06/09/21.
//

import Foundation
import UIKit
import CloudKit

struct Checkin: Identifiable {
    var id = UUID()
    var image: UIImage?
    var description: String
    var date: Date
    var recordID: CKRecord.ID?
    var habitRef: CKRecord.Reference?
    var userRef: CKRecord.Reference?
}
