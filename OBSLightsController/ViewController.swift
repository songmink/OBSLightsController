//
//  ViewController.swift
//  OBSLightsController
//
//  Created by Songmin Kim on 1/23/20.
//  Copyright © 2020 Center for Language & Technology. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var type: NSSegmentedCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func typeChanged(_ sender: Any) {
        
        switch type.selectedSegment {
        case 0:
            if appDelegate().lightStatus == 1 {
                appDelegate().filewatcher.stop()
                appDelegate().lightStatus = allPower(0)
                appDelegate().statusItem.button?.image = NSImage(named: NSImage.Name("Images/off_16x16"))
            }
        case 1:
            if appDelegate().lightStatus == 0 {
                appDelegate().filewatcher.stop()
                appDelegate().lightStatus = allPower(1)
                appDelegate().statusItem.button?.image = NSImage(named: NSImage.Name("Images/on_16x16"))
            }

        default:
            appDelegate().usbMonitor()
        }
    }
    
    @IBAction func quitButtonClicked(_ sender: Any) {
        exit(0)
    }
    
    // Call AppDelegate's function.
    func appDelegate() -> AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }
}
