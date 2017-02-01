//
//  ViewController.swift
//  Genetic Network Simulator
//
//  Created by Shaver, Kyle J on 9/13/16.
//  Copyright © 2016 csun.edu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var currentSelectedItem: SelectableItem?
  var chartView: ChartView?
  var allConnections = [Connection]()
  var allNodes = [Node]()
  var nextNodeID = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
    longPressRecognizer.delegate = self
    tapRecognizer.delegate = self
    self.view.gestureRecognizers = [longPressRecognizer, tapRecognizer]
  }
  
  // BUTTON
  
  @IBAction func testButton(_ sender: AnyObject) {
    
    // ======== Calculate Node Test ========
    
    //
    //    let time = 5
    //
    //    if let currentNode = currentSelectedItem as? Node {
    //      _ = currentNode.valueAtTime(time)
    //      currentNode.printValues()
    //    }
    
    
    //======== Create Chart with Ghost Test ============
    
    //    let time = 500
    //
    //    //Simulate node value change (since editting node/edge properties hasn't been implemented yet)
    //    if let currentNode = currentSelectedItem as? Node {
    //      _ = currentNode.valueAtTime(time)
    //      currentNode.printValues()
    //
    //      currentNode.setStartVal(n: 100)
    //      _ = currentNode.valueAtTime(100)
    //      currentNode.printValues()
    //
    //      createChartView(node: currentNode, ghostChart: true)
    //    }
    
    
    //======== Create Chart Test ============
    
    //Must Calculate Node first!
    //    if let currentNode = currentSelectedItem as? Node {
    //      createChartView(node: currentNode)
    //    }
    
    //======== Delete Item Test ============
    //    if let node = currentSelectedItem as? Node {
    //      deleteNode(node: node)
    //    }
    
    //    if let conn = currentSelectedItem as? Connection {
    //      deleteConnection(conn: conn)
    //    }
    
    
    //======== Create MultiNode Chart Test ============
    
    //    createMultiNodeChart([1.0, 2.0, 3.0, 4.0, 5.0],
    //                         [6.0, 7.0, 8.0, 9.0, 10.0],
    //                         [11.0, 12.0, 13.0, 14.0, 15.0],
    //                         [16.0, 17.0, 18.0, 19.0, 20.0])
    
    saveCurrentState()
    loadState()
  }
  
  // CHART
  
  func createChartView(node: Node, ghostChart: Bool = false){
    
    //Caution: node values must be calculated first
    chartView = ChartView(frame: view.frame)
    chartView?.chartData = node.values
    
    if ghostChart {chartView?.ghostData = node.lastValues!}
    
    view.addSubview(chartView!)
    chartView = nil
  }
  
  func createMultiNodeChart(_ data: [Float]...){
    
    chartView = ChartView(frame: view.frame)
    chartView!.multiChart = data
    
    view.addSubview(chartView!)
    chartView = nil
  }
  
  
  
  
  // TOUCH GESTURES
  
  //when the user taps anywhere on the main view it will deselect the current item
  func tap(_ tap: UITapGestureRecognizer) {
    deselectCurrentItem()
  }
  
  func longTap(_ longPress: UILongPressGestureRecognizer) {
    if longPress.state == .began {
      self.view.addSubview(createNode(longPress.location(in: self.view)))
    }
  }
  
  // ITEM SELECTION
  
  func deselectCurrentItem() {
    currentSelectedItem?.deselect()
    currentSelectedItem = nil
  }
  
  func selectItem(_ item: SelectableItem) {
    deselectCurrentItem()
    currentSelectedItem = item
    currentSelectedItem!.select()
  }
  
  // NODES
  func createNode(_ location: CGPoint) -> Node{
    let node = Node(frame: CGRect(x: location.x-Constants.nodeSize/2, y: location.y-Constants.nodeSize/2, width: Constants.nodeSize, height: Constants.nodeSize), delegate: self)
    node.id = nextNodeID
    nextNodeID += 1
    allNodes.append(node)
    return node
  }
  
  func nodeSelected(_ node: Node) {
    let currentNode = currentSelectedItem as? Node
    
    //json debug testing
    print(node.getJSON())
    
    deselectCurrentItem()
    
    
    selectItem(node)
    
    if currentNode != nil {
      //TODO: Connect 2 nodes if this is the second selected node
      connectNodes(currentNode!, nodeB: node)
    }
  }
  
  ///////////  conn   ///////////
  ///NodeA///========>///NodeB///
  ///////////         ///////////
  func deleteNode(node: Node) {
    
    clearNodeData(node: node)
    
    for conn in node.inEdges {
      deleteConnection(conn: conn)
    }
    for conn in node.outEdges {
      deleteConnection(conn: conn)
    }
    
    //node.printValues()
    //remove all references to connections, then reset currentSelectedItem
    node.removeFromSuperview()
    
    currentSelectedItem = nil
  }
  
  func clearNodeData(node: Node) {
    if(node.values.count <= 1) {
      return
    }
    //clear node
    node.resetValues()
    
    //for every connection going out
    //recursion!
    for conn in node.outEdges {
      clearNodeData(node: conn.line!.nodeB)
    }
  }
  
  func deleteConnection(conn: Connection) {
    if let index = allConnections.index(of: conn) {
      allConnections.remove(at: index)
    }
    clearNodeData(node: conn.line!.nodeA)
    conn.removeSelf()
    currentSelectedItem = nil
  }
  
  
  // CONNECTIONS
  func connectionSelected(_ connection: Connection) {
    
    //json debug testing
    print(connection.getJSON())
    
    let currentConnection = currentSelectedItem as? Connection
    deselectCurrentItem()
    if currentConnection == connection {
      return
    }
    selectItem(connection)
  }
  
  func connectNodes(_ nodeA: Node!, nodeB: Node) {
    //avoid duplicates
    if nodeA.nodeConnectionCheck(nodeB) == nil {
      //see if nodeB connects to nodeA already, then create a double arrow line
      if let reverseConnection = nodeB.nodeConnectionCheck(nodeA) {
        //tell the line which what type of connection to draw in reverse
        reverseConnection.line!.twoWayType = ConnectionType.activator
        let conn = Connection(nodeA: nodeA!, nodeB: nodeB, delegate: self, affRate: 0.5)
        
        reverseConnection.reverseConnection = conn
        nodeA.outEdges.append(conn)
        nodeB.inEdges.append(conn)
        allConnections.append(conn)
        deselectCurrentItem()
        reverseConnection.drawLine()
        return
      }
      
      if nodeA == nodeB {
        //magic numbers to fit the circle arrow in the center
        let imgView = UIImageView(frame: CGRect(x: Constants.nodeSize/7, y: Constants.nodeSize/7, width: Constants.nodeSize*0.7, height: Constants.nodeSize*0.7))
        imgView.image = #imageLiteral(resourceName: "Refresh")
        
        nodeA.addSubview(imgView)
      }
      
      let conn = Connection(nodeA: nodeA, nodeB: nodeB, delegate: self, affRate: 0.5)
      
      nodeA.outEdges.append(conn)
      nodeB.inEdges.append(conn)
      nodeB.resetValues()
      deselectCurrentItem()
      conn.drawLine()
      allConnections.append(conn)
    }
  }
  
  //FLAT FILE
  func saveCurrentState() {
    //nothing ot store
    if(allNodes.isEmpty) {
      print("Nothing to save bro")
      return
    }
    
    var nodes = [String]()
    var connections = [String]()
    

    
    print("Saving")
    
    for node in allNodes {
      nodes.append(node.getJSON())
    }
    
    if(!allConnections.isEmpty) {
      for conn in allConnections {
        connections.append(conn.getJSON())
      }
    }
    
    let dictionaryRepresentation = [
      "connections" : connections,
      "nodes" : nodes
      ] as [String : [String]]
    
    if JSONSerialization.isValidJSONObject(dictionaryRepresentation) {
      do {
        let data = try JSONSerialization.data(withJSONObject: dictionaryRepresentation)
        
        let directory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let file = directory.appendingPathComponent("savedData").appendingPathExtension("json")
        
        try data.write(to: file)
        
        let contents = try String(contentsOf: file)
        print(contents)
      } catch {
        print("Could not serialize JSON")
      }
    }
    print("Done Saving")
  }
  
  //bring this into branch 51
  func loadState() {
    print("Loading")
    let directory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let file = directory.appendingPathComponent("savedData").appendingPathExtension("json")
    
    do {
      let string = try String(contentsOf: file)
      print(string)
      let contents = try Data(contentsOf: file)
      print(String(describing: try Data(contentsOf: file)))
      
      if JSONSerialization.isValidJSONObject(string) {
        print("YES!")
      }
      
      let obj = try JSONSerialization.jsonObject(with: contents, options: .allowFragments)
      if let dictionary = obj as? [String: AnyObject] {
        //TODO: create everything based on whether it's a node/connection
        let _ = dictionary["OMGSTOPGIVINGMEAWARNING"]
      }
      
      print(contents);
    } catch {
      print("Couldn't load data!")
    }
    print("Done Loading")
  }
  
}

extension ViewController: ItemSelectedDelegate {
  func itemSelected(_ sender: SelectableItem) {
    
    if sender.selectableItemType == .node {
      nodeSelected(sender as! Node)
    }
    else if sender.selectableItemType == .connection {
      connectionSelected(sender as! Connection)
    }
  }
}

extension ViewController: UIGestureRecognizerDelegate {
  //ensures that subviews do not respond to longpress
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if touch.view!.isKind(of: ChartView.self){
      return false
    }
    return true
  }
}
