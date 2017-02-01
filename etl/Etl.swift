//
//  Etl.swift
//  Exercism
//
//  Created by Villalobos, Benjamin on 7/26/16.
//  Copyright © 2016 Villalobos, Benjamin. All rights reserved.
//

import Foundation

class ETL {
  
  static func transform(old: [Int: [String]]) -> [String: Int] {
    var new = [String: Int]()
    
    for (score, letters) in old {
      for char in letters {
        new[char.lowercaseString] = score
      }
    }
    
    return new
  }
}