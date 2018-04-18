//
//  CoreDataStack.swift
//  MacroLife
//
//  Created by Tyler Clonts on 4/16/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import Foundation

import CoreData

enum CoreDataStack {
    
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MacroLife")
        container.loadPersistentStores() { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    static var context : NSManagedObjectContext { return container.viewContext }
    
}
