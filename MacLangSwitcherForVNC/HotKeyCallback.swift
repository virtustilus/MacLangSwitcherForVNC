//
//  HotKeyCallback.swift
//  MacLangSwitcherForVNC
//
//  Created by Vision on 16.06.2020.
//  Copyright © 2020 Virtustilus. All rights reserved.
//

import Cocoa
import Carbon

class HotKeyCallback: NSObject {
  public var cb: ()->OSStatus
  
  init(callback: @escaping ()->OSStatus) {
    cb = callback
  }
}
