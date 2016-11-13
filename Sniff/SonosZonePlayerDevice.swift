//
//  SonosZonePlayerDevice.swift
//  Sniff
//
//  Created by Bharat Mediratta on 7/28/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation
import Alamofire
import CheatyXML

class SonosZonePlayerDevice: BaseDevice {
    static var type = "urn:schemas-upnp-org:device:ZonePlayer:1"
    var data: CXMLParser!
    
    init(host: String!, data: CXMLParser!) {
        super.init()
        
        self.data = data
        self.host = host
        id = data["device"]["UDN"].stringValue
        name = data["device"]["roomName"].stringValue
        self.group = "Sonos Player"
    }
    
    func discoverOthers(_ foundPlayer: @escaping (_ host: String)->Void) {
        /*
        Alamofire.request("http://\(self.host):1400/status/topology")
            .responseString { response in
                if response.result.isSuccess {
                    self.topologyData = CXMLParser(string: response.result.value!)
                    for zp in self.topologyData["ZonePlayers"] {
                        let locationUrl: NSURL? = NSURL(string: zp.attribute("location").stringValue)
                        foundPlayer((locationUrl?.host)!)
                    }
                }
            }
         */
    }
    
    func reboot() {
        print("reboot \(self.name)")
    }
}
