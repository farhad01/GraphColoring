//
//  AppDelegate.swift
//  GraphColoring
//
//  Created by farhad jebelli on 12/15/18.
//  Copyright © 2018 farhad jebelli. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NSApplication.shared.keyWindow?.acceptsMouseMovedEvents = true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

