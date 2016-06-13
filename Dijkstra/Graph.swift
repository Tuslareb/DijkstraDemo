//
//  Graph.swift
//  Dijkstra
//
//  Created by Joost van Breukelen on 11-06-16.
//  Copyright © 2016 Joost van Breukelen. All rights reserved.
//

import Foundation

protocol pathDelegate {
    func didFinishDijkstraInSeconds(seconds: NSTimeInterval)
    func didFinishOptimizedDijkstraInSeconds(seconds: NSTimeInterval)
}

class Graph{
    
    //declare canvas
    var canvas: [Vertex]
    var delegate: pathDelegate?
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
    
    
    private func getCurrentMilliseconds() -> NSTimeInterval {
        let date: NSDate = NSDate()
        return date.timeIntervalSince1970*1000
    }
    
    
    // MARK: - Processing
    
    ///the default Dijkstra algorithm
    func processDijkstra(source: Vertex, destination: Vertex) -> Path?{
        
        var frontier = [Path]()
        var finalPaths = [Path]()
        let startTime = getCurrentMilliseconds()
        
        //use source Vertex's edges to create the frontier. The frontier is an array with all the paths adjecent to the source vertex.
        for edg in source.neighbors{
            
            let newPath = Path()
            newPath.destination = edg.neighbor
            newPath.previous = nil
            newPath.total = edg.weight
            
            //add first paths to frontier
            frontier.append(newPath)
        }
        
        //construct the best path
        var bestPath = Path()
        
        //start while loop. This will run until there are no more paths in the frontier.
        while frontier.count != 0{
            
            bestPath = Path()
            var pathIndex = 0
            
            //from all the paths currently in the frontier array, get the shortest (best) one. This isn't necessarily the first step of the final shortest route. It's just the path to the closest vertex (the path with the least weight).
            for x in 0..<frontier.count{
                
                let itemPath = frontier[x]
                
                if bestPath.total == nil || itemPath.total < bestPath.total{
                    bestPath = itemPath
                    pathIndex = x
                }
            }
            
            //get the destination vertex of the best path. Get all of the neighbors of the destination vertex and create paths from the destination vertex to all of its neighbors. It's possible the destinatoion vertex doesn't have a neighbor. In that case, nothing is added to the frontier. This way, the frontier will steadily empty itself. 
            for edg in bestPath.destination.neighbors{
                
                let newPath = Path()
                newPath.destination = edg.neighbor
                newPath.previous = bestPath
                newPath.total = bestPath.total + edg.weight
                
                //add the new paths to the frontier. The frontier now contains all the paths that originate from the source vertex but also all the paths that originate from the destination vertex of the first best path (which originated from the source vertex)
                frontier.append(newPath)
            }
            
            //preserve the bestPath and remove it from the frontier. The frontier now contains all the paths like before, with the exception of the bestPath. After the removal, the while loop will start again.
            finalPaths.append(bestPath)
            frontier.removeAtIndex(pathIndex)
            
        } //end while
        
        //get the shortest path
        var shortestPath: Path! = Path()
        
        for itemPath in finalPaths{
            
            if itemPath.destination.key == destination.key{
                
                if shortestPath.total == nil || itemPath.total < shortestPath.total{
                    shortestPath = itemPath
                }
            }
        }
        
        let endTime = getCurrentMilliseconds()
        delegate?.didFinishDijkstraInSeconds(endTime - startTime)
        
//                var pr = shortestPath.previous
//                var vertexRoute = [String]()
//                vertexRoute.append(destination.key!)
//        
//                while pr != nil{
//                    vertexRoute.append(pr!.destination.key!)
//                    pr = pr?.previous
//                }
//        
//                vertexRoute.append(source.key!)
//                let reverseRoute = Array(vertexRoute.reverse())
//                print(reverseRoute)
        print(shortestPath.total)
        
        return shortestPath
    }
    
    
    ///an optimized version of Dijkstra's shortest path algorthim
    func processDijkstraWithHeap(source: Vertex, destination: Vertex) -> Path! {
        
        
        let frontier: PathHeap = PathHeap()
        let finalPaths: PathHeap = PathHeap()
        let startTime = getCurrentMilliseconds()
        
        
        //use source edges to create the frontier
        for e in source.neighbors {
            
            let newPath: Path = Path()
            
            
            newPath.destination = e.neighbor
            newPath.previous = nil
            newPath.total = e.weight
            
            
            //add the new path to the frontier
            frontier.enQueue(newPath)
            
        }
        
        
        //construct the best path
        var bestPath: Path = Path()
        
        
        while frontier.count != 0 {
            
            //use the greedy approach to obtain the best path
            bestPath = Path()
            bestPath = frontier.peek()
            
            
            //enumerate the bestPath edges
            for e in bestPath.destination.neighbors {
                
                let newPath: Path = Path()
                
                newPath.destination = e.neighbor
                newPath.previous = bestPath
                newPath.total = bestPath.total + e.weight
                
                //add the new path to the frontier
                frontier.enQueue(newPath)
                
            }
            
            
            //preserve the bestPaths that match destination
            if (bestPath.destination.key == destination.key) {
                print("there a bestpath with correct destination")
                finalPaths.enQueue(bestPath)
            }
            
            
            //remove the bestPath from the frontier
            frontier.deQueue()
            
            print(frontier.heap)
            
            
        } //end while
        
        
        
        //obtain the shortest path from the heap
        var shortestPath: Path! = Path()
        shortestPath = finalPaths.peek()
        
        let endTime = getCurrentMilliseconds()
        delegate?.didFinishOptimizedDijkstraInSeconds(endTime - startTime)
        
        
//            var pr = shortestPath.previous
//            var vertexRoute = [String]()
//            vertexRoute.append(destination.key!)
//            
//            while pr != nil{
//                vertexRoute.append(pr!.destination.key!)
//                pr = pr?.previous
//            }
//            
//            vertexRoute.append(source.key!)
//            let reverseRoute = Array(vertexRoute.reverse())
//            print(reverseRoute)
        
        if let sp = shortestPath{
            
            print(sp.total)
            
        }
        else{
            print("shortest path is nil")
        }
        
        

        
        return shortestPath
        
    }

    
    
    
}

