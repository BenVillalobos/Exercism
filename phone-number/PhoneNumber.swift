//
//  PhoneNumber.swift
//  Exercism
//
//  Created by Villalobos, Benjamin on 8/3/16.
//  Copyright © 2016 Villalobos, Benjamin. All rights reserved.
//

import Foundation

class PhoneNumber: CustomStringConvertible {
  var number: String = "0000000000"
  var areaCode: String = "000"
  var first3: String = "000"
  var last4: String = "0000"
  
  required init(num: String) {
    let temp = num.removeAllNonNumbers()
    
    if temp.characters.count == 10 {
      number = temp
    }
    else if temp.characters.count == 11 && temp.characters.first! == "1"{
      number = String(temp.characters.dropFirst())
    }
    areaCode = number[number.startIndex..<number.startIndex.advancedBy(3)]
    first3 = number[number.startIndex.advancedBy(3)..<number.startIndex.advancedBy(6)]
    last4 = number[number.endIndex.advancedBy(-4)..<number.endIndex]
  }
  
  var description: String {
    return "(\(areaCode)) \(first3)-\(last4)"
  }
  
}
extension String {
  func removeAllNonNumbers() -> String {
    return self.stringByReplacingOccurrencesOfString("[^1234567890]", withString: "", options: .RegularExpressionSearch, range: nil)
  }
}