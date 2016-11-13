//
//  Network.swift
//  Sniff
//
//  Created by Bharat Mediratta on 8/7/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation

class NetworkGroup {
    var name: String!
    var devices = [Device]()
    
    init(_ name: String) {
        self.name = name
    }
    
    func add(_ device: Device) {
        devices.append(device)
    }
    
    func at(_ index: Int) -> Device {
        return devices[index]
    }
    
    func count() -> Int {
        return devices.count
    }
}

class Network {
    var devices = [String: Device]()
    var groups = [NetworkGroup]()
    var notify: ()->Void

    init(_ notify: @escaping ()->Void) {
        self.notify = notify
    }
    
    func reset() {
        devices.removeAll(keepingCapacity: true)
        groups.removeAll(keepingCapacity: true)
    }
    
    func groupcount() -> Int {
        return groups.count
    }
    
    func group(_ index: Int) -> NetworkGroup {
        return groups[index]
    }

    func add(_ device: Device) {
        if devices[device.id] == nil {
            devices[device.id] = device
            
            var inserted = false
            for g in groups {
                if g.name == device.group {
                    g.add(device)
                    inserted = true
                    break
                }
            }
            
            if !inserted {
                let group = NetworkGroup(device.group)
                groups.append(group)
                group.add(device)
            }
            notify()
        }
    }
}
