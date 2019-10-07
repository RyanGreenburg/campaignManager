//
//  UserController.swift
//  characterApp
//
//  Created by RYAN GREENBURG on 10/7/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation

class UserController {
    
    static let shared = UserController()
    var currentUser: User?
    
    // MARK: - CRUD
    
    func create(name: String) {
        let newUser = User(name: name)
        currentUser = newUser
    }
    
    func fetch() {
        
    }
    
    func update(user: User) {
        
    }
    
    func delete(user: User) {
        
    }
}
