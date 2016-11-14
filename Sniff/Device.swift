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
    var type: String! { get }
    var icon: String! { get }
    
    func discover(_ found: @escaping (_ url: String) -> Void)
    func action(_ name: String!) -> Void
}

class BaseDevice: Device {
    var id: String!
    var name: String!
    var host: String!
    var type: String!
    var icon: String!
    
    func discover(_ found: @escaping (_ url: String) -> Void) {
    }

    func action(_ name: String!) -> Void {
    }
}

class UnknownDevice: BaseDevice {
    init(_ host: String!, _ data: CXMLParser!) {
        super.init()
        
        self.id = data["device"]["UDN"].stringValue
        self.name = data["device"]["deviceType"].string
        if self.name == nil {
            self.name = "Unknown"
        }
        self.host = host
        self.type = "Unknown Device"
    }
}

class DeviceFactory {
    static func create(host: String!, data: CXMLParser!) -> Device {
        let schema = data["device"]["deviceType"].stringValue

        switch(schema) {
        case SonosZonePlayerDevice.schema:
            return SonosZonePlayerDevice(host, data)
            
        case SonosSpeakerGroupDevice.schema:
            return SonosSpeakerGroupDevice(host, data)
            
        case RouterDevice.schema:
            return RouterDevice(host, data)

        default:
            return UnknownDevice(host, data)
        }
    }
}
