import MetalKit

class ViewRenderer: NSObject {
  required init(metalView: MTKView) {
    super.init()
    
    metalView.device = Renderer.device
    metalView.delegate = self
    
    mtkView(
      metalView,
      drawableSizeWillChange: metalView.drawableSize
    )
  }
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
