import MetalKit

class Model {
  let meshes: [Mesh]
  let name: String
  var tiling: UInt32 = 1
  let hasTransparency: Bool

  init(name: String) {
    guard let assetURL = Bundle.main.url(
      forResource: name,
      withExtension: nil) else {
      fatalError("Model: \(name) not found")
    }
    let allocator = MTKMeshBufferAllocator(device: Renderer.device)
    let meshDescriptor = MDLVertexDescriptor.defaultLayout
    let asset = MDLAsset(
      url: assetURL,
      vertexDescriptor: meshDescriptor,
      bufferAllocator: allocator)
    asset.loadTextures()
    var mtkMeshes: [MTKMesh] = []
    let mdlMeshes =
      asset.childObjects(of: MDLMesh.self) as? [MDLMesh] ?? []
    _ = mdlMeshes.map { mdlMesh in
      mdlMesh.addTangentBasis(
        forTextureCoordinateAttributeNamed:
          MDLVertexAttributeTextureCoordinate,
        tangentAttributeNamed: MDLVertexAttributeTangent,
        bitangentAttributeNamed: MDLVertexAttributeBitangent)
      mtkMeshes.append(
        try! MTKMesh(
          mesh: mdlMesh,
          device: Renderer.device
        )
      )
    }
    meshes = zip(mdlMeshes, mtkMeshes).map {
      Mesh(mdlMesh: $0.0,mtkMesh: $0.1)
    }
    self.name = name
    hasTransparency = meshes.contains { mesh in
      mesh.submeshes.contains { $0.transparency }
    }
  }
}

// Rendering
//extension Model {
//
//  func render(
//    encoder: MTLRenderCommandEncoder,
//    uniforms vertex: Uniforms,
//    params fragment: Params
//  ) {
//    var uniforms = vertex
////    uniforms.modelMatrix = transform.modelMatrix
////    uniforms.normalMatrix = uniforms.modelMatrix.upperLeft
//
//    var params = fragment
//    params.tiling = tiling
//
//    encoder.setVertexBytes(
//      &uniforms,
//      length: MemoryLayout<Uniforms>.stride,
//      index: UniformsBuffer.index)
//
//    encoder.setFragmentBytes(
//      &params,
//      length: MemoryLayout<Params>.stride,
//      index: ParamsBuffer.index)
//
//    for mesh in meshes {
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
//          indexBufferOffset: submesh.indexBufferOffset
//        )
//      }
//    }
//  }
//}
