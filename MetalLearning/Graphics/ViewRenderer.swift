import MetalKit

typealias DrawCallback = ((MTKView) -> Void)
typealias ResizeCallback = ((MTKView, CGSize) -> Void)

class ViewRenderer: NSObject {
  var metalView: MTKView
  var handleDraw: DrawCallback?
  var handleResize: ResizeCallback?
  
  init(metalView: MTKView, handleDraw: DrawCallback?, handleResize: ResizeCallback?) {
    self.metalView = metalView
    self.handleDraw = handleDraw
    self.handleResize = handleResize
    
    super.init()
    
    metalView.device = Renderer.device
    metalView.delegate = self
  }
}

extension ViewRenderer: MTKViewDelegate {
  func mtkView(
    _ view: MTKView,
    drawableSizeWillChange size: CGSize
  ) {
    handleResize?(view, size)
  }
  
  func draw(in view: MTKView) {
    handleDraw?(view)
  }
}
