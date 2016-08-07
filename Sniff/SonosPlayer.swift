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

func ==(lhs: SonosPlayer, rhs: SonosPlayer) -> Bool {
    return lhs.name == rhs.name
}

func <(lhs: SonosPlayer, rhs: SonosPlayer) -> Bool {
    return lhs.name < rhs.name
}

class SonosPlayer: Comparable, Hashable {
    var name: String!
    var host: String!
    var playerData: XMLParser!
    var topologyData: XMLParser!
    var network: SonosNetwork!

    init(network: SonosNetwork, host: String) {
        self.network = network
        self.host = host
    }
    
    func getName(success: () -> Void) {
        // The name of the player is the only required field so do that in init() before
        // we notify the network that we have a new player
        let locationUrl = "http://\(host):1400/xml/device_description.xml"
        Alamofire.request(.GET, locationUrl).responseString { response in
            if !response.result.isFailure {
                self.playerData = XMLParser(string: response.result.value!)
                self.name = self.playerData["device"]["roomName"].stringValue
                success()
            }
        }
    }
    
    func checkTopology() {
        Alamofire.request(.GET, "http://\(self.host):1400/status/topology")
            .responseString { response in
                if response.result.isSuccess {
                    self.topologyData = XMLParser(string: response.result.value!)
                    for zp in self.topologyData["ZonePlayers"] {
                        let locationUrl = NSURL(string: zp.attributes["location"] as! String)
                        self.network.foundPlayer((locationUrl?.host)!)
                    }
                }
            }
    }
    
    func reboot() {
        print("reboot \(self.name)")
    }
    
    var hashValue: Int {
        return self.host.hashValue
    }    
}
