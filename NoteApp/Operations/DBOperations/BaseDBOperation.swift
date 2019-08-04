//
//  BaseDBOperation.swift
//  NoteApp
//
//  Created by Sergey Korobin on 04/08/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import Foundation

class BaseDBOperation: AsyncOperation {
    
    let notebook: FileNotebook
    
    init(notebook: FileNotebook) {
        self.notebook = notebook
        super.init()
    }
}
