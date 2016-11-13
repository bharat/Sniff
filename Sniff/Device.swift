//
//  Device.swift
//  Sniff
//
//  Created by Bharat Mediratta on 8/7/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation
import Regex

class Device {
    var name: String!
    var host: String!
    var description: String!
    var notifyMsg: String!

    init(notifyMsg: String) {
        self.notifyMsg = notifyMsg
        if let urlString = Regex("LOCATION: (.*)").match(notifyMsg)?.captures[0] {
            if let url: URL = URL(string: urlString) {
                self.host = url.host
            }
        }
        self.description = Regex("SERVER: (.*)").match(notifyMsg)?.captures[0]
        self.name = host
    }
    
    func load(success: @escaping () -> Void) {
    }
    
    func discoverOthers() {
    }
}

