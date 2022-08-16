//
//  Demo1.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 16.08.2022.
//

import SwiftUI
import Inject

struct Demo1: View {
  @ObserveInjection private var inject
  @State private var data = demo1Data
  
  var body: some View {
    NavigationView {
      List {
        Section("Data") {
          ColorPicker(
            "Clear color",
            selection:
              Binding(
                get: { Color(red: data.clearColor.red, green: data.clearColor.green, blue: data.clearColor.blue, opacity: data.clearColor.alpha)},
                set: {
                  data.clearColor = MTLClearColor(
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
  }
}

struct Demo1_Previews: PreviewProvider {
  static var previews: some View {
    Demo1()
  }
}
