protocol Component {}

struct Translation: Component {
  var value: float3 = float3()
}

struct Rotation: Component {
  var value: float3 = float3()
}

struct Scale: Component {
  var value: float3 = float3(x: 1, y: 1, z: 1)
}

struct ModelComponent: Component {
  var value: Model? = nil
}
