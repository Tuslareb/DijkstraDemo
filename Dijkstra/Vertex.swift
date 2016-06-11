//
//  Vertex.swift
//  Dijkstra
//
//  Created by Joost van Breukelen on 11-06-16.
//  Copyright © 2016 Joost van Breukelen. All rights reserved.
//

import Foundation

class Vertex{
    
    var key: String?
    var neighbors: [Edge]
    
    init(){
        self.neighbors = [Edge]()
    }
}
