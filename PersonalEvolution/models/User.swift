//
//  User.swift
//  PersonalEvolution
//
//  Created by André Arns on 06/09/21.
//
import CloudKit
import Foundation
import UIKit

struct User: Identifiable {
    var id = UUID()
    var name: String
    var imageData: Data?
    var recordID: CKRecord.ID?
}
