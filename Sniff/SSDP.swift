//
//  SSDP.swift
//  Sniff
//
//  Created by Bharat Mediratta on 8/7/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import Regex

class SSDP: GCDAsyncUdpSocketDelegate {
    var multicastGroup          = "239.255.255.250"
    var multicastPort: UInt16   = 1900
    var ssdpSocket: GCDAsyncUdpSocket!
    var networks: Networks
    
    init(networks: Networks) {
        self.networks = networks
    }
    
    func beginDiscovery() {
        ssdpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        try! ssdpSocket.bind(toPort: multicastPort)
        try! ssdpSocket.beginReceiving()
        try! ssdpSocket.enableBroadcast(true)
        try! ssdpSocket.joinMulticastGroup(multicastGroup)
        
        // Use "ST: ssdp:all" to see all devices
        let data = (
            "M-SEARCH * HTTP/1.1\r\n" +
                "HOST: 239.255.255.250\r\n" +
                "MAN: \"ssdp:discover\"\r\n" +
                "MX: 2\r\n" +
                "ST: ssdp:all\r\n" +
                "USER-AGENT: Sniff/1.0\r\n" +
            "\r\n"
            ).data(using: String.Encoding.utf8)
        print("Beginning discovery")
        ssdpSocket.send(data!, withTimeout: 1, tag: 0)
    }
    
    @objc func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: AnyObject?) {
        let msg = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
        print (msg)
        if msg.contains("NOTIFY") {
            networks.accept(msg)
        }
    }
}
