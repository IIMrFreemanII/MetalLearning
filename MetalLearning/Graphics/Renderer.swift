import MetalKit

struct Renderer {
  static var device: MTLDevice!
  static var commandQueue: MTLCommandQueue!
  static var library: MTLLibrary!
  static var mesh: MTKMesh!
  static var vertexBuffer: MTLBuffer!
  static var pipelineState: MTLRenderPipelineState!
  
  static func initialize() -> Void {
    guard
      let device = MTLCreateSystemDefaultDevice(),
      let commandQueue = device.makeCommandQueue() else {
      fatalError("GPU not available")
    }
    Self.device = device
    Self.commandQueue = commandQueue
    
    // create the mesh
    let allocator = MTKMeshBufferAllocator(device: Self.device)
    let size: Float = 0.8
    let mdlMesh = MDLMesh(
      boxWithExtent: [size, size, size],
      segments: [1, 1, 1],
      inwardNormals: false,
      geometryType: .triangles,
      allocator: allocator
    )
    do {
      Self.mesh = try MTKMesh(mesh: mdlMesh, device: Self.device)
    } catch let error {
      print(error.localizedDescription)
    }
    Self.vertexBuffer = Self.mesh.vertexBuffers[0].buffer
    
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
    pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mdlMesh.vertexDescriptor)
    do {
      Self.pipelineState =
      try Self.device.makeRenderPipelineState(
        descriptor: pipelineDescriptor)
    } catch let error {
      fatalError(error.localizedDescription)
    }
  }
}
