//
//  CoreDataManager.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/19/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import CoreData
import Locksmith

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    
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
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print("unresolved error in CoreDataManager saveContext(). Error: \(error)")
            }
        }
    }
    
    func fetchPlannerCards() -> [PlannerCards] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<PlannerCards>(entityName: "PlannerCard")
        do {
            let cards = try context.fetch(fetchRequest)
            print(cards.count)
            return cards
        } catch let error {
            print("Could not fetch PlannerCards: ", error)
            return []
        }
    }
}
