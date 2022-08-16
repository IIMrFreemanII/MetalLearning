//
//  ContentView.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 13.08.2022.
//

import SwiftUI
import MetalKit
import Inject

struct ContentView: View {
  @ObserveInjection private var inject
  
  let renderers: [ViewRenderer.Type] = [Demo1ViewRenderer.self]
  
  var body: some View {
    NavigationView {
      List {
        Section("Scenes") {
          ForEach(renderers.indices, id: \.self) { i in
            let name = "\(renderers[i])"
            NavigationLink(name, destination: MetalView(viewRendererType: renderers[i]).ignoresSafeArea())
          }
        }
      }
      .listStyle(.sidebar)
      Text("Select scene")
    }
    .enableInjection()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
