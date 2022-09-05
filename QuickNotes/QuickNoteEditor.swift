//
//  QuickNotesEditor.swift
//  QuickNotes
//
//  Created by Terry Drozdowski on 9/3/22.
//

import SwiftUI
import Combine

struct QuickNoteEditor: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @ObservedObject var note: QuickNote
    
    var body: some View {
        TextEditor(text: $note.text)
            .onReceive(note.publisher(for: \.text), perform: setName)
            .onReceive(
                note.publisher(for: \.text)
                    .debounce(for: 0.5, scheduler: RunLoop.main)
                    .removeDuplicates()
            ) { _ in
                try? PersistenceController.shared.saveContext()
            }
            .navigationTitle(note.name)
    }
    
    func setName(from text: String) {
        let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.count > 0 {
            note.name = String(text.prefix(25))
        } else {
            note.name = "New Quick Note"
        }
    }
    
}
