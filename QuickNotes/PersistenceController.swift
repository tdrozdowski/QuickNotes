//
//  PersistenceController.swift
//  QuickNotes
//
//  Created by Terry Drozdowski on 9/3/22.
//

import Foundation
import CoreData

final class PersistenceController {
    static let shared = PersistenceController()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "QuickNotes")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    private init() {}
    
    public func saveContext(backgroundContext: NSManagedObjectContext? = nil) throws {
        let context = backgroundContext ?? container.viewContext
        guard context.hasChanges else {return }
        try context.save()
    }
}
