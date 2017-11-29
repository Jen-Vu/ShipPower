//
//  SPDataController.swift
//  ShipPower
//
//  Created by DaiPei on 2017/10/31.
//  Copyright © 2017年 DaiPei. All rights reserved.
//

import Cocoa
import SQLite
import SwiftCSVExport

struct SPDevice {
    var id: Int64
    var type: SPDeviceType
    var serial: Int
    var name: String
    var count: Int
    var kAll: Double = 0
    var k: Double = 0
    var e: Double = 0
    var kNeed: Double = 0
    var kNeedAll: Double
    var k1: Double = 0
    var state: SPDeviceState
    var sailingConfig: SPDeviceStateConfig = SPDeviceStateConfig()
    var inOrOutConfig: SPDeviceStateConfig = SPDeviceStateConfig()
    var workingConfig: SPDeviceStateConfig = SPDeviceStateConfig()
    var anchorConfig: SPDeviceStateConfig = SPDeviceStateConfig()
    
    init() {
        self.init(id: 0, type: .marine, serial: 0, name: "", count: 0, kNeedAll: 0, state: .none)
    }
    
    init(id: Int64, type: SPDeviceType, serial: Int, name: String, count: Int, kNeedAll: Double, state: SPDeviceState) {
        self.id = id
        self.type = type
        self.serial = serial
        self.name = name
        self.count = count
        self.kNeedAll = kNeedAll
        self.state = state
    }
}

enum SPDeviceType: Int {
    case outfitting = 0, marine = 1, airOrCold = 2, other = 3
}

struct SPDeviceStateConfig {
    var k2: Double
    var k3: Double
    var k0: Double
    var kw: Double
    var load: SPLoad
    
    init() {
        k2 = 0
        k3 = 0
        k0 = 0
        kw = 0
        load = .one
    }
}

enum SPLoad: Int {
    case one = 0, two = 1, three = 2
}

struct SPDeviceState: OptionSet {
    let rawValue: Int
    static let none    = SPDeviceState(rawValue: 0)
    static let sailing = SPDeviceState(rawValue: 1 << 0)
    static let inOrOut = SPDeviceState(rawValue: 1 << 1)
    static let working = SPDeviceState(rawValue: 1 << 2)
    static let anchor  = SPDeviceState(rawValue: 1 << 3)
}


class SPDataController: NSObject {
    
    private let id = Expression<Int64>("id")
    private let type = Expression<Int>("type")
    private let serial = Expression<Int>("serial")
    private let name = Expression<String>("name")
    private let count = Expression<Int>("count")
    private let kAll = Expression<Double>("kALL")
    private let k = Expression<Double>("k")
    private let e = Expression<Double>("e")
    private let kNeed = Expression<Double>("kNeed")
    private let kNeedAll = Expression<Double>("kNeedAll")
    private let k1 = Expression<Double>("k1")
    private let state = Expression<Int>("state")
    private let k20 = Expression<Double>("k20")
    private let k30 = Expression<Double>("k30")
    private let k00 = Expression<Double>("k00")
    private let kw0 = Expression<Double>("kw0")
    private let load0 = Expression<Int>("load0")
    private let k21 = Expression<Double>("k21")
    private let k31 = Expression<Double>("k31")
    private let k01 = Expression<Double>("k01")
    private let kw1 = Expression<Double>("kw1")
    private let load1 = Expression<Int>("load1")
    private let k22 = Expression<Double>("k22")
    private let k32 = Expression<Double>("k32")
    private let k02 = Expression<Double>("k02")
    private let kw2 = Expression<Double>("kw2")
    private let load2 = Expression<Int>("load2")
    private let k23 = Expression<Double>("k23")
    private let k33 = Expression<Double>("k33")
    private let k03 = Expression<Double>("k03")
    private let kw3 = Expression<Double>("kw3")
    private let load3 = Expression<Int>("load3")
    var db: Connection?
    let devices = Table("devices")

    override init() {
        super.init()
    }

    convenience init(fileName: String) {
        self.init()
        do {
            db = try Connection(fileName)
            try db?.run(devices.create(ifNotExists:true) { (t) in
                t.column(id, primaryKey: true)
                t.column(type)
                t.column(serial)
                t.column(name)
                t.column(count)
                t.column(kAll)
                t.column(k)
                t.column(e)
                t.column(kNeed)
                t.column(kNeedAll)
                t.column(k1)
                t.column(state)
                t.column(k20)
                t.column(k30)
                t.column(k00)
                t.column(kw0)
                t.column(load0)
                t.column(k21)
                t.column(k31)
                t.column(k01)
                t.column(kw1)
                t.column(load1)
                t.column(k22)
                t.column(k32)
                t.column(k02)
                t.column(kw2)
                t.column(load2)
                t.column(k23)
                t.column(k33)
                t.column(k03)
                t.column(kw3)
                t.column(load3)
            })
        } catch {
            print(error)
        }
    }

