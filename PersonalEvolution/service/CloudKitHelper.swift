//
//  CloudKitHelper.swift
//  PersonalEvolution
//
//  Created by André Arns on 02/09/21.
//
import CloudKit
import UIKit
import Foundation

// Database
private let publicDatabase = CKContainer(identifier: "iCloud.PersonalEvolution").publicCloudDatabase

struct CloudKitHelper {
    
    // Record types
    struct RecordType {
        static let Habit = "Habit"
        static let Checkin = "Checkin"
    }
    
    // Errors
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIDFailure
        case castFailure
        case cursorFailure
    }
    
    // MARK: - Habit
    
    // Create
    static func save(habit: Habit) {
        
        let habitRecord = CKRecord(recordType: RecordType.Habit)
        
        let imageData = habit.image?.pngData()
        let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
        do {
            try imageData?.write(to: url!, options: [])
        } catch let error as NSError {
            print("Error! \(error)")
            return
        }
        habitRecord["Image"] = CKAsset(fileURL: url!)
        habitRecord.setValue(habit.name, forKey: "Name")
        habitRecord.setValue(habit.description, forKey: "Description")
        habitRecord.setValue([], forKey: "CheckinList")
        habitRecord.setValue(habit.frequency, forKey: "Frequency")
        
        publicDatabase.save(habitRecord) { record, error in
            do { try FileManager().removeItem(at: url!) }
            catch let error { print("Error deleting temp file: \(error)")}
        }
    }
    
    // Read
    static func fetchHabits(completion: @escaping (Result<Habit, Error>) -> ()) {
        let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: RecordType.Habit, predicate: predicate)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["Name", "Description", "Image"]
        
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                let id = record.recordID
                
                guard let name = record["Name"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                
                guard let description = record["Description"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                
                guard let file = record["Image"] as? CKAsset else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                
                let data = NSData(contentsOf: (file.fileURL)!)
                let image = UIImage(data: data! as Data)
                
//                guard let frequency = record["Frequency"] as? [Int64] else {
//                    completion(.failure(CloudKitHelperError.castFailure))
//                    print("Erro para puxar a frequência")
//                    return
//                }
                
                let habit = Habit(recordID: id, name: name, image: image, description: description, checkinList: [])
                completion(.success(habit))
            }
        }
        
        operation.queryCompletionBlock = { (_, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
            }
        }
        publicDatabase.add(operation)
    }
    
    // Update
    static func modify(habit: Habit, completion: @escaping (Result<Habit, Error>) -> ()) {
        
        guard let recordID = habit.recordID else { return }
        
        publicDatabase.fetch(withRecordID: recordID) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let record = record else { return }
            
                let imageData = habit.image?.pngData()
                let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
                do {
                    try imageData?.write(to: url!, options: [])
                } catch let error as NSError {
                    print("Error! \(error)")
                    return
                }
                record["Image"] = CKAsset(fileURL: url!)
                record["Name"] = habit.name as CKRecordValue
                record["Description"] = habit.description as CKRecordValue
                
                publicDatabase.save(record) { (record, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        guard let record = record else { return }
                        
                        let id = recordID
                        guard let name = record["Name"] as? String else { return }
                        guard let description = record["Description"] as? String else { return }
                        guard let file = record["Image"] as? CKAsset else { return }
                        let data = NSData(contentsOf: (file.fileURL)!)
                        let image = UIImage(data: data! as Data)
                        
                        let habit = Habit(recordID: id, name: name, image: image, description: description, checkinList: [])
                        completion(.success(habit))
                    }
                }
            }
        }
    }
    
    // Delete
    static func delete(recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        publicDatabase.delete(withRecordID: recordID) { recordId, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let recordId = recordId else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                completion(.success(recordID))
            }
        }
    }
    
    // MARK: - Checkin
    
    // Create
    static func save(checkin: Checkin, habit: Habit) {
        
        let checkinRecord = CKRecord(recordType: RecordType.Checkin)
        
        let data = checkin.image?.pngData()
        let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
        do {
            try data?.write(to: url!, options: [])
        } catch let error as NSError {
            print("Error! \(error)")
            return
        }
        checkinRecord["Image"] = CKAsset(fileURL: url!)
        checkinRecord["Description"] = checkin.description as String
        checkinRecord["Habit"] = CKRecord.Reference(recordID: habit.recordID!, action: .deleteSelf)
        
        publicDatabase.save(checkinRecord) { record, error in
            do { try FileManager().removeItem(at: url!) }
            catch let error { print("Error deleting temp file: \(error)")}
        }
    }
    
    // Read
    static func fetchCheckinList(completion: @escaping (Result<Checkin, Error>) -> ()) {
        
    }
    
    // Update
    static func modify(checkin: Checkin, completion: @escaping (Result<Checkin, Error>) -> ()) {
        
    }
    
    
}
