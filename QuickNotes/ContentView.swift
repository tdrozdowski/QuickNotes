//
//  ContentView.swift
//  QuickNotes
//
//  Created by Terry Drozdowski on 9/2/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)])
    var notes: FetchedResults<QuickNote>
    
    @State private var selectedNoteIds: Set<QuickNote.ID> = []
    
    private var selectedNote: QuickNote? {
        guard let selectedNoteId = selectedNoteIds.first,
              let selectedNote = notes.filter({ $0.id == selectedNoteId}).first else {
            return nil
        }
        return selectedNote
    }
    
    var body: some View {
        NavigationSplitView {
            List(notes, selection: $selectedNoteIds) { note in
                NavigationLink(note.name, value: note)
                    .contextMenu {
                        Button {
                            openWindow(value: note.id)
                        } label: {
                            Label("Open QuickNote in a new window",
                                systemImage: "macwindow.on.rectangle")
                        }
                        Divider()
                        Button(action: createQuickNote) {
                            Label("Create QuickNote", systemImage: "square.and.pencil")
                        }
                        Button() {
                            Task { await duplicateQuickNote(usingNote: note)}
                        } label: {
                            Label("Duplicate QuickNote", systemImage: "doc.on.doc")
                        }
                        Divider()
                        Button {
                            Task {await deleteQuickNotes(notes: [note])}
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        } detail: {
            if let note = selectedNote {
                QuickNoteEditor(note: note)
            } else {
                Text("No QuickNote selected.")
                    .foregroundColor(.secondary)
            }
        }
        .onDeleteCommand(perform: deleteSelectedQuickNotes)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: createQuickNote) {
                    Label("Create Quick Note", systemImage: "square.and.pencil")
                }
            }
        }
    }
    
    private func createQuickNote() {
        Task { await createQuickNote(name: "New Quick Note", text: "")}
    }
    
    private func createQuickNote(name: String, text: String) async {
        await viewContext.perform {
            let note = QuickNote(context: viewContext)
            note.id = UUID()
            note.name = name
            note.text = text
        }
        try? PersistenceController.shared.saveContext()
    }
    
    private func deleteSelectedQuickNotes() {
        let selectedNotes = notes.filter { selectedNoteIds.contains($0.id)}
        Task { await deleteQuickNotes(notes: selectedNotes) }
    }
    
    private func deleteQuickNotes(notes: [QuickNote]) async {
        await viewContext.perform { notes.forEach(viewContext.delete)}
        try? PersistenceController.shared.saveContext()
    }
    
    private func duplicateQuickNote(usingNote note: QuickNote) async {
        await createQuickNote(name: note.name, text: note.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
