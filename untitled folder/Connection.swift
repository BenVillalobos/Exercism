//
//  Connection.swift
//  Genetic Network Simulator
//
//  Created by Villalobos, Benjamin on 9/20/16.
//  Copyright © 2016 csun.edu. All rights reserved.
//

import UIKit

//A connection is a wrapper for a Line so that a Line has a hitbox.
class Connection: UIView {
  var line: Line?
  var reverseConnection: Connection?
  var i = 0
  let delegate: ItemSelectedDelegate
  let selectableItemType: SelectableItemType = SelectableItemType.connection

  required init(nodeA: Node, nodeB: Node, delegate: ItemSelectedDelegate, affRate: Float = 1) {
    let type = (affRate < 0) ? ConnectionType.inhibitor :
      (affRate > 0) ? ConnectionType.activator : ConnectionType.neutral
    line = Line(nodeA: nodeA, nodeB: nodeB, type: type, affRate: affRate)
    self.delegate = delegate

    super.init(frame: CGRect())
    update()
    
    backgroundColor = randomColor()
    
    nodeA.superview?.addSubview(self)
    nodeA.superview?.sendSubview(toBack: self)
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
    
    self.gestureRecognizers = [tapRecognizer]
  }
  
  deinit {
    print("Connection Deinitialized")
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func getJSON() -> String {
      return line!.getJSON()
  }
  
  func removeSelf() {
    line!.nodeA.removeConnection(conn: self)
    line!.nodeB.removeConnection(conn: self)
    reverseConnection?.line?.nodeB.removeConnection(conn: reverseConnection!)
    reverseConnection?.line?.nodeA.removeConnection(conn: reverseConnection!)
    reverseConnection = nil
    line = nil
    removeFromSuperview()
  }
  
  func tapped() {
    delegate.itemSelected(self)
  }
  
  func drawLine() {
    line!.drawLine()
  }
  
  func update() {
    let centerA = line!.nodeA.center
    let centerB = line!.nodeB.center
    
    let midPoint = CGPoint(x: 0.5 * (centerA.x + centerB.x), y: 0.5 * (centerA.y + centerB.y))
    let lengthY = Float(centerA.y - centerB.y)
    let lengthX = Float(centerA.x - centerB.x)
    
    let angle = atan2(lengthY, lengthX)
    let distBetweenNodes = hypotf(lengthX, lengthY)
    
    layer.bounds = CGRect(origin: centerA, size: CGSize(width: CGFloat(distBetweenNodes), height: Constants.nodeSize/2))
    layer.position = midPoint
    layer.transform = CATransform3DMakeRotation(CGFloat(angle), 0, 0, 1)
    
    line!.update()
  }
}

extension Connection: SelectableItem {
  func select() {
    line!.setSelected = true
    reverseConnection?.line!.setSelected = true
    line!.drawLine()
    reverseConnection?.drawLine()
  }
  
  func deselect() {
    line!.setSelected = false
    reverseConnection?.line!.setSelected = false
    line!.removeFromSuperlayer()
    reverseConnection?.line!.removeFromSuperlayer()
    line!.drawLine()
    reverseConnection?.drawLine()
  }
}
