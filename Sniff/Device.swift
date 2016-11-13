//
//  Device.swift
//  Sniff
//
//  Created by Bharat Mediratta on 8/7/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//
import CheatyXML

protocol Device {
    var id: String! { get }
    var name: String! { get }
    var host: String! { get }
    var group: String! { get }
    
    func discover(_ found: @escaping (_ url: String) -> Void)
}

class BaseDevice: Device {
    var id: String!
    var name: String!
    var host: String!
    var group: String!
    
    func discover(_ found: @escaping (_ url: String) -> Void) {
    }
}

class UnknownDevice: BaseDevice {
    init(_ data: CXMLParser!) {
        super.init()
        
        self.id = data["device"]["UDN"].stringValue
        self.name = data["device"]["deviceType"].string
        if self.name == nil {
            self.name = "Unknown"
        }
        self.host = "Unknown"
        self.group = "Unknown"
    }
}

class DeviceFactory {
    static func create(host: String!, data: CXMLParser!) -> Device {
        let deviceType = data["device"]["deviceType"].stringValue

        switch(deviceType) {
        case SonosZonePlayerDevice.type:
            return SonosZonePlayerDevice(host: host, data: data)
            
        case SonosSpeakerGroupDevice.type:
            return SonosSpeakerGroupDevice(host: host, data: data)
            
        case RouterDevice.type:
            return RouterDevice(host: host, data: data)

        default:
            return UnknownDevice(data)
        }
    }
}
