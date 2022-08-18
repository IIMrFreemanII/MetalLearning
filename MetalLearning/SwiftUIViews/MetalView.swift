import SwiftUI
import MetalKit
import Inject

struct MetalView: View {
  @ObserveInjection private var inject
  
  @State private var metalView = MTKView()
  @State private var viewRenderer: ViewRenderer?
  var viewRendererType: ViewRenderer.Type
  
  var body: some View {
    MetalViewRepresentable(metalView: $metalView)
      .onAppear {
        viewRenderer = viewRendererType.init(
          metalView: metalView
        )
      }
      .onReceive(inject.observer.objectWillChange) {
        viewRenderer = viewRendererType.init(
          metalView: metalView
        )
      }
      .enableInjection()
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
    print("makeMetalView")
    return metalView
  }
  func updateNSView(_ uiView: NSViewType, context: Context) {
    updateMetalView()
  }
#elseif os(iOS)
  func makeUIView(context: Context) -> MTKView {
    print("makeMetalView")
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

//struct MetalView_Previews: PreviewProvider {
//  static var previews: some View {
//    VStack {
//      MetalView()
//      Text("Metal View")
//    }
//  }
//}
