//
//  GraphIntractor.swift
//  GraphColoring
//
//  Created by farhad jebelli on 12/15/18.
//  Copyright © 2018 farhad jebelli. All rights reserved.
//

import Foundation

protocol IntractorProtocol {
    var graph: [VertexModel]? {get}
    var selected: Int? {get}
    var shadow: CGPoint? {get}
    
    func userClicked(x: CGFloat, y: CGFloat)
    func userRightClick(x: CGFloat, y: CGFloat)
    func mouseMoved(x: CGFloat, y: CGFloat)
    func mouseExited()
}

class GraphIntractor: IntractorProtocol {
    
    var graph: [VertexModel]? = []{
        didSet {
            
            graphView?.setNeedsDisplay()
        }
    }
    var selected: Int? {
        didSet {
            graphView?.setNeedsDisplay()
        }
    }
    
    var shadow: CGPoint? {
        didSet {
            //graphView?.displayIfNeeded()
        }
    }
    
    var lastTag: Int = 0
    
    //let nearlyOffsetPow2: Int =
    weak var graphView: GraphView?
    
    let colorGenerator: ColorGenerator = ColorGenerator()
    init(graphView: GraphView) {
        self.graphView = graphView
    }
    
    func userClicked(x: CGFloat, y: CGFloat) {
        let point = CGPoint(x: x, y: y)
        if let selected = self.selected {
            if let vertexNearby = getNearbyVertex(point: point) {
                if !isNeghbors(first: selected, second: vertexNearby) && selected != vertexNearby {
                    addEdge(first: selected, second: vertexNearby)
                    colorize()
                } else {
                    self.selected = vertexNearby
                }
                graphView?.setNeedsDisplay()
            } else {
                self.selected = nil
            }
        } else {
            if let vertexNearby = getNearbyVertex(point: point) {
                selected = vertexNearby
            } else {
                self.selected = addVertex(point: point)
                colorize()
            }
        }
    }
    
    func userRightClick(x: CGFloat, y: CGFloat) {
        let point = CGPoint(x: x, y: y)
        if let vertexNearby = getNearbyVertex(point: point) {
            removeVertex(index: vertexNearby)
            colorize()
            self.selected = nil
            
            
        }
    }
    
    func colorize() {
        guard let graph = self.graph, graph.count > 0 else {
            graphView?.graphType.title = ""
            return
        }
        let type = GraphColorEngin(graph: graph).colorize()
        graphView?.setNeedsDisplay()
        graphView?.graphType.title = type.rawValue
    }
    
    func mouseMoved(x: CGFloat, y: CGFloat) {
        shadow = CGPoint(x: x, y: y)
    }
    
    func mouseExited() {
        shadow = nil
    }
    
    func getNearbyVertex(point: CGPoint) -> Int? {
        for (index, value) in graph!.enumerated() {
            let diff = value.point - point
            if diff.magnitudePow2() < graphView!.vertexRadius * 2 * 2 *  graphView!.vertexRadius {
                return index
            }
        }
        return nil
    }
 
    private func removeVertex(index: Int) {
        let vertex = graph![index]
        
        for neigbor in vertex.neighbors {
            if let index = neigbor.neighbors.enumerated().filter({$0.element.tag == vertex.tag}).first?.offset {
                neigbor.neighbors.remove(at: index)
            }
        }
        
        graph?.remove(at: index)
        
    }
    
    private func findVertex(index: Int) -> VertexModel {
        return graph![index]
    }
    
    private func isNeghbors(first: Int, second: Int) -> Bool {
        return isNeghbors(first: findVertex(index: first), second: findVertex(index: second))
    }
    
    private func isNeghbors(first: VertexModel, second: VertexModel) -> Bool {
        return first.neighbors.contains(where: {$0.tag == second.tag})
    }
    
    private func addEdge(first: Int, second: Int) {
        addEdge(first: findVertex(index: first), second: findVertex(index: second))
    }
    
    private func addEdge(first: VertexModel, second: VertexModel) {
        first.neighbors.append(second)
        second.neighbors.append(first)
    }
    
    private func addVertex(point: CGPoint) -> Int {
        graph!.append(VertexModel(tag: lastTag, point: point))
        lastTag += 1
        return graph!.count - 1
    }
}
