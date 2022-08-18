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
  let lighting = SceneLighting()
  
  init() {
    camera.position = [0, 1.5, -5]
  }
  
  lazy var sphere: Model = {
    Model(name: "sphere.obj")
  }()
  lazy var models: [Model] = [sphere]
  
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
    
    for model in models {
      model.transform.rotation.y += 1 * deltaTime
    }
  }
}

var demo1Scene = Demo1Scene()
