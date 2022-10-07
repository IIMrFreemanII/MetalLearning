import MetalKit

struct Renderer {
  static var device: MTLDevice!
  static var commandQueue: MTLCommandQueue!
  static var library: MTLLibrary!
  static var colorPixelFormat: MTLPixelFormat!
  
//  static var pipelineState: MTLRenderPipelineState!
//  static var depthStencilState: MTLDepthStencilState!
  
  static func initialize() -> Void {
    guard
      let device = MTLCreateSystemDefaultDevice(),
      let commandQueue = device.makeCommandQueue() else {
      fatalError("GPU not available")
    }
    Self.device = device
    Self.commandQueue = commandQueue
    
    // create the shader function library
    Self.library = Self.device.makeDefaultLibrary()
    Self.colorPixelFormat = .bgra8Unorm
    
//    depthStencilState = buildDepthStencilState()
//    pipelineState = buildPipelineState()
  }
  
  // No need, now we use render passes
//  static func buildDepthStencilState() -> MTLDepthStencilState? {
//    let descriptor = MTLDepthStencilDescriptor()
//    descriptor.depthCompareFunction = .less
//    descriptor.isDepthWriteEnabled = true
//    return Renderer.device.makeDepthStencilState(
//      descriptor: descriptor)
//  }
//
//  static func buildPipelineState() -> MTLRenderPipelineState {
//    let vertexFunction = library?.makeFunction(name: "vertex_main")
//    let fragmentFunction = library?.makeFunction(name: "fragment_main")
//
//    // create the pipeline state object
//    let pipelineDescriptor = MTLRenderPipelineDescriptor()
//    pipelineDescriptor.vertexFunction = vertexFunction
//    pipelineDescriptor.fragmentFunction = fragmentFunction
//    pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
//    pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
//    pipelineDescriptor.vertexDescriptor = .defaultLayout
//
//    do {
//      return try Self.device.makeRenderPipelineState(
//        descriptor: pipelineDescriptor)
//    } catch let error {
//      fatalError(error.localizedDescription)
//    }
//  }
}

extension Renderer {
  static func draw(
    at encoder: MTLRenderCommandEncoder,
    model: Model,
    uniforms vertex: inout Uniforms,
    params fragment: inout Params
  ) {
    encoder.pushDebugGroup(model.name)
    
    encoder.setVertexBytes(
      &vertex,
      length: MemoryLayout<Uniforms>.stride,
      index: UniformsBuffer.index)
    
    fragment.tiling = model.tiling
    encoder.setFragmentBytes(
      &fragment,
      length: MemoryLayout<Params>.stride,
      index: ParamsBuffer.index)
    
    for mesh in model.meshes {
      for (index, vertexBuffer) in mesh.vertexBuffers.enumerated() {
        encoder.setVertexBuffer(
          vertexBuffer,
          offset: 0,
          index: index)
      }
      
      for submesh in mesh.submeshes {
//        if submesh.transparency != fragment.transparency { continue }
        // set the fragment texture here
        encoder.setFragmentTexture(
          submesh.textures.baseColor,
          index: BaseColor.index)
        encoder.setFragmentTexture(
          submesh.textures.normal,
          index: NormalTexture.index)
        encoder.setFragmentTexture(
          submesh.textures.roughness,
          index: RoughnessTexture.index)
        encoder.setFragmentTexture(
          submesh.textures.metallic,
          index: MetallicTexture.index)
        encoder.setFragmentTexture(
          submesh.textures.ambientOcclusion,
          index: AOTexture.index)
        encoder.setFragmentTexture(
          submesh.textures.opacity,
          index: OpacityTexture.index)
        
        var material = submesh.material
        encoder.setFragmentBytes(
          &material,
          length: MemoryLayout<Material>.stride,
          index: MaterialBuffer.index)
        encoder.drawIndexedPrimitives(
          type: .triangle,
          indexCount: submesh.indexCount,
          indexType: submesh.indexType,
          indexBuffer: submesh.indexBuffer,
          indexBufferOffset: submesh.indexBufferOffset
        )
      }
      
      encoder.popDebugGroup()
    }
  }
  
//  static func draw(
//    at encoder: MTLRenderCommandEncoder,
//    model: Model,
//    uniforms vertex: inout Uniforms,
//    params fragment: inout Params,
//    modelMatrices: [float4x4]
//  ) {
//    let modelMatricesBuffer = Renderer.device.makeBuffer(bytes: modelMatrices, length: MemoryLayout<float4x4>.stride * modelMatrices.count)
//    encoder.setVertexBuffer(modelMatricesBuffer, offset: 0, index: ModelMatrixBuffer.index)
//
//    encoder.setVertexBytes(
//      &vertex,
//      length: MemoryLayout<Uniforms>.stride,
//      index: UniformsBuffer.index)
//
//    encoder.setFragmentBytes(
//      &fragment,
//      length: MemoryLayout<Params>.stride,
//      index: ParamsBuffer.index)
//
//    for mesh in model.meshes {
//      for (index, vertexBuffer) in mesh.vertexBuffers.enumerated() {
//        encoder.setVertexBuffer(
//          vertexBuffer,
//          offset: 0,
//          index: index)
//      }
//
//      for submesh in mesh.submeshes {
//
//        // set the fragment texture here
//        encoder.setFragmentTexture(
//          submesh.textures.baseColor,
//          index: BaseColor.index)
//
//        encoder.drawIndexedPrimitives(
//          type: .triangle,
//          indexCount: submesh.indexCount,
//          indexType: submesh.indexType,
//          indexBuffer: submesh.indexBuffer,
//          indexBufferOffset: submesh.indexBufferOffset,
//          instanceCount: modelMatrices.count
//        )
//      }
//    }
//  }
}

