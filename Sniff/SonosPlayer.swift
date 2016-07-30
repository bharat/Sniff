//
//  SonosPlayer.swift
//  Sniff
//
//  Created by Bharat Mediratta on 7/28/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation

func ==(lhs: SonosPlayer, rhs: SonosPlayer) -> Bool {
    return lhs.name == rhs.name
}

class SonosPlayer: Hashable {
    var name: String!
    var ipAddr: String!

    init(name: String, ipAddr: String) {
        self.name = name
        self.ipAddr = ipAddr
    }
    
    var hashValue: Int {
        return self.name.hashValue
    }    
}