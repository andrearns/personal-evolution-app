//
//  CloudKitHelper.swift
//  PersonalEvolution
//
//  Created by André Arns on 02/09/21.
//
import CloudKit
import Foundation

// Database
private let publicDatabase = CKContainer(identifier: "iCloud.PersonalEvolution").publicCloudDatabase

struct CloudKitHelper {
    
    // Record types
    struct RecordType {
        static let Habit = "Habit"
    }
    
    
    // Errors
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIDFailure
        case castFailure
        case cursorFailure
    }
    
    // Create
    static func save(habit: Habit) {
        
        let habitRecord = CKRecord(recordType: RecordType.Habit)
        habitRecord.setValue(habit.name, forKey: "Name")
        habitRecord.setValue(habit.description, forKey: "Description")
        habitRecord.setValue(habit.isPublic, forKey: "isPublic")
        
        publicDatabase.save(habitRecord) { record, error in
            if record == record && error == nil {
                
            }
        }
    }
    
    // Read
    static func fetchHabits(completion: @escaping (Result<Habit, Error>) -> ()) {
        let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: RecordType.Habit, predicate: predicate)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["Name", "Description", "isPublic"]
        
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                let id = record.recordID
                
                guard let name = record["Name"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return }
                
                guard let description = record["Description"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return }
                
                guard let isPublic = record["isPublic"] as? Int else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return }
                
                let habit = Habit(recordID: id, name: name, description: description, isPublic: isPublic)
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
        
    }
    
    
    // Delete
    static func delete(recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        publicDatabase.delete(withRecordID: recordID) { recordID, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let recordID = recordID else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
            completion(.success(recordID))
        }
    }
    
}
