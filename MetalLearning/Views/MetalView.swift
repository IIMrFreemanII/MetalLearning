import SwiftUI
import MetalKit

struct MetalView: View {
  @State private var metalView = MTKView()
  @State private var renderer: ViewRenderer?
  
  var handleDraw: DrawCallback?
  var handleResize: ResizeCallback?
  
  var body: some View {
    renderer?.handleDraw = handleDraw
    renderer?.handleResize = handleResize
    
    return MetalViewRepresentable(metalView: $metalView)
      .onAppear {
        renderer = ViewRenderer(
          metalView: metalView,
          handleDraw: handleDraw,
          handleResize: handleResize
        )
      }
  }
}

#if os(macOS)
typealias ViewRepresentable = NSViewRepresentable
#elseif os(iOS)
typealias ViewRepresentable = UIViewRepresentable
#endif

struct MetalViewRepresentable: ViewRepresentable {
  @Binding var metalView: MTKView
  
#if os(macOS)
  func makeNSView(context: Context) -> some NSView {
    return metalView
  }
  func updateNSView(_ uiView: NSViewType, context: Context) {
    updateMetalView()
  }
#elseif os(iOS)
  func makeUIView(context: Context) -> MTKView {
    return metalView
  }
  
  func updateUIView(_ uiView: MTKView, context: Context) {
    updateMetalView()
  }
#endif
  
  func updateMetalView() {
    print("updateMetalView")
  }
}

struct MetalView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      MetalView()
      Text("Metal View")
    }
  }
}
