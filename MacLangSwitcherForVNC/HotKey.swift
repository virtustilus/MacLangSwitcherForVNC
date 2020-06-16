//
//  HotKey.swift
//  MacLangSwitcherForVNC
//
//  Created by Vision on 16.06.2020.
//  Copyright © 2020 Virtustilus. All rights reserved.
//

import Cocoa
import Carbon

extension String {
  /// This converts string to UInt as a fourCharCode
  public var fourCharCodeValue: Int {
    var result: Int = 0
    if let data = self.data(using: String.Encoding.macOSRoman) {
      data.withUnsafeBytes({ (rawBytes) in
        let bytes = rawBytes.bindMemory(to: UInt8.self)
        for i in 0 ..< data.count {
          result = result << 8 + Int(bytes[i])
        }
      })
    }
    return result
  }
}

// public typealias HotKeyCB = @convention(c) () -> OSStatus
// public typealias HotKeyCallback =

class HotKey {

  func getCarbonFlagsFromCocoaFlags(cocoaFlags: NSEvent.ModifierFlags) -> UInt32 {
    let flags = cocoaFlags.rawValue
    var newFlags: Int = 0

    if ((flags & NSEvent.ModifierFlags.control.rawValue) > 0) {
      newFlags |= controlKey
    }

    if ((flags & NSEvent.ModifierFlags.command.rawValue) > 0) {
      newFlags |= cmdKey
    }

    if ((flags & NSEvent.ModifierFlags.shift.rawValue) > 0) {
      newFlags |= shiftKey;
    }

    if ((flags & NSEvent.ModifierFlags.option.rawValue) > 0) {
      newFlags |= optionKey
    }

    if ((flags & NSEvent.ModifierFlags.capsLock.rawValue) > 0) {
      newFlags |= alphaLock
    }

    return UInt32(newFlags);
  }

  func register(keyCode: Int, modifierFlags: NSEvent.ModifierFlags, _ callback: HotKeyCallback) {
    var hotKeyRef: EventHotKeyRef?
    let modifierFlags: UInt32 =
      getCarbonFlagsFromCocoaFlags(cocoaFlags: NSEvent.ModifierFlags.command)

    // let keyCode = kVK_ANSI_R
    let keyCode = kVK_Space
    var gMyHotKeyID = EventHotKeyID()

    gMyHotKeyID.id = UInt32(keyCode)

    // Not sure what "swat" vs "htk1" do.
    gMyHotKeyID.signature = OSType("swat".fourCharCodeValue)
    // gMyHotKeyID.signature = OSType("htk1".fourCharCodeValue)

    var eventType = EventTypeSpec()
    eventType.eventClass = OSType(kEventClassKeyboard)
    eventType.eventKind = OSType(kEventHotKeyReleased)
    
    // Install handler.
    let ptr = UnsafeMutablePointer<Any>.allocate(capacity: 1)
    ptr.initialize(to: callback.cb)

    let eventHandlerUPP: EventHandlerUPP = {(_: OpaquePointer?, _: OpaquePointer?, ptr: UnsafeMutableRawPointer?) -> OSStatus in
        guard let pointer = ptr else { fatalError() }
        // EventHandlerProcPtr
        UnsafeMutablePointer<() -> ()>(OpaquePointer(pointer)).pointee()
        return noErr
    }

    InstallEventHandler(GetApplicationEventTarget(), eventHandlerUPP, 1, &eventType, ptr, nil)

    // Register hotkey.
    let status = RegisterEventHotKey(UInt32(keyCode),
                                     modifierFlags,
                                     gMyHotKeyID,
                                     GetApplicationEventTarget(),
                                     0,
                                     &hotKeyRef)
    assert(status == noErr)
  }
  
}
