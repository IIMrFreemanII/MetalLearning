//
//  Demo1.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 14.08.2022.
//

import SwiftUI
import MetalKit
import Inject

struct Demo1: View {
  @ObserveInjection private var inject
  
  @State private var clearColor = MTLClearColor(
    red: 1.0,
    green: 1.0,
    blue: 0.8,
    alpha: 1.0
  )
  
  func draw(_ view: MTKView) -> Void {
    guard
      let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
      let descriptor = view.currentRenderPassDescriptor,
      let renderEncoder =
        commandBuffer.makeRenderCommandEncoder(
          descriptor: descriptor) else {
      print("failed to draw")
      return
    }
    
    view.clearColor = clearColor
    
    //      print("draw")
    
    renderEncoder.setRenderPipelineState(Renderer.pipelineState)
    renderEncoder.setVertexBuffer(Renderer.vertexBuffer, offset: 0, index: 0)
    for submesh in Renderer.mesh.submeshes {
      renderEncoder.drawIndexedPrimitives(
        type: .triangle,
        indexCount: submesh.indexCount,
        indexType: submesh.indexType,
        indexBuffer: submesh.indexBuffer.buffer,
        indexBufferOffset: submesh.indexBuffer.offset)
    }
    
    // 1
    renderEncoder.endEncoding()
    // 2
    guard let drawable = view.currentDrawable else {
      return
    }
    commandBuffer.present(drawable)
    // 3
    commandBuffer.commit()
  }
  
  func resize(_ view: MTKView, _ size: CGSize) -> Void {
    print("resize")
  }
  
  var body: some View {
    NavigationView {
      List {
        Section("Rendering") {
          Number3Field(label: "Clear color:", x: $clearColor.red, y: $clearColor.green, z: $clearColor.blue)
        }
        Section("Transform 2D") {
          VStack(spacing: 6) {
            Number2Field(label: "Position:", x: $clearColor.red, y: $clearColor.green)
            Number2Field(label: "Rotation:", x: $clearColor.red, y: $clearColor.green)
            Number2Field(label: "Scale:", x: $clearColor.red, y: $clearColor.green)
          }
        }
        Section("Transform 3D") {
          VStack(spacing: 6) {
            Number3Field(label: "Position:", x: $clearColor.red, y: $clearColor.green, z: $clearColor.blue)
            Number3Field(label: "Rotation:", x: $clearColor.red, y: $clearColor.green, z: $clearColor.blue)
            Number3Field(label: "Scale:", x: $clearColor.red, y: $clearColor.green, z: $clearColor.blue)
          }
        }
        Section("Transform 4D") {
          VStack(spacing: 6) {
            Number4Field(label: "Position:", x: $clearColor.red, y: $clearColor.green, z: $clearColor.blue, w: $clearColor.alpha)
            Number4Field(label: "Rotation:", x: $clearColor.red, y: $clearColor.green, z: $clearColor.blue, w: $clearColor.alpha)
            Number4Field(label: "Scale:", x: $clearColor.red, y: $clearColor.green, z: $clearColor.blue, w: $clearColor.alpha)
          }
        }
        Section("Matrices") {
          VStack(spacing: 6) {
            Number3x3Field(
              label: "Model 3x3",
              x1: $clearColor.red, y1: $clearColor.green, z1: $clearColor.blue,
              x2: $clearColor.red, y2: $clearColor.green, z2: $clearColor.blue,
              x3: $clearColor.red, y3: $clearColor.green, z3: $clearColor.blue
            )
            Number4x4Field(
              label: "Model 4x4",
              x1: $clearColor.red, y1: $clearColor.green, z1: $clearColor.blue, w1: $clearColor.alpha,
              x2: $clearColor.red, y2: $clearColor.green, z2: $clearColor.blue, w2: $clearColor.alpha,
              x3: $clearColor.red, y3: $clearColor.green, z3: $clearColor.blue, w3: $clearColor.alpha,
              x4: $clearColor.red, y4: $clearColor.green, z4: $clearColor.blue, w4: $clearColor.alpha
            )
          }
        }
      }
      .listStyle(.sidebar)
      .ignoresSafeArea()
      Text("Empty")
      MetalView(handleDraw: draw, handleResize: resize)
        .ignoresSafeArea()
    }
    .enableInjection()
  }
}

struct Demo1_Previews: PreviewProvider {
  static var previews: some View {
    Demo1()
  }
}
