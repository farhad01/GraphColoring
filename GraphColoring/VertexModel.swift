//
//  VertexModel.swift
//  GraphColoring
//
//  Created by farhad jebelli on 12/15/18.
//  Copyright © 2018 farhad jebelli. All rights reserved.
//

import Cocoa

class VertexModel {
    let tag: Int
    var neighbors: [VertexModel] = []
    var color: NSColor
    let point: CGPoint
    var index: Int
    
    init(tag: Int, point: CGPoint) {
        self.tag = tag
        self.color = NSColor.gray
        self.point = point
        self.index = 0
    }
    
}
