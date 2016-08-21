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
    
    func title() -> String {
        return "Sonos Devices"
    }
    
    func foundPlayer(msg: String) {
        let player = SonosZonePlayer(notifyMsg: msg)
        
        // We have to load the name before we can insert the player into the table since we display
        // and sort on name.
        player.load({
            // Minimize race conditions
            if self.devices[player.host] == nil {
                print("Found new player \(player.host)")
                self.add(player)
            
                // After we've loaded the name then ask the player to check its topology to see 
                // if it can locate other players and send them back here
                player.discoverOthers(self.foundPlayer)
            }
        })
    }
    
    func accept(msg: String) -> Bool {
        if msg.containsString("ZonePlayer") || msg.containsString("ZPS") {
            print("detected ZonePlayer")
            self.foundPlayer(msg)
            return true
        }

        if msg.containsString("SpeakerGroup") {
            print("detected SpeakerGroup")
            self.add(SonosSpeakerGroup(notifyMsg: msg))
            return true
        }
        return false
    }
}