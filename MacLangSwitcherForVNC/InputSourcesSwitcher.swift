//
//  InputSourcesSwitcher.swift
//  MacLangSwitcherForVNC
//
//  Created by Vision on 16.06.2020.
//  Copyright © 2020 Virtustilus. All rights reserved.
//

import Cocoa
import Foundation
import Carbon

class InputSourcesSwitcher: NSObject {
  
  static var sourceList: [TISInputSource] = [];
  
  private static func getInputID(inputSource: TISInputSource) -> String {
    let ptr = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID)
    let val = Unmanaged<CFString>.fromOpaque(ptr!).takeUnretainedValue() as String
    return val
  }

  private static func getNextInput(inputSources: [TISInputSource], currentSource: TISInputSource) -> TISInputSource {
    let currentID = getInputID(inputSource: currentSource)
    var found = false
    for source in sourceList {
      let inputID = getInputID(inputSource: source)
      if found {
        return source
      }
      if inputID == currentID {
        found = true
      }
    }
    return sourceList[0]
  }
  
  public static func switchToNext() {
    sourceList = TISCreateInputSourceList(nil, false).takeRetainedValue() as NSArray as! [TISInputSource]
    sourceList = sourceList.filter() {
      source in
      let inputID = getInputID(inputSource: source)
      return inputID.starts(with: "com.apple.keylayout.")
    }

    let current = TISCopyCurrentKeyboardLayoutInputSource().takeRetainedValue()
    let next = getNextInput(inputSources: sourceList, currentSource: current)

    let err = TISSelectInputSource(next)

    if err != noErr {
      NSLog("Some error happended in TISSelectInputSource: \(String(describing: err)) ")
    }
  }

  
}
