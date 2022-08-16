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
  
  @State private var isDemo1Active = true
  
  var body: some View {
    NavigationView {
      List {
        Section("Scenes") {
          NavigationLink("Demo1", isActive: $isDemo1Active) {
            Demo1()
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
