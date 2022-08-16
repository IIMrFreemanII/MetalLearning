//
//  Demo1Model.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 16.08.2022.
//

import Foundation
import MetalKit

class Demo1Data: ObservableObject {
  lazy var model: Model = Model(device: Renderer.device, name: "train.usd")
  var timer: Float = 0
  var uniforms = Uniforms()
  var params = Params()
  var clearColor = MTLClearColor(
    red: 0.8,
    green: 0.8,
    blue: 0.8,
    alpha: 1.0
  )
}

var demo1Data = Demo1Data()
