import MetalKit

struct Renderer {
  static var device: MTLDevice!
  static var commandQueue: MTLCommandQueue!
  static var library: MTLLibrary!
  static var pipelineState: MTLRenderPipelineState!
  
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
    let vertexFunction = Self.library?.makeFunction(name: "vertex_main")
    let fragmentFunction =
    Self.library?.makeFunction(name: "fragment_main")
    
    // create the pipeline state object
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexFunction
    pipelineDescriptor.fragmentFunction = fragmentFunction
    pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    pipelineDescriptor.vertexDescriptor = .defaultLayout
    
    do {
      Self.pipelineState =
      try Self.device.makeRenderPipelineState(
        descriptor: pipelineDescriptor)
    } catch let error {
      fatalError(error.localizedDescription)
    }
  }
}
