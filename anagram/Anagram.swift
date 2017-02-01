//
//  Anagram.swift
//  Exercism
//
//  Created by Villalobos, Benjamin on 7/26/16.
//  Copyright © 2016 Villalobos, Benjamin. All rights reserved.
//

import Foundation

class Anagram {
  let word: String
  
  init(word: String) {
    self.word = word.lowercaseString
  }
  
  func match(words: [String]) -> [String]{
    
    let lowercaseWord = word.lowercaseString
    let lowercaseSortedWord = word.characters.sort()
    
    
    return words.filter { anagram in
      let lowercaseAnagram = anagram.lowercaseString
      
      return lowercaseAnagram != lowercaseWord && lowercaseAnagram.characters.sort() == lowercaseSortedWord
    }
  }
}