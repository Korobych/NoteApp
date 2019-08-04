//
//  RemoveNoteOperation.swift
//  NoteApp
//
//  Created by Sergey Korobin on 04/08/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import Foundation

class RemoveNoteOperation: AsyncOperation {
    
    private let noteId: String
    private let removeFromDbOperation: RemoveNoteDBOperation
    private var saveToBackendOperation: SaveNotesBackendOperation
    private(set) var result: Int? = -1
    
    init(noteId: String, notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue) {
        
        self.noteId = noteId
        removeFromDbOperation = RemoveNoteDBOperation(noteId: noteId, notebook: notebook)
        saveToBackendOperation = SaveNotesBackendOperation(notes: notebook.notesArray)
        super.init()
        
        removeFromDbOperation.completionBlock = {
            backendQueue.addOperation(self.saveToBackendOperation)
        }
        
        addDependency(removeFromDbOperation)
        addDependency(saveToBackendOperation)
        dbQueue.addOperation(removeFromDbOperation)
    }
    
    override func main() {
        if let index = removeFromDbOperation.result {
            if index >= 0 {
                result = index
                print("Note sucessfully deleted with UID \(noteId) with index \(index)!\n")
            }
        }
        finish()
    }
}
