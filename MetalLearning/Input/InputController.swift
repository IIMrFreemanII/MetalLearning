//
//  InputController.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 17.08.2022.
//

import GameController

class InputController {
  struct Point {
    var x: Float
    var y: Float
    static let zero = Point(x: 0, y: 0)
  }
  
  static let shared = InputController()
  
  var keysPressed: Set<GCKeyCode> = []
  var leftMouseDown = false
  var rightMouseDown = false
  var mouseDelta = Point.zero
  var mouseScroll = Point.zero
  
  private init() {
    let center = NotificationCenter.default
    center.addObserver(
      forName: .GCKeyboardDidConnect,
      object: nil,
      queue: nil
    ) { notification in
      let keyboard = notification.object as? GCKeyboard
      keyboard?.keyboardInput?.keyChangedHandler = { _, _, keyCode, pressed in
        if pressed {
          self.keysPressed.insert(keyCode)
        } else {
          self.keysPressed.remove(keyCode)
        }
      }
    }
    
#if os(macOS)
    NSEvent.addLocalMonitorForEvents(
      matching: [.keyDown]) { event in
        return NSApp.keyWindow?.firstResponder is NSTextView ? event : nil
      }
#endif
    
    center.addObserver(
      forName: .GCMouseDidConnect,
      object: nil,
      queue: nil
    ) { notification in
      let mouse = notification.object as? GCMouse
      // 1
      mouse?.mouseInput?.leftButton.pressedChangedHandler = { _, _, pressed in
        self.leftMouseDown = pressed
      }
      mouse?.mouseInput?.rightButton?.pressedChangedHandler = { _, _, pressed in
        self.rightMouseDown = pressed
      }
      // 2
      mouse?.mouseInput?.mouseMovedHandler = { _, deltaX, deltaY in
        self.mouseDelta = Point(x: deltaX, y: deltaY)
      }
      // 3
      mouse?.mouseInput?.scroll.valueChangedHandler = { _, xValue, yValue in
        self.mouseScroll.x = xValue
        self.mouseScroll.y = yValue
      }
    }
  }
}
