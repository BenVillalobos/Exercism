//
//  Accumulate.swift
//  Exercism
//
//  Created by Villalobos, Benjamin on 8/19/16.
//  Copyright © 2016 Villalobos, Benjamin. All rights reserved.
//

import Foundation

extension Array{
  //Welp. At least I was close
  func accumulate<T>(operation: (Element) -> T) -> [T] {
    
    var elements = [T]()
    for item in self {
      elements.append(operation(item))
    }
    
    return elements

  }
}