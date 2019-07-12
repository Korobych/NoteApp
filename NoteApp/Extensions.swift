//
//  Extensions.swift
//  NoteApp
//
//  Created by Sergey Korobin on 12/07/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    // Transforming UIColor to HEX string
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}
