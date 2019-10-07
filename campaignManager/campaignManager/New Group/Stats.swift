//
//  Stats.swift
//  characterApp
//
//  Created by RYAN GREENBURG on 10/6/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation

class Stats {
    var strength: Int
    var strMod: Int {
        return strength
    }
    var dexterity: Int
    var dexMod: Int {
        return dexterity
    }
    var constitution: Int
    var conMod: Int {
        return constitution
    }
    var wisdom: Int
    var wisMod: Int {
        return wisdom
    }
    var passivePerception: Int {
        return wisMod + 10
    }
    var intelligence: Int
    var intMod: Int {
        return intelligence
    }
    var charisma: Int
    var chaMod: Int {
        return charisma
    }
    
    init(str: Int, dex: Int, con: Int, wis: Int, int: Int, cha: Int) {
        self.strength = str
        self.dexterity = dex
        self.constitution = con
        self.wisdom = wis
        self.intelligence = int
        self.charisma = cha
    }
}
