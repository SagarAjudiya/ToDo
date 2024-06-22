//
//  SessionManager.swift
//  ToDo
//
//  Created by Sagar Ajudiya on 21/06/24.
//

import Foundation

class SessionManager {
    
    private init() { }
    
    static let shared = SessionManager()
    
    @UserDefault("userTodo", defaultValue: nil)
    var userTodo: [ToDoModel]?
    
}
