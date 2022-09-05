//
//  QuickNotesApp.swift
//  QuickNotes
//
//  Created by Terry Drozdowski on 9/2/22.
//

import SwiftUI

@main
struct QuickNotesApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .commands {
            CommandGroup(replacing: .newItem, addition: { })
        }
        
        WindowGroup("Editor", for: QuickNote.ID.self) { $noteID in
            if let noteID = noteID,
               let note = try? persistenceController.container.viewContext.fetch(QuickNote.fetchRequest(forID: noteID)).first {
                QuickNoteEditor(note: note)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                Text("No Quick Note found.")
                    .foregroundColor(.secondary)
            }
        }
    }
}
