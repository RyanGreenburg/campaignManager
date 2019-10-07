//
//  Campaign.swift
//  characterApp
//
//  Created by RYAN GREENBURG on 8/28/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit

class Campaign {
    
    var name: String
    var dungeonMaster: DungeonMaster?
    var characters: [Character]?
    var sessionNotes: [Note]?
    
    init(name: String, dm: DungeonMaster? = nil, characters: [Character]? = nil, sessionNotes: [Note]? = nil) {
        self.name = name
        self.dungeonMaster = dm
        self.characters = characters
        self.sessionNotes = sessionNotes
    }
}
