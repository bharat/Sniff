//
//  SonosSpeakerGroup.swift
//  Sniff
//
//  Created by Bharat Mediratta on 8/10/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation
import Alamofire
import CheatyXML

class SonosSpeakerGroup: Device {
    var playerData: CXMLParser!
    var topologyData: CXMLParser!
    
    override init(notifyMsg: String) {
        super.init(notifyMsg: notifyMsg)
        self.name = "\(self.name) (SpeakerGroup)"
    }
    
    override func load(success: @escaping () -> Void) {
        // The name of the player is the only required field so do that in init() before
        // we notify the network that we have a new player
        let locationUrl = "http://\(host):1400/xml/group_description.xml"
        Alamofire.request(locationUrl).responseString { response in
            if !response.result.isFailure {
                self.playerData = CXMLParser(string: response.result.value!)
                self.name = self.playerData["device"]["friendlyName"].stringValue
                success()
            }
        }
    }
}
