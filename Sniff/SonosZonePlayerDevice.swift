//
//  SonosZonePlayerDevice.swift
//  Sniff
//
//  Created by Bharat Mediratta on 7/28/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//
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
    
    override func discover(_ found: @escaping (_ url: String) -> Void) {
        let topoUrl = "http://\(self.host!):1400/status/topology"
        print("Requesting topology from \(topoUrl)")
        
        Alamofire.request(topoUrl).responseString { response in
            if response.result.isSuccess {
                let topo = CXMLParser(string: response.result.value!)
                for zp in (topo?["ZonePlayers"])! {
                    let url = zp.attribute("location").stringValue
                    print("Located peer \(url)")
                    found(url)
                }
            }
        }
    }
    
    func reboot() {
        print("reboot \(self.name)")
    }
}
