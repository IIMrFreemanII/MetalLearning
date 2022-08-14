//
//  Formatter.swift
//  MotionCanvas
//
//  Created by Nikolay Diahovets on 07.08.2022.
//

import Foundation

let decimalFormatter: NumberFormatter = {
  var temp = NumberFormatter()
  temp.numberStyle = .decimal
  temp.decimalSeparator = "."
  temp.groupingSeparator = ""
  return temp
}()

let intFormatter: NumberFormatter = {
  var temp = NumberFormatter()
  return temp
}()
