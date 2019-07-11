//
//  CirlceViewWithTick.swift
//  NoteApp
//
//  Created by Sergey Korobin on 11/07/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import UIKit

class CirlceViewWithTick: UIView {

    override func draw(_ rect: CGRect) {
        // Doing circle
        let path = UIBezierPath()
        let radius = CGFloat(12.0)
        let center = CGPoint(x: rect.width*0.75, y: rect.height*0.25)
        
        path.move(to: CGPoint(x: center.x + radius, y: center.y))
        
        for i in stride(from: 0.0, to: 361.0, by: 10){
            let radians = i * Double.pi / 180
            let x = Double(center.x) + Double(radius) * Double(cos(radians))
            let y = Double(center.y) + Double(radius) * Double(sin(radians))
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.lineWidth = 1.0
        path.stroke()
        
        // Doing tick lines
        path.lineWidth = 1.5
        path.move(to: CGPoint(x: center.x - 10.0, y: center.y))
        path.addLine(to: CGPoint(x: center.x, y: center.y + 9.0))
        path.addLine(to: CGPoint(x: center.x + 8.0, y: center.y - 7.0))
        path.stroke()
    }

}
