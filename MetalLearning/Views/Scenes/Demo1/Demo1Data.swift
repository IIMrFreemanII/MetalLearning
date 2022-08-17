//
//  Demo1Model.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 16.08.2022.
//

import Foundation
import MetalKit

class Demo1Data: ObservableObject {
  // the models to render
  lazy var house: Model = {
    Model(name: "lowpoly-house.obj")
  }()
  lazy var ground: Model = {
    var ground = Model(name: "plane.obj")
    ground.tiling = 16
    return ground
  }()
  
  var timer: Float = 0
  var uniforms = Uniforms()
  var params = Params()
  var clearColor = MTLClearColor(
    red: 0.93,
    green: 0.97,
    blue: 1.0,
    alpha: 1.0
  )
}

var demo1Data = Demo1Data()
