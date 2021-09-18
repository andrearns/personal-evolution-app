//
//  UserSingleton.swift
//  PersonalEvolution
//
//  Created by André Arns on 18/09/21.
//

import Foundation
import UIKit
import CloudKit

struct UserSingleton {
    static var shared = UserSingleton()
    
    var name: String?
    var imageData: Data?
    var recordID: CKRecord.ID?
    
    // Name
    func setName(name: String) {
        UserDefaults.standard.setValue(name, forKey: "User Name")
    }
    
    func fetchName() -> String? {
        let name = UserDefaults.standard.string(forKey: "User Name") ?? ""
        return name
    }
 
    // Image
    func setUserImageData(imageData: Data) {
        let imageData = try? JSONEncoder().encode(imageData)
        UserDefaults.standard.set(imageData, forKey: "User Image")
    }
    
    func fetchUserImageData() -> Data? {
        guard let data = UserDefaults.standard.data(forKey: "User Image") else {
            return nil
        }
        let model = try? JSONDecoder().decode(Data.self, from: data)
        return model
    }
    
    // RecordID
    func setUserRecordID(recordID: CKRecord.ID) {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: recordID, requiringSecureCoding: true)
        UserDefaults.standard.set(data, forKey: "User RecordID")
    }
    
    func fetchUserRecordID() -> CKRecord.ID? {
        let data = UserDefaults.standard.object(forKey: "User RecordID")
        let record = try? NSKeyedUnarchiver.unarchivedObject(ofClass: CKRecord.ID.self, from: data as! Data)
        return record
    }
    
}
