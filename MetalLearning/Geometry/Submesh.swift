import MetalKit

struct Submesh {
  let indexCount: Int
  let indexType: MTLIndexType
  let indexBuffer: MTLBuffer
  let indexBufferOffset: Int

  struct Textures {
    let baseColor: MTLTexture?
    let normal: MTLTexture?
    let roughness: MTLTexture?
    let metallic: MTLTexture?
    let ambientOcclusion: MTLTexture?
    let opacity: MTLTexture?
  }

  let textures: Textures
  let material: Material
  var transparency: Bool {
    textures.opacity != nil || material.opacity < 1.0
  }
}

extension Submesh {
  init(mdlSubmesh: MDLSubmesh, mtkSubmesh: MTKSubmesh) {
    indexCount = mtkSubmesh.indexCount
    indexType = mtkSubmesh.indexType
    indexBuffer = mtkSubmesh.indexBuffer.buffer
    indexBufferOffset = mtkSubmesh.indexBuffer.offset
    textures = Textures(material: mdlSubmesh.material)
    material = Material(material: mdlSubmesh.material)
    
    print(
    """
    Material {
      baseColor: \(material.baseColor)
      specularColor: \(material.specularColor)
      roughness: \(material.roughness)
      metallic: \(material.metallic)
      ambientOcclusion: \(material.ambientOcclusion)
      shininess: \(material.shininess)
      opacity: \(material.opacity)
    }
    """
    )
    print(
    """
    Textures {
      baseColor: \(textures.baseColor != nil ? true : false)
      normal: \(textures.normal != nil ? true : false)
      roughness: \(textures.roughness != nil ? true : false)
      metallic: \(textures.metallic != nil ? true : false)
      ambientOcclusion: \(textures.ambientOcclusion != nil ? true : false)
      opacity: \(textures.opacity != nil ? true : false)
    }
    """
    )
  }
}

private extension Submesh.Textures {
  init(material: MDLMaterial?) {
    func property(with semantic: MDLMaterialSemantic) -> MTLTexture? {
      guard
        let property = material?.property(with: semantic),
        property.type == .string,
        let filename = property.stringValue,
        let texture = TextureController.texture(filename: filename)
      else {
        if let property = material?.property(with: semantic),
           property.type == .texture,
           let mdlTexture = property.textureSamplerValue?.texture {
          print(property.name)
          return try? TextureController.loadTexture(texture: mdlTexture)
        }
        return nil
      }
      return texture
    }
    
    baseColor = property(with: MDLMaterialSemantic.baseColor)
    normal = property(with: .tangentSpaceNormal)
    roughness = property(with: .roughness)
    metallic = property(with: .metallic)
    ambientOcclusion = property(with: .ambientOcclusion)
    opacity = property(with: .opacity)
  }
}

private extension Material {
  init(material: MDLMaterial?) {
    self.init()
    baseColor = [1, 1, 1]
    if let baseColor = material?.property(with: .baseColor),
      baseColor.type == .float3 {
      self.baseColor = baseColor.float3Value
    }
    specularColor = [1, 1, 1]
    if let specular = material?.property(with: .specular),
      specular.type == .float3 {
      self.specularColor = specular.float3Value
    }
    shininess = 0
    if let shininess = material?.property(with: .specularExponent),
      shininess.type == .float {
      self.shininess = shininess.floatValue
    }
    roughness = 1
    if let roughness = material?.property(with: .roughness),
      roughness.type == .float3 {
      self.roughness = roughness.floatValue
    }
    metallic = 0
    if let metallic = material?.property(with: .metallic),
      metallic.type == .float3 {
      self.metallic = metallic.floatValue
    }
    ambientOcclusion = 1.0
    if let ambientOcclusion = material?.property(with: .ambientOcclusion),
      ambientOcclusion.type == .float3 {
      self.ambientOcclusion = ambientOcclusion.floatValue
    }
    opacity = 1.0
    if let opacity = material?.property(with: .opacity),
      opacity.type == .float {
      self.opacity = opacity.floatValue
    }
  }
}
