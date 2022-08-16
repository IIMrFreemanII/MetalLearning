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
    data.uniforms.viewMatrix = float4x4(translation: [0, 0, -3]).inverse
    
    data.model.position.y = -0.6
    data.model.rotation.y = sin(data.timer)
    data.uniforms.modelMatrix = data.model.transform.modelMatrix
    
    //      print("draw")
    renderEncoder.setDepthStencilState(Renderer.depthStencilState)
    renderEncoder.setRenderPipelineState(Renderer.pipelineState)
    renderEncoder.setVertexBytes(
      &data.uniforms,
      length: MemoryLayout<Uniforms>.stride,
      index: UniformsBuffer.index
    )
    renderEncoder.setFragmentBytes(
      &data.params,
      length: MemoryLayout<Params>.stride,
      index: ParamsBuffer.index
    )
//    renderEncoder.setTriangleFillMode(.lines)
    data.model.render(encoder: renderEncoder)
    
    renderEncoder.endEncoding()
    guard let drawable = view.currentDrawable else {
      return
    }
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
}
