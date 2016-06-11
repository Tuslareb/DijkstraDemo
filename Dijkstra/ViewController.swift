//
//  ViewController.swift
//  Dijkstra
//
//  Created by Joost van Breukelen on 11-06-16.
//  Copyright © 2016 Joost van Breukelen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var nodeAmountValue: Int = 10
    var graph:Graph!
    
    @IBOutlet weak var nodeAmountTextField: NSTextField!
    @IBOutlet weak var nodeStepper: NSStepper!
    @IBOutlet weak var dijkstraButton: NSButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dijkstraButton.enabled = false
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func createGraphAction(sender: NSButton) {
        
        createGraph(nodes: nodeAmountValue)
    }
    
    // MARK: - Create graph
    
    private func createGraph(nodes amount: Int){
        
        graph = Graph()
        var index: Int = 0
        var currentNode: Vertex!
        var currentChildren = [Vertex]()
        var amountOfChildrenPerNode = 2
        var weight: Int{
            return 2
        }
        
        //create root vertex with index 0
        if index == 0{
            currentNode = graph.addVertex(key: String(index))
            print("added vertex with key \(index)")
            index += 1
        }
        
        while index < amount{
            
            if !currentChildren.isEmpty{
                currentNode = currentChildren.first
                currentChildren.removeAtIndex(0)
            }
            
            for _ in 0..<amountOfChildrenPerNode{
                
                let child = graph.addVertex(key: String(index))
                print("added vertex with key \(index)")
                graph.addEdge(source: currentNode, neighbor: child, weight: weight)
                currentChildren.append(child)
                index += 1
            }
 
        }
        print("ready")
        
        dijkstraButton.enabled = true
        
    }
    
    
    
    @IBAction func processDijkstra(sender: NSButton) {
        
        let path = Path()
        guard let start = graph.giveVertexForPosition(.Start), let end = graph.giveVertexForPosition(.End) else {return}
        path.processDijkstra(start, destination: end)
    }
    

    

}

