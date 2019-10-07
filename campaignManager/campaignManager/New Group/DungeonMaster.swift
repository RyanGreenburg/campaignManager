//
//  DungeonMaster.swift
//  characterApp
//
//  Created by RYAN GREENBURG on 8/28/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit

class DungeonMaster: CloudKitSyncable {
    // DM Class properties
    var name: String
    var privateNotes: [Note]
    var publicNotes: [Note]
    // CloudKit Properties
    /// The Character CKRecord.ID, created from a UUID string
    var recordID: CKRecord.ID
    /// CKRecord.Reference that points to the User that created the Character
    var userReference: CKRecord.Reference
    /// CKRecord computed property to create a CKRecord from all up-to-date DungeonMaster properties
    var ckRecord: CKRecord {
        let record = CKRecord(recordType: DungeonMaster.recordType, recordID: self.recordID)
        record.setValuesForKeys([
            DMStrings.nameKey : self.name,
            DMStrings.userRefKey : self.userReference
            ])
        return record
    }
    /// Computed property of the DM's CKRecord.RecordType, returns the DMStrings.typeKey
    static var recordType: CKRecord.RecordType {
        return DMStrings.typeKey
    }
    
    init(name: String, privateNotes: [Note] = [], publicNotes: [Note] = [], userReference: CKRecord.Reference, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.privateNotes = privateNotes
        self.publicNotes = publicNotes
        self.userReference = userReference
        self.recordID = recordID
    }
    
    required init?(record: CKRecord) {
        guard let name = record[DMStrings.nameKey] as? String,
            let userReference = record[DMStrings.userRefKey] as? CKRecord.Reference
            else { return nil }
        
        self.name = name
        self.privateNotes = []
        self.publicNotes = []
        self.userReference = userReference
        self.recordID = record.recordID
    }
}

struct DMStrings {
    static let typeKey = "DungeonMaster"
    static let nameKey = "name"
    static let userRefKey = "userReference"
}
