//
//  Node.swift
//  Genetic Network Simulator
//
//  Created by Villalobos, Benjamin on 9/13/16.
//  Copyright © 2016 csun.edu. All rights reserved.
//

import UIKit

class Node: DragView {
  let selectableItemType: SelectableItemType = SelectableItemType.node
  let selectionDelegate: ItemSelectedDelegate
  
  // DATA
  var values: [Float] = []
  var lastValues: [Float]?
  var startVal: Float
  var id: Int
  // EDGES
  var inEdges: [Connection] = []
  var outEdges: [Connection] = []
  
  required init(frame: CGRect, delegate: ItemSelectedDelegate, startVal: Float = 2) {
    selectionDelegate = delegate
    self.startVal = startVal
    id = 0
    super.init(frame: frame)
    self.layer.cornerRadius = self.frame.width/2
    // DATA
    values.append(startVal)
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(detectTap(_:)))
    self.gestureRecognizers?.append(tapRecognizer)
  }
  
  deinit {
    print("Node Deinitialized")
  }
  
  func detectTap(_ recognizer:UITapGestureRecognizer){
    selectionDelegate.itemSelected(self)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func getJSON() -> String {
    let dictionaryRepresentation = [
      "id" : id,
      "x" : String(format: "%.2f", self.center.x/superview!.bounds.width),
      "y": String(format: "%.2f", self.center.y/superview!.bounds.height),
      "startVal": self.startVal] as [String : Any]
    
    if JSONSerialization.isValidJSONObject(dictionaryRepresentation) {
      do {
        let data = try JSONSerialization.data(withJSONObject: dictionaryRepresentation)
        return String(describing: NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
      } catch {
        return "OMGSOMETHINGWENTWRONG"
      }
    }
    return "Invalid representation of data"
  }
  
  func removeSelf() {
    for conn in inEdges {
      conn.removeSelf()
    }
    for conn in outEdges {
      conn.removeSelf()
    }
    inEdges.removeAll()
    outEdges.removeAll()
    self.removeFromSuperview()
  }
  
  func removeConnection(conn: Connection) {
    if let index = inEdges.index(of: conn) {
      inEdges.remove(at: index)
    }
    if let index = outEdges.index(of: conn) {
      outEdges.remove(at: index)
    }
    conn.line!.removeFromSuperlayer()
    conn.removeFromSuperview()
  }
  
  override func moved() {
    if !inEdges.isEmpty {
      for path in inEdges {
        path.update()
      }
    }
    if !outEdges.isEmpty {
      for path in outEdges {
        path.update()
      }
    }
  }

  func nodeConnectionCheck(_ node: Node)-> Connection? {
    for edge in outEdges {
      if edge.line!.nodeB == node {
        return edge
      }
    }
    return nil
  }
  
  // DATA
  func valueAtTime(_ time: Int) -> Float{
    var maxTime = values.count-1
    
    while maxTime < time {
      nextValue()
      maxTime+=1
    }
    
    return values[time]
  }
  
  func nextValue(){
    var value = values.last
    
    for edge in inEdges{
      value = value! + (edge.line!.nodeA.valueAtTime(values.count-1) * edge.line!.afflectionRate)
    }
    
    values.append(value!)
  }
  
  
  
  func setStartVal(n: Float){
    startVal = n
    resetValues()
  }
  
  
  
  func resetValues(){
    //Used when new node is added or any value has changed.
    lastValues = values
    values.removeAll()
    values.append(startVal)
  }
  
  func printValues(){
    print("Node values (Time \(values.count-1)): \(values) ")
  }
  
}

extension Node: SelectableItem {
  func select() {
    layer.borderColor = UIColor.black.cgColor
  }
  
  func deselect() {
    layer.borderColor = UIColor.clear.cgColor
  }
}
