//
//  QuickNote+CoreDataClass.swift
//  QuickNotes
//
//  Created by Terry Drozdowski on 9/3/22.
//

import Foundation
import CoreData

@objc(QuickNote)
public class QuickNote: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuickNote> {
        return NSFetchRequest<QuickNote>(entityName: "QuickNote")
    }
    
    @nonobjc class func fetchRequest(forID id: UUID) -> NSFetchRequest<QuickNote> {
        let request = QuickNote.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        return request
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var text: String
}
