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


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var window: NSWindow!
  var hotkey: HotKey!


  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Create the SwiftUI view that provides the window contents.
    let contentView = ContentView()

    // Create the window and set the content view. 
    window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
        backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("Main Window")
    window.contentView = NSHostingView(rootView: contentView)
    window.makeKeyAndOrderFront(nil)
    
    HotKey.register(keyCode: kVK_Space, modifierFlags: NSEvent.ModifierFlags.command) {
      
      print("Callback happened!")
      
      return noErr
    }
    
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

