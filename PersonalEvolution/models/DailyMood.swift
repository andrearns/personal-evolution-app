//
//  DailyMood.swift
//  PersonalEvolution
//
//  Created by Bruno Imai on 17/09/21.
//

import Foundation
import CloudKit

struct DailyMood {
    var id = UUID()
    var mood: Int?
    var commentary: String?
    var date: Date?
    var userRef: CKRecord.Reference?
    var recordID: CKRecord.ID?
}
