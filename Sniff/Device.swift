//
//  Device.swift
//  Sniff
//
//  Created by Bharat Mediratta on 8/7/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation

func ==(lhs: Device, rhs: Device) -> Bool {
    return lhs.name == rhs.name
}

func <(lhs: Device, rhs: Device) -> Bool {
    return lhs.name < rhs.name
}

class Device: Equatable, Hashable, Comparable {
    var name: String!
    var host: String!

    init(host: String) {
        self.name = host
        self.host = host
    }
    
    func load(success: () -> Void) {
        assert(false, "must be overridden")
    }
    
    func discoverOthers() {
        assert(false, "must be overridden")
    }

    var hashValue: Int {
        return self.host.hashValue
    }
}

