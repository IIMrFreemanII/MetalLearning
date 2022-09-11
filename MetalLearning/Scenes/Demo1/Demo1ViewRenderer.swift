//
//  Demo1ViewRenderer.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 16.08.2022.
//

import MetalKit

class Demo1ViewRenderer : ViewRenderer {
  var camera = FPCamera()
  let lighting = SceneLighting()
  
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
  
  var lastTime: Double = CFAbsoluteTimeGetCurrent()
  
  var uniforms = Uniforms()
  var params = Params()
  
  override func initialize(metalView: MTKView) {
    super.initialize(metalView: metalView)
    
    camera.position = [0, 1.5, -5]
    
    metalView.depthStencilPixelFormat = .depth32Float
  }
  
  override func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    camera.update(size: size)
    params.width = UInt32(size.width)
    params.height = UInt32(size.height)
  }
  
  override func update(deltaTime: Float) {
    camera.update(deltaTime: deltaTime)
    
    for model in models {
      model.transform.rotation.y += 1 * deltaTime
    }
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
    
    let currentTime = CFAbsoluteTimeGetCurrent()
    let deltaTime = Float(currentTime - lastTime)
    lastTime = currentTime
    
    update(deltaTime: deltaTime)
    
    view.clearColor = clearColor
    
    renderEncoder.setDepthStencilState(Renderer.depthStencilState)
    renderEncoder.setRenderPipelineState(Renderer.pipelineState)
    
    var lights = lighting.lights
    renderEncoder.setFragmentBytes(
      &lights,
      length: MemoryLayout<Light>.stride * lights.count,
      index: LightBuffer.index)
    
    uniforms.viewMatrix = camera.viewMatrix
    uniforms.projectionMatrix = camera.projectionMatrix
    params.lightCount = UInt32(lighting.lights.count)
    params.cameraPosition = camera.position
    
    for model in models {
      uniforms.modelMatrix = model.transform.modelMatrix
      model.render(encoder: renderEncoder, uniforms: uniforms, params: params)
    }
    
    for light in lights {
      Renderer.drawPoint(encoder: renderEncoder, uniforms: uniforms, position: light.position, color: light.color)
    }
    
    renderEncoder.endEncoding()
    guard let drawable = view.currentDrawable else {
      return
    }
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
}
