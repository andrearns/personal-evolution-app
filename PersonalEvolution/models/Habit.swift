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
    var description: String
    var isPublic: Int // 0 -> False // 1 -> True
}