// draw debug
extension Renderer {
  static let linePipelineState: MTLRenderPipelineState = {
    let library = Renderer.library
    let vertexFunction = library?.makeFunction(name: "vertex_debug")
    let fragmentFunction = library?.makeFunction(name: "fragment_debug_line")
    let psoDescriptor = MTLRenderPipelineDescriptor()
    psoDescriptor.vertexFunction = vertexFunction
    psoDescriptor.fragmentFunction = fragmentFunction
    psoDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    psoDescriptor.depthAttachmentPixelFormat = .depth32Float
    let pipelineState: MTLRenderPipelineState
    do {
      pipelineState = try Renderer.device.makeRenderPipelineState(descriptor: psoDescriptor)
    } catch let error {
      fatalError(error.localizedDescription)
    }
    return pipelineState
  }()
  
  static let pointPipelineState: MTLRenderPipelineState = {
    let library = Renderer.library
    let vertexFunction = library?.makeFunction(name: "vertex_debug")
    let fragmentFunction = library?.makeFunction(name: "fragment_debug_point")
    let psoDescriptor = MTLRenderPipelineDescriptor()
    psoDescriptor.vertexFunction = vertexFunction
    psoDescriptor.fragmentFunction = fragmentFunction
    psoDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    psoDescriptor.depthAttachmentPixelFormat = .depth32Float
    let pipelineState: MTLRenderPipelineState
    do {
      pipelineState = try Renderer.device.makeRenderPipelineState(
        descriptor: psoDescriptor
      )
    } catch let error {
      fatalError(error.localizedDescription)
    }
    return pipelineState
  }()
  
  static func drawPoint(
    at encoder: MTLRenderCommandEncoder,
    uniforms: Uniforms,
    position: float3,
    color: float3
  ) {
    var vertices = [position]
    encoder.setVertexBytes(&vertices, length: MemoryLayout<float3>.stride, index: 0)
    var uniforms = uniforms
    uniforms.modelMatrix = .identity
    encoder.setVertexBytes(
      &uniforms,
      length: MemoryLayout<Uniforms>.stride,
      index: UniformsBuffer.index)
    var lightColor = color
    encoder.setFragmentBytes(
      &lightColor,
      length: MemoryLayout<float3>.stride,
      index: 1)
    encoder.setRenderPipelineState(pointPipelineState)
    encoder.drawPrimitives(
      type: .point,
      vertexStart: 0,
      vertexCount: vertices.count)
  }

  static func drawLine(
    at renderEncoder: MTLRenderCommandEncoder,
    uniforms: Uniforms,
    position: float3,
    direction: float3,
    color: float3
  ) {
    var vertices: [float3] = []
    vertices.append(position)
    vertices.append(float3(
      position.x + direction.x,
      position.y + direction.y,
      position.z + direction.z))
    
    renderEncoder.setVertexBytes(&vertices, length: MemoryLayout<float3>.stride * vertices.count, index: 0)
    var lightColor = color
    renderEncoder.setFragmentBytes(&lightColor, length: MemoryLayout<float3>.stride, index: 1)
    
    var uniforms = uniforms
    uniforms.modelMatrix = .identity
    renderEncoder.setVertexBytes(
      &uniforms,
      length: MemoryLayout<Uniforms>.stride,
      index: UniformsBuffer.index
    )
    
    // render line
    renderEncoder.setRenderPipelineState(linePipelineState)
    renderEncoder.drawPrimitives(
      type: .line,
      vertexStart: 0,
      vertexCount: vertices.count)
    // render starting point
    renderEncoder.setRenderPipelineState(pointPipelineState)
    renderEncoder.drawPrimitives(
      type: .point,
      vertexStart: 0,
      vertexCount: 1)
  }
  
  static func drawLine(
    at renderEncoder: MTLRenderCommandEncoder,
    uniforms: Uniforms,
    from: float3,
    to: float3,
    color: float3
  ) {
    var vertices: [float3] = [from, to]
    renderEncoder.setVertexBytes(&vertices, length: MemoryLayout<float3>.stride * vertices.count, index: 0)
    var lightColor = color
    renderEncoder.setFragmentBytes(&lightColor, length: MemoryLayout<float3>.stride, index: 1)
    
    var uniforms = uniforms
    uniforms.modelMatrix = .identity
    renderEncoder.setVertexBytes(
      &uniforms,
      length: MemoryLayout<Uniforms>.stride,
      index: UniformsBuffer.index
    )
    
    // render line
    renderEncoder.setRenderPipelineState(linePipelineState)
    renderEncoder.drawPrimitives(
      type: .line,
      vertexStart: 0,
      vertexCount: vertices.count)
    
    // render starting point
    renderEncoder.setRenderPipelineState(pointPipelineState)
    renderEncoder.drawPrimitives(
      type: .point,
      vertexStart: 0,
      vertexCount: 1)
  }
}
