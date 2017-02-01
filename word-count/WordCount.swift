//
//  WordCount.swift
//  Exercism
//
//  Created by Villalobos, Benjamin on 7/22/16.
//  Copyright © 2016 Villalobos, Benjamin. All rights reserved.
//

import Foundation

class WordCount {
  let words: String
  let newWords: [String]
  required init (words: String){
    self.words = words
    
    //replace all non-chars/numbers/spaces with nothing, replace all groups of spaces with a single space, then break it up
    newWords = words.lowercaseString
      .stringByReplacingOccurrencesOfString("[^a-z0-9\\s]", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
      .stringByReplacingOccurrencesOfString("\\s\\s+", withString: " ", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
      .componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
  }
  
  func count() -> [String: Int]{
    var result: [String: Int] = [:]
    
    for word in newWords{

      //(result[word} ?? 0) == result[word] != nil? result[word]! : 0
      result[word] = (result[word] ?? 0) + 1
    }
    
    return result
  }
}