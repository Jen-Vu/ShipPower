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
    private var devices = [SPDevice]()
    private var p0: [Double] = [0, 0, 0]
    private var p1: [Double] = [0, 0, 0]
    private var p2: [Double] = [0, 0, 0]
    private var p3: [Double] = [0, 0, 0]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let count = dataController?.deviceCount()
        if let n = count {
            for i in 1...n {
                let device = dataController?.queryDevice(idNum: Int64(i))
                devices.append(device!)
                if (device?.state.contains(.sailing))! {
                    let origin = p0[(device?.sailingConfig.load.rawValue)!]
                    let value = device?.sailingConfig.kw
                    p0[(device?.sailingConfig.load.rawValue)!] = origin + value! * Double((device?.count)!) / (device?.e)!
                }
                if (device?.state.contains(.inOrOut))! {
                    let origin = p0[(device?.inOrOutConfig.load.rawValue)!]
                    let value = device?.inOrOutConfig.kw
                    p0[(device?.inOrOutConfig.load.rawValue)!] = origin + value! * Double((device?.count)!) / (device?.e)!
                }
                if (device?.state.contains(.working))! {
                    let origin = p0[(device?.workingConfig.load.rawValue)!]
                    let value = device?.workingConfig.kw
                    p0[(device?.workingConfig.load.rawValue)!] = origin + value! * Double((device?.count)!) / (device?.e)!
                }
                if (device?.state.contains(.anchor))! {
                    let origin = p0[(device?.anchorConfig.load.rawValue)!]
                    let value = device?.anchorConfig.kw
                    p0[(device?.anchorConfig.load.rawValue)!] = origin + value! * Double((device?.count)!) / (device?.e)!
                }
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView.identifier?.rawValue == "input" {
            return devices.count
        }
        if tableView.identifier?.rawValue == "output" {
            return 10
        }
        return 0
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = tableColumn?.identifier
        let tableId = tableView.identifier?.rawValue
        let cell: NSTableCellView = tableView.makeView(withIdentifier: identifier!, owner: self) as! NSTableCellView
        if tableId == "output" {
            cell.textField?.stringValue = outputString(at: row, of: (identifier?.rawValue)!)
            return cell
        }
        if let id = identifier?.rawValue {
            switch id {
            case "id":
                cell.textField?.integerValue = Int(devices[row].id)
                break
            case "name":
                cell.textField?.stringValue = devices[row].name
                break
            case "count":
                cell.textField?.integerValue = devices[row].count
                break
            case "kAll":
                cell.textField?.stringValue = convert(devices[row].kAll)
                break
            case "k":
                cell.textField?.stringValue = convert(devices[row].k)
                break
            case "e":
                cell.textField?.stringValue = convert(devices[row].e)
                break
            case "kNeed":
                cell.textField?.stringValue = convert(devices[row].kNeed)
                break
            case "kNeedAll":
                cell.textField?.stringValue = convert(devices[row].kNeedAll)
                break
            case "k1":
                cell.textField?.stringValue = convert(devices[row].k1)
                break
            case "k20":
                cell.textField?.stringValue = convert(devices[row].sailingConfig.k2)
                break
            case "k30":
                cell.textField?.stringValue = convert(devices[row].sailingConfig.k3)
                break
            case "k00":
                cell.textField?.stringValue = convert(devices[row].sailingConfig.k0)
                break
            case "kw0":
                cell.textField?.stringValue = convert(devices[row].sailingConfig.kw)
                break
            case "load0":
                cell.textField?.stringValue = ""
                if devices[row].state.contains(.sailing) {
                    cell.textField?.stringValue = String(devices[row].sailingConfig.load.rawValue + 1)
                }
                break
            case "k21":
                cell.textField?.stringValue = convert(devices[row].inOrOutConfig.k2)
                break
            case "k31":
                cell.textField?.stringValue = convert(devices[row].inOrOutConfig.k3)
                break
            case "k01":
                cell.textField?.stringValue = convert(devices[row].inOrOutConfig.k0)
                break
            case "kw1":
                cell.textField?.stringValue = convert(devices[row].inOrOutConfig.kw)
                break
            case "load1":
                cell.textField?.stringValue = ""
                if devices[row].state.contains(.inOrOut) {
                    cell.textField?.stringValue = String(devices[row].inOrOutConfig.load.rawValue + 1)
                }
                break
            case "k22":
                cell.textField?.stringValue = convert(devices[row].workingConfig.k2)
                break
            case "k32":
                cell.textField?.stringValue = convert(devices[row].workingConfig.k3)
                break
            case "k02":
                cell.textField?.stringValue = convert(devices[row].workingConfig.k0)
                break
            case "kw2":
                cell.textField?.stringValue = convert(devices[row].workingConfig.kw)
                break
            case "load2":
                cell.textField?.stringValue = ""
                if devices[row].state.contains(.working) {
                    cell.textField?.stringValue = String(devices[row].workingConfig.load.rawValue + 1)
                }
                break
            case "k23":
                cell.textField?.stringValue = convert(devices[row].anchorConfig.k2)
                break
            case "k33":
                cell.textField?.stringValue = convert(devices[row].anchorConfig.k3)
                break
            case "k03":
                cell.textField?.stringValue = convert(devices[row].anchorConfig.k0)
                break
            case "kw3":
                cell.textField?.stringValue = convert(devices[row].anchorConfig.kw)
                break
            case "load3":
                cell.textField?.stringValue = ""
                if devices[row].state.contains(.anchor) {
                    cell.textField?.stringValue = String(devices[row].anchorConfig.load.rawValue + 1)
                }
                break
            default:
                print("undefined id:\(id)")
                break
            }
        }
        return cell
    }
    
    func outputString(at row: Int, of id: String) -> String {
        var result = ""
        switch row {
        case 0:
            if id == "output" {
                result = "1类负荷总功率/kW"
            } else {
                var power: Double = 0
                if id == "sailing" {
                    power = p0[0]
                } else if id == "inOrOut" {
                    power = p1[0]
                } else if id == "working" {
                    power = p2[0]
                } else if id == "anchor" {
                    power = p3[0]
                }
                result = "P = \(power)"
            }
            break
        case 1:
            if id == "output" {
                result = "2类负荷总功率/kW"
            } else {
                var power: Double = 0
                if id == "sailing" {
                    power = p0[1]
                } else if id == "inOrOut" {
                    power = p1[1]
                } else if id == "working" {
                    power = p2[1]
                } else if id == "anchor" {
                    power = p3[1]
                }
                result = "P = \(power)"
            }
            break
        case 2:
            if id == "output" {
                result = "3类负荷总功率/kW"
            } else {
                var power: Double = 0
                if id == "sailing" {
                    power = p0[2]
                } else if id == "inOrOut" {
                    power = p1[2]
                } else if id == "working" {
                    power = p2[2]
                } else if id == "anchor" {
                    power = p3[2]
                }
                result = "P = \(power)"
            }
            break
        case 3:
            if id == "output" {
                result = "1类负荷考虑同时系数0.9时总功率/kW"
            } else {
                var power: Double = 0
                if id == "sailing" {
                    power = p0[0] * 0.9
                } else if id == "inOrOut" {
                    power = p1[0] * 0.9
                } else if id == "working" {
                    power = p2[0] * 0.9
                } else if id == "anchor" {
                    power = p3[0] * 0.9
                }
                result = "P = \(power)"
            }
            break
        case 4:
            if id == "output" {
                result = "2类负荷考虑同时系数0.9时总功率/kW"
            } else {
                var power: Double = 0
                if id == "sailing" {
                    power = p0[1] * 0.9
                } else if id == "inOrOut" {
                    power = p1[1] * 0.9
                } else if id == "working" {
                    power = p2[1] * 0.9
                } else if id == "anchor" {
                    power = p3[1] * 0.9
                }
                result = "P = \(power)"
            }
            break
        case 5:
            if id == "output" {
                result = "考虑总同时系数后1、2类总功率之和/kW"
            } else {
                var power: Double = 0
                if id == "sailing" {
                    power = (p0[0] + p0[1]) * 0.9
                } else if id == "inOrOut" {
                    power = (p1[0] + p1[1]) * 0.9
                } else if id == "working" {
                    power = (p2[0] + p2[1]) * 0.9
                } else if id == "anchor" {
                    power = (p3[0] + p3[1]) * 0.9
                }
                result = "P = \(power)"
            }
            break
        case 6:
            if id == "output" {
                result = "考虑网络损失5%后所需总功率/kW"
            } else {
                var power: Double = 0
                if id == "sailing" {
                    power = (p0[0] + p0[1]) * 0.9 / 0.95
                } else if id == "inOrOut" {
                    power = (p1[0] + p1[1]) * 0.9 / 0.95
                } else if id == "working" {
                    power = (p2[0] + p2[1]) * 0.9 / 0.95
                } else if id == "anchor" {
                    power = (p3[0] + p3[1]) * 0.9 / 0.95
                }
                result = "P = \(power)"
            }
            break
        case 7:
            if id == "output" {
                result = "运行发电机/（台数 X kW）"
            } else {
                var power: Double = 0
                var count: Int = 0
                if id == "sailing" {
                    power = (p0[0] + p0[1]) * 0.9 / 0.95
                } else if id == "inOrOut" {
                    power = (p1[0] + p1[1]) * 0.9 / 0.95
                } else if id == "working" {
                    power = (p2[0] + p2[1]) * 0.9 / 0.95
                } else if id == "anchor" {
                    power = (p3[0] + p3[1]) * 0.9 / 0.95
                }
                count = Int(ceil(power / Double(90)))
                result = "\(count) X 90"
            }
            break
        case 8:
            if id == "output" {
                result = "备用发电机/（台数 X kW）"
            } else {
                var power: Double = 0
                var count: Int = 0
                if id == "sailing" {
                    power = (p0[0] + p0[1]) * 0.9 / 0.95
                } else if id == "inOrOut" {
                    power = (p1[0] + p1[1]) * 0.9 / 0.95
                } else if id == "working" {
                    power = (p2[0] + p2[1]) * 0.9 / 0.95
                } else if id == "anchor" {
                    power = (p3[0] + p3[1]) * 0.9 / 0.95
                }
                count = Int(ceil(power / Double(90)))
                if count >= 2 {
                    result = "1 X 90"
                } else {
                    result = "2 X 90"
                }
            }
            break
        case 9:
            if id == "output" {
                result = "发电机的负荷率/%"
            } else {
                var power: Double = 0
                var count: Int = 0
                if id == "sailing" {
                    power = (p0[0] + p0[1]) * 0.9 / 0.95
                } else if id == "inOrOut" {
                    power = (p1[0] + p1[1]) * 0.9 / 0.95
                } else if id == "working" {
                    power = (p2[0] + p2[1]) * 0.9 / 0.95
                } else if id == "anchor" {
                    power = (p3[0] + p3[1]) * 0.9 / 0.95
                }
                count = Int(ceil(power / Double(90)))
                if count == 0 {
                    result = "0"
                } else {
                    result = "\(power / Double(count * 90) * 100)"
                }
            }
            break
        default:
            break
        }
        return result
    }

    func convert(_ value: Double) -> String {
        if value == 0 {
            return ""
        }
        return String(value)
    }

}
