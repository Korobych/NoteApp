//
//  LoadNotesDBOperation.swift
//  NoteApp
//
//  Created by Sergey Korobin on 04/08/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import Foundation

class LoadNotesDBOperation: BaseDBOperation {
    
    private(set) var result: [Note]?
    
    override init(notebook: FileNotebook) {
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.loadFromFile()
        result = notebook.notesArray
        finish()
    }
}
