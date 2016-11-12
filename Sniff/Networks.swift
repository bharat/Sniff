//
//  Networks.swift
//  Sniff
//
//  Created by Bharat Mediratta on 8/9/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation

class Networks: SequenceType {
    var networks = [Network]()
    
    func add(network: Network) {
        networks.append(network)
    }
    
    func generate() -> IndexingGenerator<[Network]> {
        return networks.generate()
    }
    
    func reset() {
        for network in networks {
            network.reset()
        }
    }
    
    func accept(msg: String) {
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