//
//  Network.swift
//  Sniff
//
//  Created by Bharat Mediratta on 8/7/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Alamofire
import CheatyXML

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
    var seen = Set<String>()
    var groups = [String: NetworkGroup]()
    var notify: ()->Void

    init(_ notify: @escaping ()->Void) {
        self.notify = notify
    }
    
    func reset() {
        groups.removeAll(keepingCapacity: true)
        seen.removeAll(keepingCapacity: true)
    }
    
    func groupcount() -> Int {
        return groups.count
    }
    
    func group(_ index: Int) -> NetworkGroup {
        // Sorting every time is easy but inefficient
        return groups.values.sorted(by: {$0.name < $1.name})[index]
    }
    
    func add(_ url: String!) {
        if seen.contains(url) {
            // print("Already seen \(url)")
            return
        }
        
        let host = URL(string: url)?.host
        
        print("Retrieving \(url)")
        seen.insert(url)
        Alamofire.request(url).responseString { response in
            if response.result.isFailure {
                self.seen.remove(url)
                print("Error retrieving \(url)")
            } else {
                let deviceData = CXMLParser(string: response.result.value!)
                let device = DeviceFactory.create(host: host, data: deviceData)

                if self.groups[device.group] == nil {
                    self.groups[device.group] = NetworkGroup(device.group)
                }
                self.groups[device.group]!.add(device)
                self.notify()
                
                device.discover(self.add)
            }
        }
    }
}
