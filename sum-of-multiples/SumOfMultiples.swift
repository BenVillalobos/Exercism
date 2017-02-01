//
//  SumOfMultiples.swift
//  Exercism
//
//  Created by Villalobos, Benjamin on 8/19/16.
//  Copyright © 2016 Villalobos, Benjamin. All rights reserved.
//

import Foundation

class SumOfMultiples {
  static func toLimit(limit: Int, inMultiples: [Int]) -> Int{
    var sum = 0
    for i in 1..<limit {
      for mult in inMultiples {
        if mult != 0 && i % mult == 0 {
          sum += i
          break
        }
      }
    }
    return sum
  }
}