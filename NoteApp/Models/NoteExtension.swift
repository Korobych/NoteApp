//
//  NoteExtension.swift
//  NoteApp
//
//  Created by Sergey Korobin on 30/06/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import Foundation
import UIKit

extension Note {
    
    static func parse(json: [String: Any]) -> Note? {
        
        guard let uid = json["uid"] as? String,
        let title = json["title"] as? String,
        let content = json["content"] as? String else {
                return nil
        }
        
        var color:UIColor {
            if let dictColor = json["color"] {
                return UIColor.parse(from: dictColor as! [String: Float])
            } else {
                return .white
            }
        }
        
        var importance: Importance {
            if let stringImportance = json["importance"] {
                return Importance(rawValue: stringImportance as! String)!
            } else {
                return .basic
            }
        }
        
        var date: Date? {
            if let selfDestructionDate = json["selfDestructionDate"] {
                let formatter = DateFormatter()
                formatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
                return formatter.date(from: selfDestructionDate as! String)
            } else {
                return nil
            }
        }
        
        return Note(uid: uid, title: title, content: content, color: color, importance: importance, selfDestructionDate: date)
    }
    
    var json: [String: Any] {
        var jsonDict = [String: Any]()
        
        jsonDict["uid"] = uid
        jsonDict["title"] = title
        jsonDict["content"] = content
        
        if color != UIColor.white {
            jsonDict["color"] = color.transformToDict()
        }
        
        if importance != .basic {
            jsonDict["importance"] = importance.rawValue
        }
        
        if let date = selfDestructionDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
            let dateString = formatter.string(from: date)
            jsonDict["selfDestructionDate"] = dateString
        }
        
        return jsonDict
    }
}

extension UIColor {
    func transformToDict() -> [String: Float] {
        var r: CGFloat = .zero
        var g: CGFloat = .zero
        var b: CGFloat = .zero
        var a: CGFloat = .zero
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return ["r": Float(r), "g": Float(g), "b": Float(b), "a": Float(a)]
    }
    
    static func parse(from dictionary: [String: Float]) -> UIColor {
        return UIColor(red: CGFloat(dictionary["r"]!), green: CGFloat(dictionary["g"]!), blue: CGFloat(dictionary["b"]!), alpha: CGFloat(dictionary["a"]!))
    }
}
