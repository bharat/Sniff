//
//  DeviceData.swift
//  Sniff
//
//  Created by Bharat Mediratta on 8/7/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation
import Regex
import Alamofire
import CheatyXML

class Device {
    var notifyMsg: String!
    var location: URL!
    var name: String!
    var id: String!
    var host: String!
    var deviceData: CXMLParser?

    init(_ notifyMsg: String) {
        self.notifyMsg = notifyMsg
        location = URL(string: (Regex("LOCATION: (.*)").match(notifyMsg)?.captures[0])!)
        
        id = location.absoluteString
        name = "Unknown"
        host = "Unknown"
    }
    
    func load(_ success: @escaping () -> Void) {
        print("Loading: \(location.absoluteString)")
        Alamofire.request(location).responseString { response in
            if !response.result.isFailure {
                self.deviceData = CXMLParser(string: response.result.value!)
                self.name = self.deviceData?["device"]["friendlyName"].string
                success()
            }
        }

    }
}
