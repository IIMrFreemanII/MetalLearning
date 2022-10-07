protocol System {
  func onCreate() -> Void
  func onUpdate() -> Void
}

class RenderSystem: System {
  func onCreate() {
    print("create")
  }
  
  func onUpdate() {
    print("update")
  }
}
