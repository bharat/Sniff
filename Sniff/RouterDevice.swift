//
//  RouterDevice.swift
//  Sniff
//
//  Created by Bharat Mediratta on 8/10/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//
import CheatyXML

class RouterDevice: BaseDevice {
    static var type = "urn:schemas-upnp-org:device:InternetGatewayDevice:1"
    var data: CXMLParser!
    
    init(_ host: String!, _ data: CXMLParser!) {
        super.init()
        
        self.data = data
        self.host = host
        id = data["device"]["UDN"].stringValue
        name = data["device"]["friendlyName"].string
        if name == nil {
            name = "(Blank)"
        }
        self.group = "Routers"
    }
}
