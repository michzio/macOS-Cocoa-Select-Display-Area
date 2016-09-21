//
//  AppDelegate.swift
//  SelectionView
//
//  Created by Michal Ziobro on 19/09/2016.
//  Copyright © 2016 Michal Ziobro. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let screenFrame = NSScreen.main()?.frame
        
        //var behavior = self.window.collectionBehavior;
        //behavior = [behavior, .fullScreenAuxiliary];
        //window.collectionBehavior = behavior;
        window.setFrame(screenFrame!, display:true);
        window.toggleFullScreen(self)
        
        //NSApp.activate(ignoringOtherApps: true)
        //window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

