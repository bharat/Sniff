//
//  Networks.swift
//  Sniff
//
//  Created by Bharat Mediratta on 8/9/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation

class Networks: Sequence {
    var networks = [Network]()
    
    func add(_ network: Network) {
        networks.append(network)
    }
    
    func makeIterator() -> IndexingIterator<[Network]> {
        return networks.makeIterator()
    }
    
    func reset() {
        for network in networks {
            network.reset()
        }
    }
    
    func accept(_ msg: String) {
        print("Accept \(msg)")
        for network in networks {
            if network.accept(msg) {
                return
            }
        }
    }
    
    subscript(index:Int) -> Network {
        return networks[index]
    }
}
