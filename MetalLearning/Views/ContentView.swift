//
//  ContentView.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 13.08.2022.
//

import SwiftUI
import MetalKit

struct ContentView: View {
  let scenes = [Demo1.self]
  
  var body: some View {
    NavigationView {
      List {
        Section("Scenes") {
          ForEach(scenes.indices, id: \.self) { i in
            let name = "\(scenes[i])"
            NavigationLink(name, destination: scenes[i].init)
          }
        }
      }
      .listStyle(.sidebar)
      Text("Empty")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
