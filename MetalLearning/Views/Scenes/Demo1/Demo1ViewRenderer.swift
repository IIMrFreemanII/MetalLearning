//
//  Demo1ViewRenderer.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 16.08.2022.
//

import MetalKit

class Demo1ViewRenderer : ViewRenderer {
  private var data = demo1Data
  
  required init(metalView: MTKView) {
    super.init(metalView: metalView)
    
    metalView.depthStencilPixelFormat = .depth32Float
  }
  
  override func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    print("resize")
    let aspect = Float(view.bounds.width) / Float(view.bounds.height)
    data.uniforms.projectionMatrix =
      float4x4(
        projectionFov: Float(70).degreesToRadians,
        near: 0.1,
        far: 100,
        aspect: aspect
      )
    data.params.width = UInt32(size.width)
    data.params.height = UInt32(size.height)
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
    
    view.clearColor = data.clearColor
    data.timer += 0.005
    data.uniforms.viewMatrix = float4x4(translation: [0, 1.5, -5]).inverse
    
    renderEncoder.setDepthStencilState(Renderer.depthStencilState)
    renderEncoder.setRenderPipelineState(Renderer.pipelineState)
    
    data.house.rotation.y = sin(data.timer)
    data.house.render(encoder: renderEncoder, uniforms: data.uniforms, params: data.params)

    data.ground.scale = 40
    data.ground.rotation.y = sin(data.timer)
    data.ground.render(
      encoder: renderEncoder,
      uniforms: data.uniforms,
      params: data.params)
    
    renderEncoder.endEncoding()
    guard let drawable = view.currentDrawable else {
      return
    }
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
}
