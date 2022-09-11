import MetalKit
import GameController

class ViewRenderer: NSObject, ObservableObject {
  override init() {
    super.init()
    
    let center = NotificationCenter.default
    center.addObserver(
      forName: .GCKeyboardDidConnect,
      object: nil,
      queue: nil
    ) { notification in
      let keyboard = notification.object as? GCKeyboard
      keyboard?.keyboardInput?.keyChangedHandler = { _, _, keyCode, pressed in
        if keyCode == .keyR && pressed {
          self.objectWillChange.send()
          print("reload")
        }
      }
    }
  }
  
  func initialize(metalView: MTKView) {
    metalView.device = Renderer.device
    metalView.delegate = self
    
    mtkView(
      metalView,
      drawableSizeWillChange: metalView.drawableSize
    )
  }
  
  func update(deltaTime: Float) {}
}

extension ViewRenderer: MTKViewDelegate {
  func mtkView(
    _ view: MTKView,
    drawableSizeWillChange size: CGSize
  ) {
    
  }
  
  func draw(in view: MTKView) {
    
  }
}
