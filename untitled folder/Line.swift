//
//  Line.swift
//  Genetic Network Simulator
//
//  Created by Villalobos, Benjamin on 9/20/16.
//  Copyright © 2016 csun.edu. All rights reserved.
//

import UIKit

class Line: CAShapeLayer {
  var type: ConnectionType
  let nodeA: Node!
  let nodeB: Node!
  let lineColor = UIColor.black
  let selectedColor = UIColor.red
  var twoWayType: ConnectionType?
  
  var afflectionRate: Float
  var timeDelay: Int = 0
  
  let highlightLine: CAShapeLayer
  
  private var selected = false
  var setSelected: Bool {
    get{
      return selected
    }
    set (value){
      selected = value
      if !selected { highlightLine.removeFromSuperlayer() }
    }
  }
  
  required init(nodeA: Node, nodeB: Node, type: ConnectionType = .neutral, affRate: Float = 1) {
    self.type = type
    self.nodeA = nodeA
    self.nodeB = nodeB
    self.afflectionRate = affRate
    highlightLine = CAShapeLayer()
    
    
    super.init()
  }
  
  deinit {
    print("Line Deinitialized")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func getJSON() -> String {
      let dictionaryRepresentation = [
        "nodeAId" : nodeA.id,
        "nodeBId" : nodeB.id,
        "affRate": afflectionRate,
        "timeDelay": timeDelay] as [String : Any]
      
      if JSONSerialization.isValidJSONObject(dictionaryRepresentation) {
        do {
          let data = try JSONSerialization.data(withJSONObject: dictionaryRepresentation)
          return String(describing: NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
        }
        catch {
          return "OMGSOMETHINGWENTWRONG"
        }
      }
      return "Invalid representation of data"
  }
  
  func drawLine() {
    //no need to draw the line if it's referencing itself
    if nodeA == nodeB {
      return
    }
    if !selected {
      let path =
        (type == ConnectionType.activator) ?
          UIBezierPath.bezierPathWithArrowFromPoint(nodeA.center, endPoint: nodeB.center, tailWidth: Constants.lineWidth, headWidth: Constants.arrowSize, headlength: Constants.arrowSize, twoWayType: twoWayType)
          
        : (type == ConnectionType.inhibitor) ?
        UIBezierPath.bezierPathWithBarFromPoint(startPoint: nodeA.center, endPoint: nodeB.center, tailWidth: Constants.lineWidth, headWidth: Constants.arrowSize, headlength: Constants.arrowSize, twoWayType: twoWayType)
          
        :UIBezierPath.bezierPathWithArrowFromPoint(nodeA.center, endPoint: nodeB.center, tailWidth: Constants.lineWidth, headWidth: Constants.arrowSize, headlength: Constants.arrowSize, twoWayType: twoWayType)

      self.path = path.cgPath
      self.strokeColor = lineColor.cgColor
      self.lineWidth = Constants.lineWidth
      
      let superView = nodeA.superview!
      superView.layer.addSublayer(self)
      superView.bringSubview(toFront: nodeA)
      superView.bringSubview(toFront: nodeB)
    }
    else {
      drawRedLine()
    }
  }
  
  func drawRedLine() {
    let path = type == ConnectionType.activator ?
      UIBezierPath.bezierPathWithArrowFromPoint(nodeA.center, endPoint: nodeB.center, tailWidth: Constants.lineWidth, headWidth: Constants.arrowSize, headlength: Constants.arrowSize, twoWayType: twoWayType)
      : UIBezierPath.bezierPathWithBarFromPoint(startPoint: nodeA.center, endPoint: nodeB.center, tailWidth: Constants.lineWidth, headWidth: Constants.arrowSize, headlength: Constants.arrowSize, twoWayType: twoWayType)

    highlightLine.path = path.cgPath
    highlightLine.strokeColor = selectedColor.cgColor
    highlightLine.fillColor = selectedColor.cgColor
    highlightLine.lineWidth = Constants.lineWidth
    
    let superView = nodeA.superview!
    superView.layer.addSublayer(highlightLine)
    superView.bringSubview(toFront: nodeA)
    superView.bringSubview(toFront: nodeB)
  }
  
  func update() {
    self.removeFromSuperlayer()
    highlightLine.removeFromSuperlayer()
    drawLine()
  }
  
  override func removeFromSuperlayer() {
    super.removeFromSuperlayer()
    highlightLine.removeFromSuperlayer()
  }
}
