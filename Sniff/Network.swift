//
//  Network.swift
//  Sniff
//
//  Created by Bharat Mediratta on 8/7/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation

protocol Network {
    func title() -> String
    func count() -> Int
    func reset()
    func update()
    func add(_ device: Device)
    func accept(_ msg: String) -> Bool
    subscript(index:Int) -> Device { get }
}

class BaseNetwork {
    var devices = [String: Device]()
    var notify: ()->Void

    init(notify: @escaping ()->Void) {
        self.notify = notify
    }
    
    func count() -> Int {
        return devices.count
    }
    
    subscript(index:Int) -> Device {
        return devices.values.sorted()[index]
    }
    
    func reset() {
        devices.removeAll(keepingCapacity: true)
    }

    func update() {
        self.notify()
    }
        
    func add(_ device: Device) {
        if devices[device.host] == nil {
            devices[device.host] = device
            self.notify()
        }
    }
}
