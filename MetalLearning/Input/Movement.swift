//
//  Movement.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 17.08.2022.
//

import Foundation

enum Settings {
  static var rotationSpeed: Float { 0.1 }
  static var translationSpeed: Float { 5.0 }
  static var mouseScrollSensitivity: Float { 0.1 }
  static var mousePanSensitivity: Float { 0.008 }
}

protocol Movement where Self: Transformable {}

extension Movement {
  var forward: float3 {
    float4x4(rotationYXZ: rotation).upperLeft * float3.forward
  }
  
  var right: float3 {
    float4x4(rotationYXZ: rotation).upperLeft * float3.right
  }
  
  var up: float3 {
    float4x4(rotationYXZ: rotation).upperLeft * float3.up
  }
  
  mutating func updateMovement(deltaTime: Float) {
    let input = InputController.shared
    
    if input.rightMouseDown {
      // handle rotation
      let rotationSpeed = deltaTime * Settings.rotationSpeed
      rotation.x += -input.mouseDelta.y * rotationSpeed
      rotation.y += input.mouseDelta.x * rotationSpeed
      //
      
      // handle translation
      var direction: float3 = .zero
      if input.keysPressed.contains(.keyW) {
        direction.z += 1
      }
      if input.keysPressed.contains(.keyS) {
        direction.z -= 1
      }
      if input.keysPressed.contains(.keyA) {
        direction.x -= 1
      }
      if input.keysPressed.contains(.keyD) {
        direction.x += 1
      }
      if input.keysPressed.contains(.keyQ) {
        direction.y += 1
      }
      if input.keysPressed.contains(.keyE) {
        direction.y -= 1
      }
      
      let currentRotationMatrix = float4x4(rotationYXZ: rotation)
      if direction != .zero {
        let translationSpeed = deltaTime * Settings.translationSpeed
        
        let translation = currentRotationMatrix.upperLeft * normalize(direction) * translationSpeed
        position += translation
      }
      //
    }
    
    input.mouseDelta = .zero
  }
}
