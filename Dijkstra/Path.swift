//
//  Path.swift
//  Dijkstra
//
//  Created by Joost van Breukelen on 11-06-16.
//  Copyright © 2016 Joost van Breukelen. All rights reserved.
//

import Foundation

class Path{
    
    var total: Int!
    var destination: Vertex
    var previous: Path!
    
    init(){
        destination = Vertex()
    }
    
    
    func processDijkstra(source: Vertex, destination: Vertex) -> Path?{
        
        var frontier = [Path]()
        var finalPaths = [Path]()
        
        //use source Vertex's edges to create the frontier
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
        
        //start while loop
        while frontier.count != 0{
            
            bestPath = Path()
            var pathIndex = 0
            
            for x in 0..<frontier.count{
                
                let itemPath = frontier[x]
                
                if bestPath.total == nil || itemPath.total < bestPath.total{
                    bestPath = itemPath
                    pathIndex = x
                }
            }
            
            //use destination Vertex's edges to create new paths
            for edg in bestPath.destination.neighbors{
                
                let newPath = Path()
                newPath.destination = edg.neighbor
                newPath.previous = bestPath
                newPath.total = bestPath.total + edg.weight
                
                //add the paths to the frontier
                frontier.append(newPath)
            }
            
            //preserve the bestPath and remove it from the frontier
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

        
        var pr = shortestPath.previous
        var vertexRoute = [String]()
        vertexRoute.append(destination.key!)
        
        while pr != nil{
            vertexRoute.append(pr!.destination.key!)
            pr = pr?.previous
        }
        
        vertexRoute.append(source.key!)
        let reverseRoute = Array(vertexRoute.reverse())
        print(reverseRoute)
        
        return shortestPath
    }
    
}
