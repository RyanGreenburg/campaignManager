//
//  CloudKitManager.swift
//  characterApp
//
//  Created by RYAN GREENBURG on 8/23/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit

public protocol CloudKitSyncable {
    
    var recordID: CKRecord.ID { get set }
    var ckRecord: CKRecord { get }
    static var recordType: CKRecord.RecordType { get }
    init?(record: CKRecord)
}

public enum CloudKitError: Error {
    case couldNotSave(Error)
    case objectNotFound(Error)
}

struct CloudKitManager {
    
    /// The Private Database in the Default Container
    private let privateDB = CKContainer.default().privateCloudDatabase
    
    /**
     Saves a CKRecord to the privateDatabase
     
     - Parameters:
        - T: Generic object that conforms to CloudKitSyncable
        - object: The object to save to CloudKit
        - completion: Completes with a Result
        - result:
            - .success: The object saved to CloudKit
            - .failure: The CloudKitError that was thrown
     */
    public func save<T: CloudKitSyncable>(object: T, completion: @escaping (_ result: Result<T, CloudKitError>) -> Void) {
        let record = object.ckRecord
        privateDB.save(record) { (record, error) in
            if let error = error {
                self.printError(.couldNotSave(error))
                completion(.failure(.couldNotSave(error)))
                return
            }
            print("Saved record to CloudKit")
            completion(.success(object))
        }
    }
    
    /**
     Updates a CKRecord that is saved to the privateDatabase
     
     - Parameters:
        - T: Generic object that conforms to CloudKitSyncable
        - object: The object to save to CloudKit
        - completion: Completes with a Result
        - result:
            - .success: The object updated in CloudKit
            - .failure: The CloudKitError that was thrown
     */
    public func update<T: CloudKitSyncable>(_ object: T, completion: @escaping (_ result: Result<T, CloudKitError>) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: [object.ckRecord], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (_, _, error) in
            if let error = error {
                self.printError(.couldNotSave(error))
                completion(.failure(.couldNotSave(error)))
            }
            print("Updated record in CloudKit")
            completion(.success(object))
        }
        privateDB.add(operation)
    }
    
    /**
     Fetches the users appleUserReference
     
     - Returns:
        - CKRecord.Reference: The logged in user's appleUserReference
     */
    public func fetchAppleUserReference() -> CKRecord.Reference? {
        var referenceToReturn: CKRecord.Reference?
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return
            }
            
            if let recordID = recordID {
                let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
                referenceToReturn = reference
            }
        }
        return referenceToReturn
    }
    
    /**
     Fetches an array of CKRecords that are saved to the privateDatabase
     
     - Parameters:
        - T: Generic object that conforms to CloudKitSyncable
        - predicate: The CompoundPredicate of search parameters
        - completion: Completes with a Result
        - result:
            - .success: Result yields an array of objects saved to CloudKit
            - .failure: The Error that was thrown
     */
    public func performFetch<T: CloudKitSyncable>(predicate: NSCompoundPredicate, completion: @escaping (_ result: Result<[T]?, CloudKitError>) -> Void) {
        
        let query = CKQuery(recordType: T.recordType, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                self.printError(.objectNotFound(error))
                completion(.failure(.objectNotFound(error)))
            }
            guard let records = records else { completion(.success(nil)) ; return }
            let objects: [T] = records.compactMap { T(record: $0) }
            print("Fetched objects from CloudKit")
            completion(.success(objects))
        }
    }
    
    /**
     Deletes a CKRecord hat is saved to the privateDatabase
     
     - Parameters:
        - T: Generic object that conforms to CloudKit Syncable
        - object: The object the object to delete from CloudKit
        - completion: Completes with a Result
        - result:
            - .success: Boolean indicating success in deletion
            - .failure: The Error that was thrown
     */
    public func delete<T: CloudKitSyncable>(_ object: T, completion: @escaping (_ result: Result<Bool, CloudKitError>) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [object.recordID])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { _, _, error in
            if let error = error {
                self.printError(.couldNotSave(error))
                completion(.failure(.couldNotSave(error)))
            } else {
                print("Deleted object from CloudKit successfully")
                completion(.success(true))
            }
        }
        privateDB.add(operation)
    }
    
    /**
     Formatted print statement of the CloudKit's error
     
     - Parameters:
        - error: The CloudKit error to check
     */
    fileprivate func printError(_ error: CloudKitError) {
        switch error {
        case .couldNotSave:
            print("Could not save changes to CloudKit \n---\n Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        case .objectNotFound:
            print("Could not find records in CloudKit \n---\n Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
}
