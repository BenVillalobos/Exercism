//
//  Hamming.swift
//  Exercism
//
//  Created by Villalobos, Benjamin on 7/22/16.
//  Copyright © 2016 Villalobos, Benjamin. All rights reserved.
//

import Foundation

class Hamming {
  static func compute(string: String, against: String) -> Int?{
    if string.characters.count != against.characters.count {
      return nil
    }
    
//    for i in 0..<string.characters.count {
//      if string[string.startIndex.advancedBy(i)] != against[against.startIndex.advancedBy(i)] {
//        count += 1
//      }
//    }
    var count = 0
    for (charA, charB) in zip(string.characters, against.characters) {
      if charA != charB {
        count += 1
      }
    }
    return count
  }
}