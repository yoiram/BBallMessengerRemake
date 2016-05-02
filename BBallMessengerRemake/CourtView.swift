//
//  gameCourtView.swift
//  BBallMessengerRemake
//
//  Created by Mario Youssef on 2016-04-28.
//  Copyright © 2016 Mario Youssef. All rights reserved.
//

import Foundation
import UIKit

class CourtView : UIView {
    private var rimEdges = [String:UIBezierPath] ()
    
    func addEdges(path:UIBezierPath?, named name:String) {
        rimEdges[name] = path
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        for (_,path) in rimEdges {
            UIColor.redColor().setFill()
            path.fill()
        }
    }
}