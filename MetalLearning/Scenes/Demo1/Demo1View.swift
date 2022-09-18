//
//  Demo1.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 16.08.2022.
//

import SwiftUI
import Inject

struct Demo1View: View {
  @ObserveInjection private var inject
  @ObservedObject private var scene = Demo1ViewRenderer()
  
  var body: some View {
    print("update")
    return NavigationView {
      List {
        Section("Data") {
          ColorPicker(
            "Clear color",
            selection:
              Binding(
                get: { Color(red: scene.clearColor.red, green: scene.clearColor.green, blue: scene.clearColor.blue, opacity: scene.clearColor.alpha)},
                set: {
                  scene.clearColor = MTLClearColor(
                    red: Double($0.cgColor?.components?[0] ?? 0),
                    green: Double($0.cgColor?.components?[1] ?? 0),
                    blue: Double($0.cgColor?.components?[2] ?? 0),
                    alpha: Double($0.cgColor?.components?[0] ?? 0)
                  )
                }
              )
          )
//          Number4x4Field(
//            label: "Model matrix",
//            matrix: $scene.uniforms.modelMatrix
//          )
//          Number3Field(label: "Position", value: $scene.sphere.position)
//          Number3Field(label: "Rotation", value: $scene.sphere.rotation)
//          Number1Field(label: "Scale", value: $scene.sphere.scale)
        }
      }
      .listStyle(.sidebar)
      .ignoresSafeArea()
      Text("Empty")
      MetalView(viewRenderer: scene)
        .ignoresSafeArea()
    }
    .enableInjection()
  }
}

struct Demo1_Previews: PreviewProvider {
  static var previews: some View {
    Demo1View()
  }
}
