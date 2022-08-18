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
  @State private var scene = demo1Scene
  
  var body: some View {
    NavigationView {
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
        }
      }
      .listStyle(.sidebar)
      .ignoresSafeArea()
      Text("Empty")
      MetalView(viewRendererType: Demo1ViewRenderer.self)
        .ignoresSafeArea()
    }
    .enableInjection()
//    .keyboardShortcut()
  }
}

struct Demo1_Previews: PreviewProvider {
  static var previews: some View {
    Demo1View()
  }
}
