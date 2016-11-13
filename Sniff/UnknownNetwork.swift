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
    override init(notifyMsg msg: String) {
        super.init(notifyMsg: msg)
        self.host = host
        self.name = "Unknown (\(host))"
    }
}

class UnknownNetwork: BaseNetwork, Network {
    
    func title() -> String {
        return "Unidentified Devices"
    }
    
    func foundHost(_ host: String) {
        assert(false)
    }
    
    func accept(_ msg: String) -> Bool {
        self.add(UnknownDevice(notifyMsg: msg))
        return true
    }
}
