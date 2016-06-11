//
//  ViewController.swift
//  Dijkstra
//
//  Created by Joost van Breukelen on 11-06-16.
//  Copyright © 2016 Joost van Breukelen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, pathDelegate {
    
    var nodeAmountValue: Int = 10
    var graph:Graph!
    
    @IBOutlet weak var nodeAmountTextField: NSTextField!
    @IBOutlet weak var nodeStepper: NSStepper!
    @IBOutlet weak var graphButton: NSButton!

    @IBOutlet weak var dijkstraButton: NSButton!
    @IBOutlet weak var dijkstraScoreLabel: NSTextField!
    @IBOutlet weak var dijkstraActivityIndicator: NSProgressIndicator!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dijkstraButton.enabled = false
        dijkstraActivityIndicator.hidden = true
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
        
        dijkstraButton.enabled = false
        dijkstraScoreLabel.stringValue = "Score: ... ms"
        
        dispatch_async(GlobalUserInitiatedQueue){
        
            self.graph = Graph()
            var index: Int = 0
            var currentNode: Vertex!
            var currentChildren = [Vertex]()
            var amountOfChildrenPerNode: Int{
                
                return Int(arc4random_uniform(UInt32(3)))
            }
            
            var weight: Int{
                return Int(arc4random_uniform(UInt32(10)))
            }
            
            //create root vertex with index 0
            if index == 0{
                currentNode = self.graph.addVertex(key: String(index))
                //print("added vertex with key \(index)")

                index += 1
            }
            
            while index <= amount{
                
                if !currentChildren.isEmpty{
                    currentNode = currentChildren.first
                    currentChildren.removeAtIndex(0)
                }
                
                for _ in 0..<amountOfChildrenPerNode{
                    
                    if index > amount {break}
     
                    let child = self.graph.addVertex(key: String(index))
    //                print("added vertex with key \(index)")
                    self.graph.addEdge(source: currentNode, neighbor: child, weight: weight)
                    currentChildren.append(child)
                    index += 1
                }
                
     
            }
            
            dispatch_async(GlobalMainQueue){
            
                //graphProgressIndicator.hidden = true
                self.graphButton.title = "New graph"
                self.dijkstraButton.enabled = true

            }
        }
        
    }
    
    
    
    @IBAction func processDijkstra(sender: NSButton) {
        
        dijkstraActivityIndicator.hidden = false
        dijkstraActivityIndicator.startAnimation(self)
        
        let path = Path()
        path.delegate = self
        guard let start = graph.giveVertexForPosition(.Start), let end = graph.giveVertexForPosition(.End) else {return}
        
        dispatch_async(GlobalUserInitiatedQueue){
            path.processDijkstra(start, destination: end)
        }

        
    }
    
    // MARK: - path delegate
    
    func didFinishDijkstraInSeconds(seconds: NSTimeInterval) {
        
        dispatch_async(GlobalMainQueue){
            
            let timeString = String(format: "%.2f", seconds)
            self.dijkstraScoreLabel.stringValue = "Score: \(timeString) ms"
            self.dijkstraActivityIndicator.stopAnimation(self)
            self.dijkstraActivityIndicator.hidden = true
        }
    }
    

    

}

