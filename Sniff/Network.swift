//
//  Network.swift
//  Sniff
//
//  Created by Bharat Mediratta on 8/7/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation

protocol Network {
    func foundHost(host: String)
    func count() -> Int
    func get(index: Int) -> Device
    func reset()
    func update()
    func add(device: Device)
}

class BaseNetwork {
    var devices = [String: Device]()
    var notify: ()->Void

    init(notify: ()->Void) {
        self.notify = notify
    }
    
    func count() -> Int {
        return devices.count
    }
    
    func get(index: Int) -> Device {
        return devices.values.sort()[index]
    }
    
    func reset() {
        devices.removeAll(keepCapacity: true)
    }

    func update() {
        self.notify()
    }
        
    func add(device: Device) {
        if devices[device.host] == nil {
            devices[device.host] = device
            self.notify()
        }
    }
}