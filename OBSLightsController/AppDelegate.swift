//
//  AppDelegate.swift
//  OBSLightsController
//
//  Created by Songmin Kim on 1/23/20.
//  Copyright © 2020 Center for Language & Technology. All rights reserved.
//

import Cocoa
import FileWatcher

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let filewatcher = FileWatcher([NSString(string: "/Volumes").expandingTildeInPath])
    var initVolumes = 0
    var lightStatus: Int32 = 0

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("Images/off_16x16"))
            button.target = self
            button.action = #selector(showSettings)
        }
        
        initVolumes = countVolumes()
        usbMonitor()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func showSettings() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "ViewController")
            as? ViewController else {
            fatalError("Unable to find ViewController in the storyboard.")
        }
        
        guard let button = statusItem.button else {
            fatalError("Coouldn't find status item button.")
        }
        let popoverView = NSPopover()
        popoverView.contentViewController = vc
        popoverView.behavior = .transient
        popoverView.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
    }
    
    func usbMonitor() {
        var currentVolumes = self.initVolumes
        self.filewatcher.callback = { event in
            sleep(3)
            currentVolumes = countVolumes()
            if currentVolumes > self.initVolumes {
                self.lightStatus = allPower(1)
                self.statusItem.button?.image = NSImage(named: NSImage.Name("Images/on_16x16"))
            } else {
                self.lightStatus = allPower(0)
                self.statusItem.button?.image = NSImage(named: NSImage.Name("Images/off_16x16"))
            }
        }
        self.filewatcher.start()
    }
}
