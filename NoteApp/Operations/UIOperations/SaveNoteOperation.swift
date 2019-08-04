//
//  SaveNoteOperation.swift
//  NoteApp
//
//  Created by Sergey Korobin on 04/08/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import Foundation

class SaveNoteOperation: AsyncOperation {
    
    private let note: Note
    private let notebook: FileNotebook
    private let saveToDbOperation: SaveNoteDBOperation
    private var saveToBackendOperation: SaveNotesBackendOperation
    private(set) var result: Bool? = false
    
    init(note: Note, notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue) {
        self.note = note
        self.notebook = notebook
        
        saveToDbOperation = SaveNoteDBOperation(note: note, notebook: notebook)
        saveToBackendOperation = SaveNotesBackendOperation(notes: notebook.notesArray)
        super.init()
        
        saveToDbOperation.completionBlock = {
            backendQueue.addOperation(self.saveToBackendOperation)
        }
        
        addDependency(saveToDbOperation)
        addDependency(saveToBackendOperation)
        dbQueue.addOperation(saveToDbOperation)
    }
    
    override func main() {
        if let result = saveToBackendOperation.result {
            switch result {
            case .success: self.result = true
            case .failure: self.result = false
            }
        }
        finish()
    }
}
