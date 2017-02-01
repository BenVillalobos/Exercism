//
//  GradeSchool.swift
//  Exercism
//
//  Created by Villalobos, Benjamin on 8/5/16.
//  Copyright © 2016 Villalobos, Benjamin. All rights reserved.
//

import Foundation

class GradeSchool {
  var roster = [Int: [String]]()
  
  var sortedRoster: [Int: [String]] {
    for key in roster.keys {
      roster[key] = roster[key]?.sort(<)
      }
    return roster
  }

  func addStudent(name: String, grade: Int) {
    roster[grade] = studentsInGrade(grade) + [name]
  }
  
  
  func studentsInGrade(grade: Int) -> [String] {
    return (roster[grade] ?? [])
  }
  

}