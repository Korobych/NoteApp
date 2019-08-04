//
//  RemoveNoteDBOperation.swift
//  NoteApp
//
//  Created by Sergey Korobin on 04/08/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import Foundation

class RemoveNoteDBOperation: BaseDBOperation {
    
    private(set) var result: Int?
    private let noteId: String
    
    init(noteId: String,
         notebook: FileNotebook) {
        self.noteId = noteId
        super.init(notebook: notebook)
    }
    
    override func main() {
        result = notebook.remove(with: noteId)
        notebook.saveToFile()
        finish()
    }
}
