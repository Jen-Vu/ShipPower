//
//  ViewController.swift
//  ShipPower
//
//  Created by DaiPei on 2017/10/31.
//  Copyright © 2017年 DaiPei. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, EditViewControllerDelegate {
    
    @IBOutlet weak var typePUB: NSPopUpButton!
    @IBOutlet weak var serialTF: NSTextField!
    @IBOutlet weak var nameTF: NSTextField!
    @IBOutlet weak var countTF: NSTextField!
    @IBOutlet weak var kAllTF: NSTextField!
    @IBOutlet weak var kTF: NSTextField!
    @IBOutlet weak var eTF: NSTextField!
    @IBOutlet weak var kNeedTF: NSTextField!
    @IBOutlet weak var kNeedAllTF: NSTextField!
    @IBOutlet weak var k1TF: NSTextField!
    @IBOutlet weak var sailingBtn: NSButton!
    @IBOutlet weak var workingBtn: NSButton! 
    @IBOutlet weak var inOrOutBtn: NSButton!
    @IBOutlet weak var anchorBtn: NSButton!
    @IBOutlet weak var k20TF: NSTextField!
    @IBOutlet weak var k30TF: NSTextField!
    @IBOutlet weak var k00TF: NSTextField!
    @IBOutlet weak var kw0TF: NSTextField!
    @IBOutlet weak var load0PUB: NSPopUpButton!
    @IBOutlet weak var k21TF: NSTextField!
    @IBOutlet weak var k31TF: NSTextField!
    @IBOutlet weak var k01TF: NSTextField!
    @IBOutlet weak var kw1TF: NSTextField!
    @IBOutlet weak var load1PUB: NSPopUpButton!
    @IBOutlet weak var k22TF: NSTextField!
    @IBOutlet weak var k32TF: NSTextField!
    @IBOutlet weak var k02TF: NSTextField!
    @IBOutlet weak var kw2TF: NSTextField!
    @IBOutlet weak var load2PUB: NSPopUpButton!
    @IBOutlet weak var k23TF: NSTextField!
    @IBOutlet weak var k33TF: NSTextField!
    @IBOutlet weak var k03TF: NSTextField!
    @IBOutlet weak var kw3TF: NSTextField!
    @IBOutlet weak var load3PUB: NSPopUpButton!
    @IBOutlet weak var firstBtn: NSButton!
    @IBOutlet weak var previousBtn: NSButton!
    @IBOutlet weak var nextBtn: NSButton!
    @IBOutlet weak var lastBtn: NSButton!
    @IBOutlet weak var modifyBtn: NSButton!
    @IBOutlet weak var deleteBtn: NSButton!
    @IBOutlet weak var insertBtn: NSButton!
    @IBOutlet weak var indexLabel: NSTextField!
    @IBOutlet weak var exportBtn: NSButton!
    var dataController: SPDataController?
    var idRow: Int64 = 0
    var deviceCount: Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        commonInit()
        updateDeviceCount()
        if deviceCount != 0 {
            idDidUpdate(1)
        } else {
            idDidUpdate(0)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segue.identifier?.rawValue {
        case "insertDevice"?:
            let evc = segue.destinationController as? EditViewController
            evc?.dataController = dataController
            evc?.delegate = self
            break
        case "modifyDevice"?:
            let evc = segue.destinationController as? EditViewController
            evc?.dataController = dataController
            evc?.delegate = self
            evc?.toBeUpdateId = idRow
            break
        default:
            print("never reach here")
        }
    }
    
    func commonInit() {
        let fm = FileManager.default
        let urls = fm.urls(for: .applicationSupportDirectory, in: .allDomainsMask)
        let dir = "ShipPower"
        var finalUrl : URL
        if urls.count > 0 {
            let url = urls[0];
            finalUrl = URL(fileURLWithPath: url.path + "/" + dir)
            if !fm.fileExists(atPath: finalUrl.path) {
                do {
                    try fm.createDirectory(at: finalUrl, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error)
                }
            }
            dataController = SPDataController(fileName: finalUrl.path + "/database")
        }
    }
    
    func configViews() {
        firstBtn.action = #selector(clickHandler(_:))
        previousBtn.action = #selector(clickHandler(_:))
        nextBtn.action = #selector(clickHandler(_:))
        lastBtn.action = #selector(clickHandler(_:))
        deleteBtn.action = #selector(clickHandler(_:))
    }
    
    @objc func clickHandler(_ sender: NSButton) {
        switch sender.tag {
        case 0:
            idRow = 1
            break
        case 1:
            idRow = idRow - 1
            break
        case 2:
            idRow = idRow + 1
            break
        case 3:
            idRow = Int64(deviceCount)
            break
        case 5:
            dataController?.deleteDevice(idNum: idRow)
            idRow = idRow - 1
            break
        default:
            print("never reach here")
        }
        updateDeviceCount()
        idDidUpdate(idRow)
    }
    
    func idDidUpdate(_ id: Int64) {
        idRow = id
        if idRow == 0 && deviceCount != 0 {
            idRow = 1
        }
        updateDisplayWithDevice()
        updateButtonState()
    }
    
    func updateDeviceCount() {
        deviceCount = (dataController?.deviceCount())!
    }

    func deviceDidSaved(id: Int64) {
        updateDeviceCount()
        idDidUpdate(id)
    }
    
    func updateDisplayWithDevice() {
        indexLabel.stringValue = "\(idRow) / \(deviceCount)"
        clearAllInput()
        if idRow == 0 {
            return
        }
        let device = dataController?.queryDevice(idNum: idRow)
        typePUB.selectItem(at: (device?.type.rawValue)!)
        nameTF.stringValue = (device?.name)!
        serialTF.doubleValue = Double((device?.id)!)
        countTF.integerValue = (device?.count)!
        kAllTF.doubleValue = (device?.kAll) ?? 0
        kTF.doubleValue = (device?.k) ?? 0
        eTF.doubleValue = (device?.e)!
        kNeedTF.doubleValue = (device?.kNeed)!
        kNeedAllTF.doubleValue = (device?.kNeedAll)!
        k1TF.doubleValue = (device?.k1)!
        sailingBtn.state = (device?.state.contains(.sailing))! ? .on : .off
        if (device?.state.contains(.sailing))! {
            k20TF.doubleValue = (device?.sailingConfig.k2)!
            k30TF.doubleValue = (device?.sailingConfig.k3)!
            k00TF.doubleValue = (device?.sailingConfig.k0)!
            kw0TF.doubleValue = (device?.sailingConfig.kw)!
            load0PUB.selectItem(at: (device?.sailingConfig.load.rawValue)!)
        }
        inOrOutBtn.state = (device?.state.contains(.inOrOut))! ? .on : .off
        if (device?.state.contains(.inOrOut))! {
            k21TF.doubleValue = (device?.inOrOutConfig.k2)!
            k31TF.doubleValue = (device?.inOrOutConfig.k3)!
            k01TF.doubleValue = (device?.inOrOutConfig.k0)!
            kw1TF.doubleValue = (device?.inOrOutConfig.kw)!
            load1PUB.selectItem(at: (device?.inOrOutConfig.load)!.rawValue)
        }
        workingBtn.state = (device?.state.contains(.working))! ? .on : .off
        if (device?.state.contains(.working))! {
            k22TF.doubleValue = (device?.workingConfig.k2)!
            k32TF.doubleValue = (device?.workingConfig.k3)!
            k02TF.doubleValue = (device?.workingConfig.k0)!
            kw2TF.doubleValue = (device?.workingConfig.kw)!
            load2PUB.selectItem(at: (device?.workingConfig.load)!.rawValue)
        }
        anchorBtn.state = (device?.state.contains(.anchor))! ? .on : .off
        if (device?.state.contains(.anchor))! {
            k23TF.doubleValue = (device?.anchorConfig.k2)!
            k33TF.doubleValue = (device?.anchorConfig.k3)!
            k03TF.doubleValue = (device?.anchorConfig.k0)!
            kw3TF.doubleValue = (device?.anchorConfig.kw)!
            load3PUB.selectItem(at: (device?.anchorConfig.load)!.rawValue)
        }
    }
    
    func updateButtonState() {
        if deviceCount == 0 {
            firstBtn.isEnabled = false
            previousBtn.isEnabled = false
            nextBtn.isEnabled = false
            lastBtn.isEnabled = false
            modifyBtn.isEnabled = false
            deleteBtn.isEnabled = false
            exportBtn.isEnabled = false
        } else {
            modifyBtn.isEnabled = true
            deleteBtn.isEnabled = true
            firstBtn.isEnabled = true
            lastBtn.isEnabled = true
            exportBtn.isEnabled = true
            
            if deviceCount == 1 {
                previousBtn.isEnabled = false
                nextBtn.isEnabled = false
            }else if idRow == 1{
                previousBtn.isEnabled = false
                nextBtn.isEnabled = true
            } else if idRow == deviceCount {
                previousBtn.isEnabled = true
                nextBtn.isEnabled = false
            } else {
                previousBtn.isEnabled = true
                nextBtn.isEnabled = true
            }
        }
    }
    
    @IBAction func exportCSV(_ sender: NSButton) {
        dataController?.export(path: "")
    }
    
    func clearAllInput() {
        serialTF.stringValue = ""
        nameTF.stringValue = ""
        countTF.stringValue = ""
        kAllTF.stringValue = ""
        kTF.stringValue = ""
        eTF.stringValue = ""
        kNeedTF.stringValue = ""
        kNeedAllTF.stringValue = ""
        k1TF.stringValue = ""
        sailingBtn.state = .off
        inOrOutBtn.state = .off
        workingBtn.state = .off
        anchorBtn.state = .off
        k00TF.stringValue = ""
        k20TF.stringValue = ""
        k30TF.stringValue = ""
        kw0TF.stringValue = ""
        k01TF.stringValue = ""
        k21TF.stringValue = ""
        k31TF.stringValue = ""
        kw1TF.stringValue = ""
        k02TF.stringValue = ""
        k22TF.stringValue = ""
        k32TF.stringValue = ""
        kw2TF.stringValue = ""
        k03TF.stringValue = ""
        k23TF.stringValue = ""
        k33TF.stringValue = ""
        kw3TF.stringValue = ""
    }
}

