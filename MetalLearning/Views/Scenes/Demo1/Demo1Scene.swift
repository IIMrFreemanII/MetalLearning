//
//  Demo1Model.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 16.08.2022.
//

import Foundation
import MetalKit

class Demo1Scene: ObservableObject {
  var camera = FPCamera()
  
  init() {
    camera.position = [0, 1.5, -5]
  }
  
  lazy var house: Model = {
    Model(name: "lowpoly-house.obj")
  }()
  lazy var ground: Model = {
    var ground = Model(name: "plane.obj")
    ground.scale = 40
    ground.tiling = 16
    return ground
  }()
  lazy var models: [Model] = [ground, house]
  
  var clearColor = MTLClearColor(
    red: 0.93,
    green: 0.97,
    blue: 1.0,
    alpha: 1.0
  )
  
  func update(size: CGSize) {
    camera.update(size: size)
  }
  
  func update(deltaTime: Float) {
    camera.update(deltaTime: deltaTime)
  }
}

var demo1Scene = Demo1Scene()
