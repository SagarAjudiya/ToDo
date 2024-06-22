//
//  CoreData.swift
//  ToDo
//
//  Created by Sagar Ajudiya on 20/06/24.
//

import UIKit
import CoreData

class CoreDataWrapper {

    static let shared = CoreDataWrapper()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoModel")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    private init() {}

    // Create a generic entity to store response data
    func createTableForResponseModel<T: Codable>(_ responseModel: T.Type, jsonData: Data) {
        let context = persistentContainer.viewContext

        guard let entityDescription = NSEntityDescription.entity(forEntityName: "GenericResponseEntity", in: context) else {
            print("Entity description not found")
            return
        }

        let newRecord = NSManagedObject(entity: entityDescription, insertInto: context)
        newRecord.setValue(jsonData, forKey: "jsonData")

        do {
            try context.save()
            print("Table created successfully for response model.")
        } catch let error as NSError {
            print("Could not save record. \(error), \(error.userInfo)")
        }
    }

    // Fetch data from Core Data
    func fetchResponseModels<T: Codable>(_ responseModel: T.Type) -> [T]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GenericResponseEntity")
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            var models = [T]()
            
            for result in results ?? [] {
                if let jsonData = result.value(forKey: "jsonData") as? Data {
                    let decoder = JSONDecoder()
                    do {
                        let model = try decoder.decode(T.self, from: jsonData)
                        models.append(model)
                    } catch let error as NSError {
                        print("Failed to decode JSON data. \(error), \(error.userInfo)")
                    }
                }
            }
            
            return models
        } catch let error as NSError {
            print("Could not fetch records. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    // Delete a record with a matching ID
    func deleteResponseModel<T: Codable>(withID id: UUID, responseModel: T.Type) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GenericResponseEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            for result in results ?? [] {
                context.delete(result)
            }

            try context.save()
            print("Record deleted successfully.")
        } catch let error as NSError {
            print("Could not delete record. \(error), \(error.userInfo)")
        }
    }
    
    // Edit a record with a matching ID
    func editResponseModel<T: Codable>(withID id: UUID, newResponseModel: T, jsonData: Data) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GenericResponseEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let result = results?.first {
                result.setValue(jsonData, forKey: "jsonData")

                try context.save()
                print("Record updated successfully.")
            } else {
                print("No record found with the specified ID.")
            }
        } catch let error as NSError {
            print("Could not update record. \(error), \(error.userInfo)")
        }
    }

}
