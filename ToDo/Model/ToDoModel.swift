//
//  ToDoModel.swift
//  ToDo
//
//  Created by Sagar Ajudiya on 20/06/24.
//

import Foundation

struct ToDoModel: Codable {
    var id = UUID()
    var task: String?
    var isDone: Bool = false
}
