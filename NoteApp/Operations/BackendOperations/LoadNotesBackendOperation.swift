//
//  LoadNotesBackendOperation.swift
//  NoteApp
//
//  Created by Sergey Korobin on 04/08/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import Foundation

enum LoadNotesBackendResult {
    case success([Note])
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    
    private(set) var result: LoadNotesBackendResult?
    
    override func main() {
        // task limit
        result = .failure(.unreachable)
        finish()
    }
}
