//
//  Unknown.swift
//  Sniff
//
//  Created by Bharat Mediratta on 8/7/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import Regex


class UnknownDevice: Device {
    override init(host: String) {
        super.init(host: host)
        self.host = host
        self.name = "Unknown (\(host))"
    }
}

class UnknownNetwork: BaseNetwork, Network {
    
    func foundHost(host: String) {
        
    }
    
    static func accept(network: Network, msg: String) -> Bool {        
        if let host = Regex("HOST: (.*)").match(msg)?.captures[0] {
            network.add(UnknownDevice(host: host))
            return true
        }
        
        return false
    }
}