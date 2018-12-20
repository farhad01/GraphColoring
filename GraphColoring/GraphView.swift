//
//  GraphView.swift
//  GraphColoring
//
//  Created by farhad jebelli on 12/15/18.
//  Copyright © 2018 farhad jebelli. All rights reserved.
//

import Cocoa

class GraphView: NSView {
    
    var intractor: IntractorProtocol?
    
    let vertexRadius: CGFloat = 25
    @IBOutlet var graphType: NSTextFieldCell!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setupView()
        
    }
    
    private func setupView() {
        pressureConfiguration = NSPressureConfiguration(pressureBehavior: .primaryDeepClick)
        self.intractor = GraphIntractor(graphView: self)
        
    }
    
    override func mouseDown(with event: NSEvent){

        intractor?.userClicked(x: event.locationInWindow.x, y: event.locationInWindow.y)
        
    }
    
    override func rightMouseDown(with event: NSEvent) {
        intractor?.userRightClick(x: event.locationInWindow.x, y: event.locationInWindow.y)
    }
    
    override func mouseMoved(with event: NSEvent) {
        intractor?.mouseMoved(x: event.locationInWindow.x, y: event.locationInWindow.y)
    }
    
    override func mouseEntered(with event: NSEvent) {
       
    }
    
    
    
    override func mouseExited(with event: NSEvent) {
        intractor?.mouseExited()
    }
    
    func setNeedsDisplay() {
        setNeedsDisplay(bounds)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if let shadow = intractor?.shadow {
            drawShadow(point: shadow)
        }
        for vertex in intractor?.graph ?? [] {
            for neighbor in vertex.neighbors {
                drawEdge(from: vertex, to: neighbor)
            }
        }
        for (index,vertex) in (intractor?.graph ?? []).enumerated() {
            drawVertex(vertex: vertex, isSelected: index == intractor?.selected)
        }
    }
    
    private func drawVertex(vertex: VertexModel, isSelected: Bool) {
        let bezier = NSBezierPath()
        bezier.appendArc(withCenter: vertex.point, radius: vertexRadius, startAngle: 0, endAngle: 360)
        bezier.lineWidth = 3
        vertex.color.setFill()
        if isSelected {
            NSColor.red.setStroke()
        } else {
            NSColor.gray.withAlphaComponent(0.5).setStroke()
        }
        bezier.fill()
        bezier.stroke()
        
        
        NSColor.white.set()
        let attributed = NSAttributedString(string: "\(vertex.tag)")
        
        attributed.draw(at: vertex.point)
        
    }
    
    private func drawEdge(from: VertexModel, to: VertexModel) {
        let bezier = NSBezierPath()
        bezier.move(to: from.point)
        bezier.line(to: to.point)
        bezier.lineWidth = 2
        NSColor.black.setStroke()
        bezier.stroke()
        
    }
    
    private func drawShadow(point: CGPoint) {
        let bezier = NSBezierPath()
        bezier.appendArc(withCenter: point, radius: vertexRadius, startAngle: 0, endAngle: 360)
        bezier.lineWidth = 2
        bezier.setLineDash([0.0 ,12], count: 90, phase: 0)
        NSColor.gray.withAlphaComponent(0.5).setStroke()
        bezier.stroke()
    }
    
}


extension NSColor {
    func negative() -> NSColor {
        
        return NSColor(red: 1-self.redComponent, green: 1-self.greenComponent, blue: 1-self.blueComponent, alpha: 1)
    }
}
