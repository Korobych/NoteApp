//
//  FileNotebook.swift
//  NoteApp
//
//  Created by Sergey Korobin on 30/06/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import Foundation

class FileNotebook{
    
    private(set) var notesArray: [Note] = []
    
    public func add(noteToAdd note:Note){
        // TODO: uid check
        notesArray.append(note)
    }
    
    public func remove(with uid:String){
        if let index: Int = notesArray.firstIndex(where: {$0.uid == uid}){
            notesArray.remove(at: index)
        }
    }
    
    public func saveToFile(){
        // TODO: move path to init
        guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = docURL.appendingPathComponent("Notes.json")
        
        let notes = notesArray.map{ $0.json }
        do {
            let data = try JSONSerialization.data(withJSONObject: notes, options: [])
            try data.write(to: fileURL, options: [])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func loadFromFile(){
        // TODO: move path to init
        guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = docURL.appendingPathComponent("Notes.json")
        do {
            let data = try Data(contentsOf: fileURL, options: [])
            guard let notes = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else { return }
            notesArray = notes.map{ Note.parse(json: $0)! }
        } catch {
            print(error.localizedDescription)
        }
    }
}
