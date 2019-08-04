//
//  SaveNoteDBOperation.swift
//  NoteApp
//
//  Created by Sergey Korobin on 04/08/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import Foundation

class SaveNoteDBOperation: BaseDBOperation {
    
    private let note: Note
    
    init(note: Note,
         notebook: FileNotebook) {
        self.note = note
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.add(noteToAdd: note)
        notebook.saveToFile()
        finish()
    }
}
