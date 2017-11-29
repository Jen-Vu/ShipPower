//
//  AppDelegate.swift
//  ShipPower
//
//  Created by DaiPei on 2017/10/31.
//  Copyright © 2017年 DaiPei. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow?
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        window = NSApplication.shared.mainWindow
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if flag {
            return false
        } else {
            window?.makeKeyAndOrderFront(self)
            return true
        }
    }

}

