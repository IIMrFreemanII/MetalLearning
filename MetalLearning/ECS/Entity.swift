import Foundation

class PlayerEntities {
  var translations = [Translation]()
  var rotations = [Rotation]()
  var scales = [Scale]()
  var modelMatrices = [float4x4]()
  var models = [Model]()
  
  func create(translation: Translation = Translation(), rotation: Rotation = Rotation(), scale: Scale = Scale(), model: Model) {
    translations.append(translation)
    rotations.append(rotation)
    scales.append(scale)
    modelMatrices.append(modelFrom(trans: translation.value, rot: rotation.value, scale: scale.value))
    models.append(model)
  }
  
  func remove(at index: Int) {
    translations.remove(at: index)
    rotations.remove(at: index)
    scales.remove(at: index)
    models.remove(at: index)
  }
  
  func forEach(callback: (_ translation: inout Translation , _ rotation: inout Rotation, _ scale: inout Scale, _ model: Model) -> Void) {
    let translations = translations.withUnsafeMutableBufferPointer { $0 }
    let rotations = rotations.withUnsafeMutableBufferPointer { $0 }
    let scales = scales.withUnsafeMutableBufferPointer { $0 }
    let models = models.withUnsafeBufferPointer { $0 }
    
    for i in translations.indices {
      callback(&translations[i], &rotations[i], &scales[i], models[i])
    }
  }
}
