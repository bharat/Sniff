//
//  SonosNetwork.swift
//  Sniff
//
//  Created by Bharat Mediratta on 7/28/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import Regex

class SonosNetwork: BaseNetwork, Network {
    
    func foundHost(host: String) {
        let player = SonosPlayer(host: host)
        
        // We have to load the name before we can insert the player into the table since we display
        // and sort on name.
        player.load({
            // Minimize race conditions
            if self.devices[host] == nil {
                print("Found new player \(host)")
                self.add(player)
            
                // After we've loaded the name then ask the player to check its topology to see 
                // if it can locate other players and send them back here
                player.discoverOthers(self.foundHost)
            }
        })
    }
    
    static func accept(network: Network, msg: String) -> Bool {
        if msg.containsString("ZonePlayer") {
            print("detected ZonePlayer")
            if let urlString = Regex("LOCATION: (.*)").match(msg)?.captures[0] {
                if let url = NSURL(string: urlString) {
                    network.foundHost(url.host!)
                    return true
                }
            }
        }
        return false
    }
}