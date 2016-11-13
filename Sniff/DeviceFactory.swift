//
//  Device.swift
//  Sniff
//
//  Created by Bharat Mediratta on 8/7/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation
import Regex
import Alamofire
import CheatyXML

protocol Device {
    var id: String! { get }
    var name: String! { get }
    var host: String! { get }
}

class BaseDevice: Device {
    var id: String!
    var name: String!
    var host: String!
}

class UnknownDevice: BaseDevice {
    
    init(_ data: CXMLParser!) {
        super.init()
        
        self.id = data["device"]["UDN"].stringValue
        self.name = data["device"]["friendlyName"].string
        if self.name == nil {
            self.name = "Unknown"
        }
        self.host = "Unknown"
    }
}

class DeviceFactory {
    
    static func create(_ data: CXMLParser!) -> Device {
        let device: Device? = SonosZonePlayerDevice.create(data)
        if device != nil {
            return device!
        }
        return UnknownDevice(data)
    }
}
