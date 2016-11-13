//
//  SonosPlayer.swift
//  Sniff
//
//  Created by Bharat Mediratta on 7/28/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation
import Alamofire
import CheatyXML

class SonosZonePlayer: Device {
    var playerData: CXMLParser!
    var topologyData: CXMLParser!
    
    override init(notifyMsg: String) {
        super.init(notifyMsg: notifyMsg)
        self.name = "\(self.name) (ZonePlayer)"
    }
    
    override func load(success: @escaping () -> Void) {
        // The name of the player is the only required field so do that in init() before
        // we notify the network that we have a new player
        let locationUrl = "http://\(host):1400/xml/device_description.xml"
        Alamofire.request(locationUrl).responseString { response in
            if !response.result.isFailure {
                self.playerData = CXMLParser(string: response.result.value!)
                self.name = self.playerData["device"]["roomName"].stringValue
                success()
            }
        }
    }
    
    func discoverOthers(_ foundPlayer: @escaping (_ host: String)->Void) {
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
    }
    
    func reboot() {
        print("reboot \(self.name)")
    }
}