    public func addDevice(device: SPDevice) -> Int64  {
        var rowId: Int64 = 0
        
        do {
            let ins = devices.insert(type <- device.type.rawValue, serial <- device.serial, name <- device.name,
                                     count <- device.count, kAll <- device.kAll , k <- device.k , e <- device.e ,
                                     kNeed <- device.kNeed , kNeedAll <- device.kNeedAll, k1 <- device.k1 ,
                                     state <- device.state.rawValue, k20 <- device.sailingConfig.k2 ,
                                     k30 <- device.sailingConfig.k3 , k00 <- device.sailingConfig.k0 ,
                                     kw0 <- device.sailingConfig.kw , load0 <- device.sailingConfig.load.rawValue ,
                                     k21 <- device.inOrOutConfig.k2 , k31 <- device.inOrOutConfig.k3 ,
                                     k01 <- device.inOrOutConfig.k0 , kw1 <- device.inOrOutConfig.kw ,
                                     load1 <- device.inOrOutConfig.load.rawValue , k22 <- device.workingConfig.k2 ,
                                     k32 <- device.workingConfig.k3 , k02 <- device.workingConfig.k0 ,
                                     kw2 <- device.workingConfig.kw , load2 <- device.workingConfig.load.rawValue ,
                                     k23 <- device.anchorConfig.k2 , k33 <- device.anchorConfig.k3 ,
                                     k03 <- device.anchorConfig.k0 , kw3 <- device.anchorConfig.kw ,
                                     load3 <- device.anchorConfig.load.rawValue )
            rowId = (try db?.run(ins))!
            for de in (try db?.prepare(devices))! {
                print("id:\(de[id]) name:\(de[name]) serial:\(de[serial])")
            }
        } catch {
            assert(false)
            print("save device with error: \(error)")
        }
        return rowId
    }
    
    public func updateDevice(device: SPDevice, idNum: Int64) {
        do {
            let query = devices.filter(id == idNum)
            try db?.run(query.update(type <- device.type.rawValue, serial <- device.serial, name <- device.name,
                                     count <- device.count, kAll <- device.kAll , k <- device.k , e <- device.e ,
                                     kNeed <- device.kNeed , kNeedAll <- device.kNeedAll, k1 <- device.k1 ,
                                     state <- device.state.rawValue, k20 <- device.sailingConfig.k2 ,
                                     k30 <- device.sailingConfig.k3 , k00 <- device.sailingConfig.k0 ,
                                     kw0 <- device.sailingConfig.kw , load0 <- device.sailingConfig.load.rawValue ,
                                     k21 <- device.inOrOutConfig.k2 , k31 <- device.inOrOutConfig.k3 ,
                                     k01 <- device.inOrOutConfig.k0 , kw1 <- device.inOrOutConfig.kw ,
                                     load1 <- device.inOrOutConfig.load.rawValue , k22 <- device.workingConfig.k2 ,
                                     k32 <- device.workingConfig.k3 , k02 <- device.workingConfig.k0 ,
                                     kw2 <- device.workingConfig.kw , load2 <- device.workingConfig.load.rawValue ,
                                     k23 <- device.anchorConfig.k2 , k33 <- device.anchorConfig.k3 ,
                                     k03 <- device.anchorConfig.k0 , kw3 <- device.anchorConfig.kw ,
                                     load3 <- device.anchorConfig.load.rawValue ))
        } catch {
            print("update device with error: \(error)")
            assert(false)
        }
    }
    
