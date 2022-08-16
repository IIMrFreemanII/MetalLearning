//
//  Demo1ViewRenderer.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 16.08.2022.
//

import MetalKit

class Demo1ViewRenderer : ViewRenderer {
  lazy var model: Model = Model(device: Renderer.device, name: "train.usd")
  private var timer: Float = 0
  private var uniforms = Uniforms()
  private var params = Params()
  private var clearColor = MTLClearColor(
    red: 0.8,
    green: 0.8,
    blue: 0.8,
    alpha: 1.0
  )
  
  required init(metalView: MTKView) {
    super.init(metalView: metalView)
  }
  
  override func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
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
    
    view.clearColor = clearColor
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
    renderEncoder.setTriangleFillMode(.lines)
    model.render(encoder: renderEncoder)
    
    renderEncoder.endEncoding()
    guard let drawable = view.currentDrawable else {
      return
    }
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
}
