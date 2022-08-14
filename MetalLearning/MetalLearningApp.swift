//
//  MetalLearningApp.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 13.08.2022.
//

import SwiftUI
import Inject

@main
struct MetalLearningApp: App {
  @ObserveInjection private var inject
  
  init() {
    Renderer.initialize()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .enableInjection()
    }
    .commands {
      SidebarCommands()
    }
    .windowStyle(.hiddenTitleBar)
  }
}
