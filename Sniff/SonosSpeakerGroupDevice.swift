//
//  SonosSpeakerGroupDevice.swift
//  Sniff
//
//  Created by Bharat Mediratta on 8/10/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation
import Alamofire
import CheatyXML

class SonosSpeakerGroupDevice: BaseDevice {
    static var type = "urn:smartspeaker-audio:device:SpeakerGroup:1"
    var data: CXMLParser!
    
    init(host: String!, data: CXMLParser!) {
        super.init()
        
        self.data = data
        self.host = host
        id = data["device"]["UDN"].stringValue
        name = data["device"]["friendlyName"].string
        if name == nil {
            name = "(Blank)"
        }
        self.group = "Sonos Speaker Group"
    }

    
    func load(success: @escaping () -> Void) {
        // The name of the player is the only required field so do that in init() before
        // we notify the network that we have a new player
        /*
        let locationUrl = "http://\(host):1400/xml/group_description.xml"
        Alamofire.request(locationUrl).responseString { response in
            if !response.result.isFailure {
                self.playerData = CXMLParser(string: response.result.value!)
                self.name = self.playerData["device"]["friendlyName"].stringValue
                success()
            }
        }
        */
    }
}
