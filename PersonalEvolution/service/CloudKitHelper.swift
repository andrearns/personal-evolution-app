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
        static let User = "User"
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
        operation.desiredKeys = ["Name", "Description", "Image", "Frequency"]
        
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
                
                guard let frequency = record["Frequency"] as? [Int] else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    print("Erro para puxar a frequência")
                    return
                }
                
                let habit = Habit(recordID: id, name: name, image: image, description: description, frequency: frequency)
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
                record["Frequency"] = habit.frequency as CKRecordValue
                
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
                        guard let frequency = record["Frequency"] as? [Int] else { return }
                        
                        let habit = Habit(recordID: id, name: name, image: image, description: description, frequency: frequency)
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
                completion(.success(recordId))
            }
        }
    }
    
    // MARK: - Checkin
    
    // Read
    static func fetchCheckins(completion: @escaping (Result<Checkin, Error>) -> ()) {
        let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: RecordType.Checkin, predicate: predicate)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["Description", "Image", "HabitRef"]
        
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                let id = record.recordID
                
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
                
                guard let habitRef = record["HabitRef"] as? CKRecord.Reference else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    print("Erro para puxar a a referência do hábito")
                    return
                }
                
                let checkin = Checkin(image: image, description: description, user: nil, date: record.creationDate!, recordID: id, habitRef: habitRef)
                completion(.success(checkin))
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
    
    // Create
    static func save(checkin: Checkin, habit: Habit) {
        
        let checkinRecord = CKRecord(recordType: RecordType.Checkin)
        let habitRecord = CKRecord(recordType: RecordType.Habit)
        
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
        checkinRecord["HabitRef"] = CKRecord.Reference(recordID: habit.recordID!, action: .deleteSelf)
        
        var checkinRefs = habit.checkinRefs
        checkinRefs?.append(CKRecord.Reference(record: checkinRecord, action: .deleteSelf))
        habitRecord["CheckinRefs"] = checkinRefs
        
        
        publicDatabase.save(checkinRecord) { record, error in
            do { try FileManager().removeItem(at: url!) }
            catch let error { print("Error deleting temp file: \(error)")}
        }
        
    }
    
    // Update
    static func modify(checkin: Checkin, completion: @escaping (Result<Checkin, Error>) -> ()) {
        
    }
    
    // MARK: - User
    
    // Read
    static func fetchUsers(completion: @escaping (Result<User, Error>) -> ()) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecordType.Checkin, predicate: predicate)
    
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["Name", "Image"]
        
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                let id = record.recordID
                
                guard let name = record["Name"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                
                guard let file = record["Image"] as? CKAsset else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                
                let data = NSData(contentsOf: (file.fileURL)!)
                let image = UIImage(data: data! as Data)
                
                let user = User(name: name, image: image, recordID: id)
                completion(.success(user))
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
    
    // Create
    static func save(user: User) {
        let userRecord = CKRecord(recordType: RecordType.User)
        
        let data = user.image?.pngData()
        let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
        do {
            try data?.write(to: url!, options: [])
        } catch let error as NSError {
            print("Error! \(error)")
            return
        }
        userRecord["Image"] = CKAsset(fileURL: url!)
        userRecord["Name"] = user.name as String
        
        publicDatabase.save(userRecord) { record, error in
            do { try FileManager().removeItem(at: url!) }
            catch let error { print("Error deleting temp file: \(error)")}
        }
    }
    
    // Validate username -> Does username already exist?
//    static func doesNameAlreadyExist(username: String, equalTo: String, _ completion: @escaping (Bool) -> ()) {
//        var result = false
//
//        let predicate = NSPredicate(format: "username == %@", equalTo)
//        let query = CKQuery(recordType: "Name", predicate: predicate)
//        publicDatabase.perform(query, inZoneWith: nil) { results, error in
//
//            if results != nil {
//                print(results?.count)
//                if results?.count == 1 {
//                    print(results?.count)
//                    result = true
//                }
//            }
//        }
//        completion(result)
//    }
    
    // Update
    static func modify(user: User, completion: @escaping (Result<User, Error>) -> ()) {
        
    }
    
}
