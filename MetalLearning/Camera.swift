//
//  Camera.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 17.08.2022.
//

import Foundation

protocol Camera: Transformable {
  var projectionMatrix: float4x4 { get }
  var viewMatrix: float4x4 { get }
  mutating func update(size: CGSize)
  mutating func update(deltaTime: Float)
}

struct FPCamera: Camera {
  var transform = Transform()
  
  var aspect: Float = 1.0
  var fov = Float(70).degreesToRadians
  var near: Float = 0.1
  var far: Float = 100
  var projectionMatrix: float4x4 {
    float4x4(
      projectionFov: fov,
      near: near,
      far: far,
      aspect: aspect)
  }
  
  var viewMatrix: float4x4 {
    let position = float4x4(translation: position)
    let rotation = float4x4(rotationYXZ: rotation)
    return (position * rotation).inverse
  }
  
  mutating func update(size: CGSize) {
    aspect = Float(size.width / size.height)
  }
  
  mutating func update(deltaTime: Float) {
    updateMovement(deltaTime: deltaTime)
  }
}

extension FPCamera: Movement { }
