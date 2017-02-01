//
//  NucleotideCount.swift
//  Exercism
//
//  Created by Villalobos, Benjamin on 7/28/16.
//  Copyright © 2016 Villalobos, Benjamin. All rights reserved.
//

import Foundation

class DNA {
  let strand: String
  let validTypes = NSCharacterSet(charactersInString: "ACGT")
  
  required init?(strand: String) {
    self.strand = strand
    
    //are there any characters that are NOT in the valid types? Invalid.
    if(strand.rangeOfCharacterFromSet(validTypes.invertedSet) != nil && !strand.isEmpty) {
      return nil
    }
  }
  
  func count(type: String) -> Int {
    return strand.componentsSeparatedByString(type).count - 1
  }
  
  func counts() -> [String: Int]{
    var returnValue = ["A": 0, "C": 0, "G": 0, "T": 0]
    
    let _ = strand.characters.map({returnValue[String($0)]! += 1})
    return returnValue
  }
}