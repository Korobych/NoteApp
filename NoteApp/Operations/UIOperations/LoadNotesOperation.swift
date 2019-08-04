//
//  LoadNotesOperation.swift
//  NoteApp
//
//  Created by Sergey Korobin on 04/08/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import Foundation

class LoadNotesOperation: AsyncOperation {
    
    private var loadFromBackendOperation: LoadNotesBackendOperation
    private var loadFromDbOperaion: LoadNotesDBOperation
    private(set) var result: [Note]? = []
    
    init(notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue) {
        
        loadFromBackendOperation = LoadNotesBackendOperation()
        loadFromDbOperaion = LoadNotesDBOperation(notebook: notebook)
        super.init()
        
        loadFromBackendOperation.completionBlock = {
            switch self.loadFromBackendOperation.result! {
            case .success(let notes):
                // task limit
                // replace notes in notebook
                self.result = notes
            case .failure:
                backendQueue.addOperation(self.loadFromDbOperaion)
            }
        }
        
        addDependency(loadFromBackendOperation)
        addDependency(loadFromDbOperaion)
        dbQueue.addOperation(loadFromBackendOperation)
    }
    
    override func main() {
        // improve later
        if let notes = loadFromDbOperaion.result {
            result = notes
        }
        finish()
    }
}
