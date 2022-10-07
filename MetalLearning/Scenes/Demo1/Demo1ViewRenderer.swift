//
//  Demo1ViewRenderer.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 16.08.2022.
//

import MetalKit

class Demo1ViewRenderer : ViewRenderer {
  // render passes
  var forwardRenderPass: ForwardRenderPass!

  // scene data
  var players = PlayerEntities()
  var camera = FPCamera()
  let lighting = SceneLighting()
  
  // models
//  lazy var sphere: Model = {
//    Model(name: "sphere.obj")
//  }()
  lazy var sphere: Model = {
    Model(name: "toy_biplane.usdz")
  }()
  lazy var models: [Model] = [sphere]
  
  // -
  var clearColor = MTLClearColor(
    red: 0.93,
    green: 0.97,
    blue: 1.0,
    alpha: 1.0
  )
  
  // time
  var lastTime: Double = CFAbsoluteTimeGetCurrent()
  var deltaTime: Float!
  
  // uniforms and params
  var uniforms = Uniforms()
  var params = Params()
  
  override func initialize(metalView: MTKView) {
    super.initialize(metalView: metalView)
    
    forwardRenderPass = ForwardRenderPass(view: metalView)
    forwardRenderPass.lighting = lighting
    forwardRenderPass.players = players
    
    initScene()
    metalView.depthStencilPixelFormat = .depth32Float
  }
  
  func initScene() {
    //    for x in 0..<3 {
    //      for y in 0..<3 {
    //        for z in 0..<3 {
    //          let translation = Translation(value: [Float(x * 2), Float(y * 2), Float(z * 2)])
    //          players.create(translation: translation, model: sphere)
    //        }
    //      }
    //    }
    
    let translation = Translation(value: [0, 0, 0])
    players.create(translation: translation, scale: Scale(value: [0.1, 0.1, 0.1]),  model: sphere)
    
    camera.position = [0, 1.5, -5]
  }
  
  override func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    camera.update(size: size)
    params.width = UInt32(size.width)
    params.height = UInt32(size.height)
  }
  
  override func update(deltaTime: Float) {
    camera.update(deltaTime: deltaTime)
  }
  
  func updateUniforms() {
    metalView.clearColor = clearColor
    
    uniforms.viewMatrix = camera.viewMatrix
    uniforms.projectionMatrix = camera.projectionMatrix
    
    params.cameraPosition = camera.position
  }
  
  func updateTime() {
    let currentTime = CFAbsoluteTimeGetCurrent()
    deltaTime = Float(currentTime - lastTime)
    lastTime = currentTime
  }
  
  override func draw(in view: MTKView) {
    guard
      let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
      let descriptor = view.currentRenderPassDescriptor else {
        print("failed to draw")
      return
    }
    
    updateTime()
    update(deltaTime: deltaTime)
    updateUniforms()
    
    forwardRenderPass.descriptor = descriptor
    forwardRenderPass.draw(
      commandBuffer: commandBuffer,
      uniforms: uniforms,
      params: params
    )
    
//    players.forEach { (trans, rot, s, model) in
//      uniforms.modelMatrix = modelFrom(trans: trans.value, rot: rot.value, scale: s.value)
//      uniforms.normalMatrix = uniforms.modelMatrix.upperLeft
//      params.tiling = model.tiling
//      Renderer.draw(at: renderEncoder, model: model, uniforms: &uniforms, params: &params)
//    }
//    params.tiling = sphere.tiling
//    Renderer.draw(at: renderEncoder, model: sphere, uniforms: &uniforms[currentUniformIndex], params: &params, modelMatrices: players.modelMatrices)
//    Renderer.draw(at: renderEncoder, model: sphere, uniforms: &uniforms, params: &params, modelMatrices: players.modelMatrices)

    //    for light in lights {
//      Renderer.drawPoint(at: renderEncoder, uniforms: uniforms, position: light.position, color: light.color)
//    }
    
    guard let drawable = view.currentDrawable else {
      return
    }
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
}
