//
//  Leap.swift
//  Exercism
//
//  Created by Villalobos, Benjamin on 7/22/16.
//  Copyright © 2016 Villalobos, Benjamin. All rights reserved.
//

import Foundation

class Year {
  let isLeapYear: Bool
  required init (calendarYear: Int) {
    isLeapYear = calendarYear % 400 == 0 || (calendarYear % 4 == 0 && calendarYear % 100 != 0)
  }
}