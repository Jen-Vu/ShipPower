//
//  WelcomViewController.swift
//  ShipPower
//
//  Created by DaiPei on 2017/10/31.
//  Copyright © 2017年 DaiPei. All rights reserved.
//

import Cocoa

let homeDirectoryName = "ShipPower"


class WelcomViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createHomeDirectory()
        
    }
    
    func createHomeDirectory() {
        let fm = FileManager.default
        let urls = fm.urls(for: .applicationSupportDirectory, in: .allDomainsMask)
        if urls.count > 0 {
            print(urls[0].path)
        }
    }

}
