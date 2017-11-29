//
//  DisplayViewController.swift
//  ShipPower
//
//  Created by DaiPei on 2017/11/29.
//  Copyright © 2017年 DaiPei. All rights reserved.
//

import Cocoa

class DisplayViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var tableView: NSTableView!
    var dataController: SPDataController?
    var devices = [SPDevice]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let count = dataController?.deviceCount()
        if let n = count {
            for i in 1...n {
                devices.append((dataController?.queryDevice(idNum: Int64(i)))!)
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return devices.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = tableColumn?.identifier
        let cell: NSTableCellView = tableView.makeView(withIdentifier: identifier!, owner: self) as! NSTableCellView
        if let id = identifier?.rawValue {
            switch id {
            case "id":
                cell.textField?.integerValue = Int(devices[row].id)
                break
            case "name":
                cell.textField?.stringValue = devices[row].name
                break
            default:
                break
            }
        }
        return cell
    }
    
    func convert(_ str: String) -> String {
        let value = Int(str)
        if value == 0 {
            return ""
        }
        return str
    }

}
