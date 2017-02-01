//
//  PerfectNumbers.swift
//  Exercism
//
//  Created by Villalobos, Benjamin on 8/8/16.
//  Copyright © 2016 Villalobos, Benjamin. All rights reserved.
//

import Foundation

enum Classification {
  case Perfect
  case Abundant
  case Deficient
  
  init(number: Int) {
    var sumOfFactors = 1
    
    for i in 2...number/2 {
      if number % i == 0 {
        sumOfFactors += i
      }
    }
    self = (sumOfFactors == number ? .Perfect : (sumOfFactors > number ? .Abundant : .Deficient))
  }
}
class NumberClassifier {
  let number: Int
  var classification: Classification = .Perfect
  
  init(number: Int) {
    self.number = number
    classification = Classification(number: self.number)
  }
}