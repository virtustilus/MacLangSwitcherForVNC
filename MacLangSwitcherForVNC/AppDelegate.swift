//
//  AppDelegate.swift
//  MacLangSwitcherForVNC
//
//  Created by Vision on 16.06.2020.
//  Copyright © 2020 Virtustilus. All rights reserved.
//

import Cocoa
import SwiftUI
import Carbon
import Quartz


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var window: NSWindow?
  var cmdPressed: Bool! = false
  var keysReleased: Bool! = true

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Create the SwiftUI view that provides the window contents.
    //let contentView = ContentView()

    // Create the window and set the content view. 
//    window = NSWindow(
//        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
//        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
//        backing: .buffered, defer: false)
//    window.center()
//    window.setFrameAutosaveName("Main Window")
//    window.contentView = NSHostingView(rootView: contentView)
//    window.makeKeyAndOrderFront(nil)
            
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: setup)
  }
  
  private func setup() {
        
      let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
      let accessEnabled = AXIsProcessTrustedWithOptions(options)
      
      if !accessEnabled {
          print("Access Not Enabled")
      } else {
          print("Access is enabled")
      }
        
      NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) {
        let mask = $0.modifierFlags.intersection(.deviceIndependentFlagsMask)
        NSLog("keyDown: \(String(describing: mask))")
        
        if mask.contains(.command) {
          self.cmdPressed = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: self.checkKey)
        } else {
          self.cmdPressed = false
          self.keysReleased = true
        }
      }
      
//      NSEvent.addGlobalMonitorForEvents(matching: .keyDown) {
//        let event = $0
//        NSLog("keyDown: \(String(describing: event))")
//        if event.keyCode == 49 {
//          //space pressed
//          if self.cmdPressed {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: self.switchLang)
//          }
//        }
//      }
  }

  public func checkKey() {
    
    if cmdPressed && isSpaceKeyPressed() {
      if (keysReleased) {
        InputSourcesSwitcher.switchToNext()
        keysReleased = false
      }
    } else {
      if (!keysReleased) {
        keysReleased = true
      }
    }
    
    if cmdPressed {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: checkKey)
    }
  }
  
  private func isSpaceKeyPressed() -> Bool {
    return CGEventSource.keyState(.hidSystemState, key: 49)
  }
  
  private func switchLang() {
    InputSourcesSwitcher.switchToNext()
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
}
