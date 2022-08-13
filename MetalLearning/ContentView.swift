//
//  ContentView.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 13.08.2022.
//

import SwiftUI
import MetalKit

struct ContentView: View {
  @State private var clearColor = MTLClearColor(
    red: 1.0,
    green: 1.0,
    blue: 0.8,
    alpha: 1.0
  )
  
  func draw(_ view: MTKView) -> Void {
    guard
      let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
      let descriptor = view.currentRenderPassDescriptor,
      let renderEncoder =
        commandBuffer.makeRenderCommandEncoder(
          descriptor: descriptor) else {
      print("failed to draw")
      return
    }
    
    view.clearColor = clearColor
//      print("draw")
    
    renderEncoder.setRenderPipelineState(Renderer.pipelineState)
    renderEncoder.setVertexBuffer(Renderer.vertexBuffer, offset: 0, index: 0)
    for submesh in Renderer.mesh.submeshes {
      renderEncoder.drawIndexedPrimitives(
        type: .triangle,
        indexCount: submesh.indexCount,
        indexType: submesh.indexType,
        indexBuffer: submesh.indexBuffer.buffer,
        indexBufferOffset: submesh.indexBuffer.offset)
    }
    
    // 1
    renderEncoder.endEncoding()
    // 2
    guard let drawable = view.currentDrawable else {
      return
    }
    commandBuffer.present(drawable)
    // 3
    commandBuffer.commit()
  }
  
  func resize(_ view: MTKView, _ size: CGSize) -> Void {
    print("resize")
  }
  
  var body: some View {
    MetalView(handleDraw: draw, handleResize: resize)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
