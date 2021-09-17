//
//  Habit.swift
//  PersonalEvolution
//
//  Created by André Arns on 02/09/21.
//
import CloudKit
import UIKit

struct Habit: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var name: String
    var image: UIImage?
    var description: String
    var checkinRefs: [CKRecord.Reference]?
    var frequency: [Int] = [0, 0, 0, 0, 0, 0, 0]
//    var streak: Int
//    var checkinList: [Checkin]
//    var users: [User]
}
