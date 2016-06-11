//
//  Graph.swift
//  Dijkstra
//
//  Created by Joost van Breukelen on 11-06-16.
//  Copyright © 2016 Joost van Breukelen. All rights reserved.
//

import Foundation

class Graph{
    
    //declare canvas
    private var canvas: [Vertex]
    var isDirected: Bool
    
    init() {
        canvas = [Vertex]()
        isDirected = true
    }
    
    //create a new vertex
    func addVertex(key key: String) -> Vertex{
        
        //set the key
        let newVertex = Vertex()
        newVertex.key = key
        
        //add the vertex to the graph canvas
        canvas.append(newVertex)
        
        return newVertex
    }
    
    //making connections
    func addEdge(source source: Vertex, neighbor: Vertex, weight: Int) {
        
        //ceate new edge
        let newEdge = Edge()
        
        //establisch default properties
        newEdge.neighbor = neighbor
        newEdge.weight = weight
        source.neighbors.append(newEdge)
        
        //directed or undirected? Undirected is two ways.
        if !isDirected{
            
            //create a new reversed edge (the other way)
            let reversedEdge = Edge()
            
            //reversed properties
            reversedEdge.neighbor = source
            reversedEdge.weight = weight
            neighbor.neighbors.append(reversedEdge)
        }
    }
    
    
    // MARK: - get information
    
    enum VertexPosition{ case Start, End, Random }
    
    func giveVertexForPosition(position: VertexPosition) -> Vertex?{
    
        switch position {
        case .Start:
            return canvas.first
        case .End:
            return canvas.last
        case .Random:
            let maximum = UInt32(canvas.count - 1)
            return  canvas[Int(arc4random_uniform(maximum))]
        }
    
    }
    
    
    
}

