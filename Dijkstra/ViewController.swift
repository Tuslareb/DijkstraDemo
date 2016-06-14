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

    @IBOutlet weak var optimizedDijkstraButton: NSButton!
    @IBOutlet weak var optimizedDijkstraScoreLabel: NSTextField!
    @IBOutlet weak var optimizedDijkstraActivityIndicator: NSProgressIndicator!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dijkstraButton.enabled = false
        dijkstraActivityIndicator.hidden = true
        
        optimizedDijkstraButton.enabled = false
        optimizedDijkstraActivityIndicator.hidden = true
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
        
        optimizedDijkstraButton.enabled = false
        optimizedDijkstraScoreLabel.stringValue = "Score: ... ms"
        
        
        dispatch_async(GlobalUserInitiatedQueue){
        
            self.graph = Graph()
            self.graph.delegate = self
            var index: Int = 0
            var currentNode: Vertex!
            var currentChildren = [Vertex]()
            var amountOfChildrenPerNode: Int{
                
                return 2//Int(arc4random_uniform(UInt32(3)+1))
            }
            
            var weight: Int{

                return Int(arc4random_uniform(UInt32(10)+1))
            }
            
            let testWeights = [10, 1, 9, 1, 5]
            
            //create root vertex with index 0, add it's children and connect them.
            if index == 0{
                currentNode = self.graph.addVertex(key: String(index))
                //print("added root vertex with key \(index)")
                index += 1
            }
            
            while index < amount{
                
                
                if !currentChildren.isEmpty{
                    currentNode = currentChildren.first
                    currentChildren.removeAtIndex(0)
                }
                
                for _ in 0..<amountOfChildrenPerNode{
                    
                    //when the index is equal to max amount, we can't create any vertexes anymore, so break
                    if index == amount { break }
                    
                    let child = self.graph.addVertex(key: String(index))
                    //print("added vertex with key \(index)")
                    let w = testWeights[index - 1]
                    
                    self.graph.addEdge(source: currentNode, neighbor: child, weight: w)
                    //print("added edge from \(currentNode.key!) to \(child.key!) with weight: \(w)")
                    currentChildren.append(child)
                    index += 1
                }
                
            }
            
            
            
//                        let v0 = self.graph.addVertex(key: "0")
//                        let v1 = self.graph.addVertex(key: "1")
//                        let v2 = self.graph.addVertex(key: "2")
//                        let v3 = self.graph.addVertex(key: "3")
//                        let v4 = self.graph.addVertex(key: "4")
//                        let v5 = self.graph.addVertex(key: "5")
//                        let v6 = self.graph.addVertex(key: "6")
//            
//                        self.graph.addEdge(source: v0, neighbor: v1, weight: 4)
//                        self.graph.addEdge(source: v0, neighbor: v2, weight: 0)
//                        self.graph.addEdge(source: v1, neighbor: v3, weight: 4)
//                        self.graph.addEdge(source: v1, neighbor: v4, weight: 2)
//                        self.graph.addEdge(source: v2, neighbor: v5, weight: 3)
//                        self.graph.addEdge(source: v2, neighbor: v6, weight: 6)

            
            
            dispatch_async(GlobalMainQueue){
            
                //graphProgressIndicator.hidden = true
                self.graphButton.title = "New graph"
                self.dijkstraButton.enabled = true
                self.optimizedDijkstraButton.enabled = true
                
                for v in self.graph.canvas{

                    if v.neighbors.isEmpty{
                       //print("vertex \(v.key!) has no neighbours")
                    }
                    else{
                        for nb in v.neighbors{

                            print("There's a path from \(v.key!) to \(nb.neighbor.key!) with weight: \(nb.weight)")
                        }
                    }
                }

            }
        }
        
    }
    
    
    
    @IBAction func processDijkstra(sender: NSButton) {
        
        dijkstraActivityIndicator.hidden = false
        dijkstraActivityIndicator.startAnimation(self)
        dijkstraScoreLabel.stringValue = "Score: ... ms"
        


        guard let start = graph.giveVertexForPosition(.Start), let end = graph.giveVertexForPosition(.End) else {return}
        
        dispatch_async(GlobalUserInitiatedQueue){
                self.graph.processDijkstra(start, destination: end)
        }
 
    }
    

    @IBAction func processOptimizedDijkstra(sender: NSButton) {
        
        optimizedDijkstraActivityIndicator.hidden = false
        optimizedDijkstraActivityIndicator.startAnimation(self)
        optimizedDijkstraScoreLabel.stringValue = "Score: ... ms"
        
        guard let start = graph.giveVertexForPosition(.Start), let end = graph.giveVertexForPosition(.End) else {return}
        
        dispatch_async(GlobalUserInitiatedQueue){
            self.graph.processDijkstraWithHeap(start, destination: end)
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
    
    func didFinishOptimizedDijkstraInSeconds(seconds: NSTimeInterval){
        
        dispatch_async(GlobalMainQueue){
            
            let timeString = String(format: "%.2f", seconds)
            self.optimizedDijkstraScoreLabel.stringValue = "Score: \(timeString) ms"
            self.optimizedDijkstraActivityIndicator.stopAnimation(self)
            self.optimizedDijkstraActivityIndicator.hidden = true
            
        }
    }
    

    

}

