//
//  File.swift
//  characterApp
//
//  Created by RYAN GREENBURG on 8/24/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit
import CloudKit

// MARK: - CharacterStrings
struct CharacterStrings {
    
}

class Character {
    
    let player: User
    var name: String
    var level: Int
    var stats: Stats
    var notes: [Note]
    
    var profBonus: Int {
        return level
    }
    
    init(player: User, name: String, level: Int = 1, stats: Stats, notes: [Note] = []) {
        self.player = player
        self.name = name
        self.level = level
        self.stats = stats
        self.notes = notes
    }
}

