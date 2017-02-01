//
//  Allergies.swift
//  Exercism
//
//  Created by Villalobos, Benjamin on 8/9/16.
//  Copyright © 2016 Villalobos, Benjamin. All rights reserved.
//

import Foundation

enum Allergy: Int {
  case Eggs = 1
  case Peanuts = 2
  case Shellfish = 4
  case Strawberries = 8
  case Tomatoes = 16
  case Chocolate = 32
  case Pollen = 64
  case Cats = 128
}

class Allergies {
  let score: Int
  init(score: Int) {
    self.score = score
  }
  
  func hasAllergy(type: Allergy) -> Bool {
    //binary flags!
    return type.rawValue & score != 0
  }
}