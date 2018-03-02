//
//  CoreDataManager.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/19/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    var authToken = ""
    private init() {}
    
    let persistentContainer : NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "AcademusModels")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Loading of store failed: \(error)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do {
                try context.save()
            } catch let error {
                print("unresolved error in CoreDataManager saveContext(). Error: \(error)")
            }
        }
    }
    
    func fetchAuthServicesData() {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<AuthServices>(entityName: "AuthServices")
        do {
            let authServices = try managedContext.fetch(fetchRequest)
            for object in authServices {
                managedContext.delete(object)
                self.saveContext()
            }
            print(authServices.count)
        } catch let error {
            print(error)
    }
}
}