    public func deleteDevice(idNum: Int64) {
        do {
            let query = devices.filter(id == idNum)
            try db?.run(query.delete())
        } catch {
            print("delete device with error: \(error)")
            assert(false)
        }
    }
    public func queryDevice(idNum: Int64) -> SPDevice {
        var result = SPDevice(id: 0, type: .airOrCold, serial: 0, name: "", count: 0, kNeedAll: 0, state: .anchor)
        do {
            let query = devices.filter(idNum == id)
            let all = Array(try db!.prepare(query))
            assert(all.count <= 1)
            if all.count == 1 {
                let device = all[0]
                result.id = device[id]
                result.type = SPDeviceType(rawValue: device[type])!
                result.serial = device[serial]
                result.name = device[name]
                result.count = device[count]
                result.kNeedAll = device[kNeedAll]
                result.state = SPDeviceState(rawValue: device[state])
                result.kAll = device[kAll]
                result.k = device[k]
                result.e = device[e]
                result.kNeed = device[kNeed]
                result.k1 = device[k1]
                result.sailingConfig.k0 = device[k00]
                result.sailingConfig.k2 = device[k20]
                result.sailingConfig.k3 = device[k30]
                result.sailingConfig.kw = device[kw0]
                result.sailingConfig.load = SPLoad(rawValue: device[load0])!
                result.inOrOutConfig.k0 = device[k01]
                result.inOrOutConfig.k2 = device[k21]
                result.inOrOutConfig.k3 = device[k31]
                result.inOrOutConfig.kw = device[kw1]
                result.inOrOutConfig.load = SPLoad(rawValue: device[load1])!
                result.workingConfig.k0 = device[k02]
                result.workingConfig.k2 = device[k22]
                result.workingConfig.k3 = device[k32]
                result.workingConfig.kw = device[kw2]
                result.workingConfig.load = SPLoad(rawValue: device[load2])!
                result.anchorConfig.k0 = device[k03]
                result.anchorConfig.k2 = device[k23]
                result.anchorConfig.k3 = device[k33]
                result.anchorConfig.kw = device[kw3]
                result.anchorConfig.load = SPLoad(rawValue: device[load3])!
            }
        } catch {
            print("query with error: \(error)")
            assert(false)
        }
        
        return result
    }
    
    public func deviceCount() -> Int {
        var count = 0
        do {
            let all = Array(try db!.prepare(devices))
            count = all.count
        } catch {
            print("device count with error: \(error)")
            assert(false)
        }
        return count
    }
    
    public func export(path: String) {
        var fields = [String]()
        fields.append("序号")
        fields.append("用电设备名称")
        fields.append("数量")
        fields.append("最大机械轴功率")
        fields.append("功率")
        fields.append("效率")
        fields.append("所需功率")
        fields.append("所需总功率")
        fields.append("电动机利用系数")
        fields.append("航行状态k2")
        fields.append("航行状态k3")
        fields.append("航行状态k0")
        fields.append("航行状态有用功率")
        fields.append("航行状态负荷类别")
        fields.append("进出港状态k2")
        fields.append("进出港状态k3")
        fields.append("进出港状态k0")
        fields.append("进出港状态有用功率")
        fields.append("进出港状态负荷类别")
        fields.append("作业状态k2")
        fields.append("作业状态k3")
        fields.append("作业状态k0")
        fields.append("作业状态有用功率")
        fields.append("作业状态负荷类别")
        fields.append("停泊状态k2")
        fields.append("停泊状态k3")
        fields.append("停泊状态k0")
        fields.append("停泊状态有用功率")
        fields.append("停泊状态负荷类别")
        let n = deviceCount()
        var data = [[String : String]]()
        for i in 1...n {
            let device = queryDevice(idNum: Int64(i))
            var item = [String : String]()
            item["序号"] = String(device.id)
            item["用电设备名称"] = String(device.name)
            item["数量"] = String(device.count)
            item["最大机械轴功率"] = String(device.kAll)
            item["功率"] = String(device.k)
            item["效率"] = String(device.e)
            item["所需功率"] = String(device.kNeed)
            item["所需总功率"] = String(device.kNeedAll)
            item["电动机利用系数"] = String(device.k1)
            item["航行状态k2"] = String(device.sailingConfig.k2)
            item["航行状态k3"] = String(device.sailingConfig.k3)
            item["航行状态k0"] = String(device.sailingConfig.k0)
            item["航行状态有用功率"] = String(device.sailingConfig.kw)
            item["航行状态负荷类别"] = String(device.sailingConfig.load.rawValue)
            item["进出港状态k2"] = String(device.inOrOutConfig.k2)
            item["进出港状态k3"] = String(device.inOrOutConfig.k3)
            item["进出港状态k0"] = String(device.inOrOutConfig.k0)
            item["进出港状态有用功率"] = String(device.inOrOutConfig.kw)
            item["进出港状态负荷类别"] = String(device.inOrOutConfig.load.rawValue)
            item["作业状态k2"] = String(device.workingConfig.k2)
            item["作业状态k3"] = String(device.workingConfig.k3)
            item["作业状态k0"] = String(device.workingConfig.k0)
            item["作业状态有用功率"] = String(device.workingConfig.kw)
            item["作业状态负荷类别"] = String(device.workingConfig.load.rawValue)
            item["停泊状态k2"] = String(device.anchorConfig.k2)
            item["停泊状态k3"] = String(device.anchorConfig.k3)
            item["停泊状态k0"] = String(device.anchorConfig.k0)
            item["停泊状态有用功率"] = String(device.anchorConfig.kw)
            item["停泊状态负荷类别"] = String(device.anchorConfig.load.rawValue)
            data.append(item)
        }
        let result = exportCSV("testCSV", fields: fields, values: data)
        print(result)
    }
}

