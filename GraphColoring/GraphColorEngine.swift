//
//  GraphColorEngine.swift
//  GraphColoring
//
//  Created by farhad jebelli on 12/16/18.
//  Copyright © 2018 farhad jebelli. All rights reserved.
//

import Foundation
import Cocoa

class GraphColorEngin {
    let colorGenerator = ColorGenerator()
    let graph: [VertexModel]
    
    let adjacency: [[Int]]
    
    init (graph: [VertexModel]) {
        self.graph = graph
        self.graph.enumerated().forEach({$1.index = $0})
        var adjacency = Array(repeating: [Int](), count: graph.count)
        for vertex in graph {
            for neighbor in vertex.neighbors {
                adjacency[vertex.index].append(neighbor.index)
                adjacency[neighbor.index].append(vertex.index)
            }
        }
        self.adjacency = adjacency
    }
    
    func colorize() -> GraphType {
        if isNoEdge() {
            colorNoEdge()
            return .noEdge
        }
        
        if isTree() {
            colorTree()
            return .tree
        }
        
        if isEvenCycle() {
            colorEvenCycle()
            return .evenCycle
        }
        if isOddCycle() {
            colorOddCycle()
            return .oddCycle
        }
        
        if isBipartite() {
            colorBipartite()
            return .bipartite
        }
        
        if isComplete() {
            colorComplete()
            return .complete
        }

        globalColoring()
        return .unknown
    }
    
    private func isNoEdge() -> Bool {
        return graph.count == 1
    }
    private func isCycle() -> [Int]? {
        var flags = Array(repeating: -1, count: graph.count)
        guard let first = graph.first, first.neighbors.count == 2 else {
            return nil
        }
        flags[first.index] = 0
        var index = 1
        var currnet = first.neighbors.first!
        while  flags[currnet.index] == -1 {
            flags[currnet.index] = index
            if currnet.neighbors.count != 2 {
                return nil
            }
            var next = currnet.neighbors.first!
            if flags[next.index] != -1 {
                next = currnet.neighbors.last!
            }
            if flags[next.index] == -1 {
                currnet = next
            }
            
            index += 1
        }
        let isAllFlagesTrue = flags.reduce(true, {$0 && $1 != -1})
        if isAllFlagesTrue && (currnet.neighbors.first!.tag == first.tag || currnet.neighbors.last!.tag == first.tag) {
            return flags
        }
        return nil
    }
    
    private func isEvenCycle() -> Bool {
        return isCycle() != nil && graph.count % 2 == 1
    }

    private func isOddCycle() -> Bool {
        return isCycle() != nil && graph.count % 2 == 0
    }

    private func isComplete() -> Bool {
        return graph.reduce(true, {$0 && $1.neighbors.count == graph.count - 1})
    }

    private func isBipartite() -> Bool {
        return bipartite() != nil
    }
    
    private func bipartite() -> [Int]? {
        var flags = Array(repeating: 0, count: graph.count)
        if bipartite(flags: &flags, index: 0, parrentFlag: 2) && flags.reduce(true, {$0 && $1 != 0}){
            return flags
        } else {
            return nil
        }
        
    }
    
    private func bipartite(flags: inout [Int], index: Int, parrentFlag: Int) -> Bool {
        if flags[index] != 0 {
            if flags[index] == parrentFlag {
                return false
            } else {
                return true
            }
        }
        let flag = 3 - parrentFlag
        flags[index] = flag
        var res = true
        for vertex in graph[index].neighbors {
            res = res && bipartite(flags: &flags, index: vertex.index, parrentFlag: flag)
        }
        return res
    }

    private func isTree() -> Bool {
        
        return tree() != nil
    }
    
    private func tree () -> [Int]? {
        var depth = Array(repeating: -1, count: graph.count)
        if tree(depht: &depth, index: 0, parrent: nil, currentDepth: 0) {
            return depth
        } else {
            return nil
        }
    }
    
    private func tree(depht: inout [Int], index: Int, parrent: Int?, currentDepth: Int) -> Bool {
        if depht[index] == -1 {
            depht[index] = currentDepth
            var resault = true
            for vertex in graph[index].neighbors {
                if let parrent = parrent, vertex.tag == graph[parrent].tag {
                    continue
                }
            resault = resault && tree(depht: &depht, index: vertex.index, parrent: index, currentDepth: currentDepth + 1)
            }
            return resault
        } else {
            return false
        }
    }

    private func colorNoEdge() {
        graph.first?.color = colorGenerator.nextColor()
        
    }
    private func colorEvenCycle() {
        let first = colorGenerator.nextColor()
        let secound = colorGenerator.nextColor()
        let third = colorGenerator.nextColor()
        let flags = isCycle()!
        for vertex in graph {
            if flags[vertex.index] == graph.count - 1 {
                vertex.color = third
            } else if flags[vertex.index] % 2 == 0 {
                vertex.color = first
            } else if flags[vertex.index] % 2 == 1 {
                vertex.color = secound
            }
        }
        
    }
    
    private func colorOddCycle() {
        let first = colorGenerator.nextColor()
        let secound = colorGenerator.nextColor()
        let flags = isCycle()!
        for vertex in graph {
            if flags[vertex.index] % 2 == 0 {
                vertex.color = first
            } else if flags[vertex.index] % 2 == 1 {
                vertex.color = secound
            }
        }
    }
    
    private func colorComplete() {
        for vertex in graph {
            vertex.color = colorGenerator.nextColor()
        }
    }
    
    private func colorBipartite() {
        let first = colorGenerator.nextColor()
        let last = colorGenerator.nextColor()
        let flags = bipartite()!
        for vertex in graph {
            vertex.color = flags[vertex.index] == 1 ? first : last
        }
    }
    
    private func colorTree() {
        let flags = tree()!
        let first = colorGenerator.nextColor()
        let last = colorGenerator.nextColor()
        for vertex in graph {
            vertex.color = flags[vertex.index] % 2 == 1 ? first : last
        }
    }
    private func globalColoring() {
        let flags = global()
        let max = flags.max()!
        var colors: [NSColor?] = Array(repeating: nil, count: max+1)
        for index in flags {
            if colors[index] == nil {
                colors[index] = colorGenerator.nextColor()
            }
        }
        
        for (index, vertex) in graph.enumerated() {
            vertex.color = colors[flags[index]]!
        }
        
    }
    private func global() -> [Int] {

        var result = Array(repeating: -1, count: graph.count)
        
        // Assign the first color to first vertex
        result[0]  = 0;

        var available = Array(repeating: false, count: graph.count)
        // Assign colors to remaining V-1 vertices
        for u in (1..<graph.count) {
            // Process all adjacent vertices and flag their colors
            // as unavailable
            for i in adjacency[u] {
                if (result[i] != -1) {
                    available[result[i]] = true
                }
            }
            // Find the first available color
            let cr = available.enumerated().filter({$1 == false}).first?.offset

            result[u] = cr! // Assign the found color
            
            // Reset the values back to false for the next iteration
            for i in adjacency[u] {
                if (result[i] != -1) {
                    available[result[i]] = false
                }
            }
        }
        return result
    }
}
