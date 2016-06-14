//
//  PathHeap.swift
//  Dijkstra
//
//  Created by Joost van Breukelen on 12-06-16.
//  Copyright © 2016 Joost van Breukelen. All rights reserved.
//

import Foundation

class PathHeap {
    
    var heap: Array<Path>
    
    init() {
        heap = Array<Path>()
    }
    
    
    //the number of frontier items
    var count: Int {
        return self.heap.count
    }
    
    
    
    //obtain the minimum path
    func peek() -> Path! {
        
        if (heap.count > 0) {
            return heap[0] //the shortest path
        }
        else {
            return nil
        }
    }
    
    
    
    //remove the minimum path
    func deQueue() {
        
        if (heap.count > 0) {
            heap.removeAtIndex(0)
        }
        
    }
    
    
    //sort shortest paths into a min-heap (heapify)
    func enQueue(key: Path) {
        
        print("enqueue path with destination: \(key.destination.key)")
        
        heap.append(key)
        print("on heap: path with destination: \(heap.last?.destination.key)")
        
        
        var childIndex: Float = Float(heap.count) - 1
        var parentIndex: Int! = 0
        
        
        //calculate parent index
        if (childIndex != 0) {
            parentIndex = Int(floorf((childIndex - 1) / 2))
        }
        
        
        var childToUse: Path
        var parentToUse: Path
        
        
        //use the bottom-up approach
        while childIndex != 0 {
            
            
            childToUse = heap[Int(childIndex)]
            parentToUse = heap[parentIndex]
            
            
            //swap child and parent positions
            if childToUse.total < parentToUse.total {
                print("swap parent with index \(parentIndex) with child with index: \(childIndex)")
                swap(&heap[parentIndex], &heap[Int(childIndex)])
            }
            
            
            //reset indices
            childIndex = Float(parentIndex)
            
            
            if (childIndex != 0) {
                parentIndex = Int(floorf((childIndex - 1) / 2))
            }
           print("parent now is \(heap.first?.destination.key) and childIndex is now \(childIndex)")

            
            
        } //end while
        
        
    } //end function
    
    
    
}
