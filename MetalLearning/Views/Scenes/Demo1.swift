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
  
  @State var model: Model = Model(device: Renderer.device, name: "train.usd")
  @State private var timer: Float = 0
  @State private var uniforms = Uniforms()
  @State private var params = Params()
  
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
    
    view.clearColor = MTLClearColor(
      red: 1.0,
      green: 1.0,
      blue: 0.8,
      alpha: 1.0
    )
    timer += 0.005
    uniforms.viewMatrix = float4x4(translation: [0, 0, -3]).inverse
    
    model.position.y = -0.6
    model.rotation.y = sin(timer)
    uniforms.modelMatrix = model.transform.modelMatrix
    
    //      print("draw")
    renderEncoder.setRenderPipelineState(Renderer.pipelineState)
    renderEncoder.setVertexBytes(
      &uniforms,
      length: MemoryLayout<Uniforms>.stride,
      index: 11
    )
    renderEncoder.setFragmentBytes(
      &params,
      length: MemoryLayout<Params>.stride,
      index: 12
    )
    model.render(encoder: renderEncoder)
    
    renderEncoder.endEncoding()
    guard let drawable = view.currentDrawable else {
      return
    }
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
  
  func resize(_ view: MTKView, _ size: CGSize) -> Void {
    print("resize")
    let aspect = Float(view.bounds.width) / Float(view.bounds.height)
    uniforms.projectionMatrix =
      float4x4(
        projectionFov: Float(70).degreesToRadians,
        near: 0.1,
        far: 100,
        aspect: aspect
      )
    params.width = UInt32(size.width)
    params.height = UInt32(size.height)
  }
  
  var body: some View {
    NavigationView {
      List {
        Section("Other") {
          Text("Temp")
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
