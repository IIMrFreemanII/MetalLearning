//
//  Demo1ViewRenderer.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 16.08.2022.
//

import MetalKit

class Demo1ViewRenderer : ViewRenderer {
  private var scene = demo1Scene
  
  var lastTime: Double = CFAbsoluteTimeGetCurrent()
  
  var uniforms = Uniforms()
  var params = Params()
  
  required init(metalView: MTKView) {
    super.init(metalView: metalView)
    
    metalView.depthStencilPixelFormat = .depth32Float
  }
  
  override func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    scene.update(size: size)
    params.width = UInt32(size.width)
    params.height = UInt32(size.height)
  }
  
  override func draw(in view: MTKView) {
    guard
      let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
      let descriptor = view.currentRenderPassDescriptor,
      let renderEncoder =
        commandBuffer.makeRenderCommandEncoder(
          descriptor: descriptor) else {
      print("failed to draw")
      return
    }
    
    view.clearColor = scene.clearColor
    
    renderEncoder.setDepthStencilState(Renderer.depthStencilState)
    renderEncoder.setRenderPipelineState(Renderer.pipelineState)
    
    let currentTime = CFAbsoluteTimeGetCurrent()
    let deltaTime = Float(currentTime - lastTime)
    lastTime = currentTime
    
    scene.update(deltaTime: deltaTime)
    uniforms.viewMatrix = scene.camera.viewMatrix
    uniforms.projectionMatrix = scene.camera.projectionMatrix
    for model in scene.models {
      model.render(encoder: renderEncoder, uniforms: uniforms, params: params)
    }
    
    renderEncoder.endEncoding()
    guard let drawable = view.currentDrawable else {
      return
    }
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
}
