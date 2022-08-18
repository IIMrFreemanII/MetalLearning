import MetalKit

struct Renderer {
  static var device: MTLDevice!
  static var commandQueue: MTLCommandQueue!
  static var library: MTLLibrary!
  static var pipelineState: MTLRenderPipelineState!
  static var depthStencilState: MTLDepthStencilState!
  
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
    
    depthStencilState = buildDepthStencilState()
    pipelineState = buildPipelineState()
  }
  
  static func buildDepthStencilState() -> MTLDepthStencilState? {
    let descriptor = MTLDepthStencilDescriptor()
    descriptor.depthCompareFunction = .less
    descriptor.isDepthWriteEnabled = true
    return Renderer.device.makeDepthStencilState(
      descriptor: descriptor)
  }
  
  static func buildPipelineState() -> MTLRenderPipelineState {
    let vertexFunction = library?.makeFunction(name: "vertex_main")
    let fragmentFunction = library?.makeFunction(name: "fragment_main")
    
    // create the pipeline state object
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexFunction
    pipelineDescriptor.fragmentFunction = fragmentFunction
    pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
    pipelineDescriptor.vertexDescriptor = .defaultLayout
    
    do {
      return try Self.device.makeRenderPipelineState(
        descriptor: pipelineDescriptor)
    } catch let error {
      fatalError(error.localizedDescription)
    }
  }
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
    encoder: MTLRenderCommandEncoder,
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
    renderEncoder: MTLRenderCommandEncoder,
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
    renderEncoder: MTLRenderCommandEncoder,
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