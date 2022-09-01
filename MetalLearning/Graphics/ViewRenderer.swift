import MetalKit

class ViewRenderer: NSObject, ObservableObject {
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
