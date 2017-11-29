//
//  EditViewController.swift
//  ShipPower
//
//  Created by DaiPei on 2017/11/1.
//  Copyright © 2017年 DaiPei. All rights reserved.
//

import Cocoa

protocol EditViewControllerDelegate: class {
    func deviceDidSaved(id: Int64)
}

class EditViewController: NSViewController {

    var dataController: SPDataController?
    weak var delegate: EditViewControllerDelegate?
    var toBeUpdateId: Int64 = 0 // 0 means add a device
    @IBOutlet weak var typePUB: NSPopUpButton!
    @IBOutlet weak var nameTF: NSTextField!
    @IBOutlet weak var countTF: NSTextField!
    @IBOutlet weak var kAllTF: NSTextField!
    @IBOutlet weak var kTF: NSTextField!
    @IBOutlet weak var eTF: NSTextField!
    @IBOutlet weak var kNeedTF: NSTextField!
    @IBOutlet weak var kNeedAllTF: NSTextField!
    @IBOutlet weak var k1TF: NSTextField!
    @IBOutlet weak var sailingBtn: NSButton!
    @IBOutlet weak var inOrOutBtn: NSButton!
    @IBOutlet weak var workingBtn: NSButton!
    @IBOutlet weak var anchorBtn: NSButton!
    @IBOutlet weak var k20TF: NSTextField!
    @IBOutlet weak var k00TF: NSTextField!
    @IBOutlet weak var load0PUB: NSPopUpButton!
    @IBOutlet weak var k21TF: NSTextField!
    @IBOutlet weak var k01TF: NSTextField!
    @IBOutlet weak var load1PUB: NSPopUpButton!
    @IBOutlet weak var k22TF: NSTextField!
    @IBOutlet weak var k02TF: NSTextField!
    @IBOutlet weak var load2PUB: NSPopUpButton!
    @IBOutlet weak var k23TF: NSTextField!
    @IBOutlet weak var k03TF: NSTextField!
    @IBOutlet weak var load3PUB: NSPopUpButton!
    @IBOutlet weak var confirmBtn: NSButton!
    @IBOutlet weak var cancelBtn: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        confirmBtn.action = #selector(clickHandler(_:))
        cancelBtn.action = #selector(clickHandler(_:))
        updateInputField()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        print(segue.identifier?._rawValue ?? "no id for edit vc")
    }
    
    @IBAction func sailingStateChanged(_ sender: NSButton) {
        sender.tag = sender.state == .off ? 0 : 1
        k20TF.isEnabled = sender.state == .on
        k00TF.isEnabled = sender.state == .on
        load0PUB.isEnabled = sender.state == .on
    }
    
    @IBAction func inOrOutStateChanged(_ sender: NSButton) {
        sender.tag = sender.state == .off ? 0 : 2
        k21TF.isEnabled = sender.state == .on
        k01TF.isEnabled = sender.state == .on
        load1PUB.isEnabled = sender.state == .on
    }
    @IBAction func workingStateChanged(_ sender: NSButton) {
        sender.tag = sender.state == .off ? 0 : 4
        k22TF.isEnabled = sender.state == .on
        k02TF.isEnabled = sender.state == .on
        load2PUB.isEnabled = sender.state == .on
    }
    
    @IBAction func anchorStateChanged(_ sender: NSButton) {
        sender.tag = sender.state == .off ? 0 : 8
        k23TF.isEnabled = sender.state == .on
        k03TF.isEnabled = sender.state == .on
        load3PUB.isEnabled = sender.state == .on
    }
    
    @objc func clickHandler(_ sender: NSButton) {
        switch sender.tag {
        case 0:
            if toBeUpdateId == 0 {
                let id = dataController?.addDevice(device: generateDevice())
                delegate?.deviceDidSaved(id: id!)
            } else {
                dataController?.updateDevice(device: generateDevice(), idNum: toBeUpdateId)
                delegate?.deviceDidSaved(id: toBeUpdateId)
                toBeUpdateId = 0
            }
            self.dismissViewController(self)
            break
        case 1:
            self.dismissViewController(self)
            break
        default:
            print("never reach here")
            break
        }
    }
    
    func generateDevice() -> SPDevice{
        var device = SPDevice()
        device.type = SPDeviceType(rawValue: typePUB.indexOfSelectedItem)!
        device.name = nameTF.stringValue
        device.count = Int(countTF.intValue)
        device.kAll = kAllTF.doubleValue
        device.k = kTF.doubleValue
        device.e = eTF.doubleValue
        device.kNeed = kNeedTF.doubleValue
        device.k1 = k1TF.doubleValue
        device.kNeedAll = kNeedAllTF.doubleValue
        device.state = SPDeviceState(rawValue: sailingBtn.tag | inOrOutBtn.tag | workingBtn.tag | anchorBtn.tag)
        if sailingBtn.state == .on {
            device.sailingConfig.k0 = k00TF.doubleValue
            device.sailingConfig.k2 = k20TF.doubleValue
            device.sailingConfig.load = SPLoad(rawValue: load0PUB.indexOfSelectedItem)!
            device.sailingConfig.k3 = calculateK3(k1: k1TF.doubleValue, k2: k20TF.doubleValue)
            device.sailingConfig.kw = calculateKw(k: kTF.doubleValue, e: eTF.doubleValue, count: countTF.doubleValue)
        }
        if inOrOutBtn.state == .on {
            device.inOrOutConfig.k0 = k01TF.doubleValue
            device.inOrOutConfig.k2 = k21TF.doubleValue
            device.inOrOutConfig.load = SPLoad(rawValue: load1PUB.indexOfSelectedItem)!
            device.inOrOutConfig.k3 = calculateK3(k1: k1TF.doubleValue, k2: k21TF.doubleValue)
            device.inOrOutConfig.kw = calculateKw(k: kTF.doubleValue, e: eTF.doubleValue, count: countTF.doubleValue)
        }
        if workingBtn.state == .on {
            device.workingConfig.k0 = k02TF.doubleValue
            device.workingConfig.k2 = k22TF.doubleValue
            device.workingConfig.load = SPLoad(rawValue: load2PUB.indexOfSelectedItem)!
            device.workingConfig.k3 = calculateK3(k1: k1TF.doubleValue, k2: k22TF.doubleValue)
            device.workingConfig.kw = calculateKw(k: kTF.doubleValue, e: eTF.doubleValue, count: countTF.doubleValue)
        }
        if anchorBtn.state == .on {
            device.anchorConfig.k0 = k03TF.doubleValue
            device.anchorConfig.k2 = k23TF.doubleValue
            device.anchorConfig.load = SPLoad(rawValue: load3PUB.indexOfSelectedItem)!
            device.anchorConfig.k3 = calculateK3(k1: k1TF.doubleValue, k2: k23TF.doubleValue)
            device.anchorConfig.kw = calculateKw(k: kTF.doubleValue, e: eTF.doubleValue, count: countTF.doubleValue)
        }
        return device
    }
    
    func updateInputField() {
        if toBeUpdateId != 0 {
            let device = dataController?.queryDevice(idNum: toBeUpdateId)
            typePUB.selectItem(at: (device?.type.rawValue)!)
            nameTF.stringValue = (device?.name)!
            countTF.integerValue = (device?.count)!
            kAllTF.doubleValue = (device?.kAll)!
            kTF.doubleValue = (device?.k)!
            eTF.doubleValue = (device?.e)!
            kNeedTF.doubleValue = (device?.kNeed)!
            kNeedAllTF.doubleValue = (device?.kNeedAll)!
            k1TF.doubleValue = (device?.k1)!
            sailingBtn.state = (device?.state.contains(.sailing))! ? .on : .off
            if (device?.state.contains(.sailing))! {
                k20TF.doubleValue = (device?.sailingConfig.k2)!
                k00TF.doubleValue = (device?.sailingConfig.k0)!
                load0PUB.selectItem(at: (device?.sailingConfig.load.rawValue)!)
            }
            inOrOutBtn.state = (device?.state.contains(.inOrOut))! ? .on : .off
            if (device?.state.contains(.inOrOut))! {
                k21TF.doubleValue = (device?.inOrOutConfig.k2)!
                k01TF.doubleValue = (device?.inOrOutConfig.k0)!
                load1PUB.selectItem(at: (device?.inOrOutConfig.load)!.rawValue)
            }
            workingBtn.state = (device?.state.contains(.working))! ? .on : .off
            if (device?.state.contains(.working))! {
                k22TF.doubleValue = (device?.workingConfig.k2)!
                k02TF.doubleValue = (device?.workingConfig.k0)!
                load2PUB.selectItem(at: (device?.workingConfig.load)!.rawValue)
            }
            anchorBtn.state = (device?.state.contains(.anchor))! ? .on : .off
            if (device?.state.contains(.anchor))! {
                k23TF.doubleValue = (device?.anchorConfig.k2)!
                k03TF.doubleValue = (device?.anchorConfig.k0)!
                load3PUB.selectItem(at: (device?.anchorConfig.load)!.rawValue)
            }
        }
    }
    
    func calculateKw(k: Double, e: Double, count: Double) -> Double{
        var kw: Double = 0
        if e != 0 {
            kw = count * k / e
        }
        return kw
    }
    
    func calculateK3(k1: Double, k2: Double) -> Double {
        return k1 * k2
    }
}
