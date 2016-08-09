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
    var networks = [String: Network]()
    
    init(networks: [String: Network]) {
        self.networks = networks
    }
    
    func beginDiscovery() {
        ssdpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        try! ssdpSocket.bindToPort(multicastPort)
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
            ).dataUsingEncoding(NSUTF8StringEncoding)
        print("Beginning discovery")
        ssdpSocket.sendData(data!, withTimeout: 1, tag: 0)
    }
    
    @objc func udpSocket(sock: GCDAsyncUdpSocket, didReceiveData data: NSData, fromAddress address: NSData, withFilterContext filterContext: AnyObject?) {
        let msg = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        print(msg)
        if msg.containsString("NOTIFY") {
            // See who accepts it, with Unknown last
            if SonosNetwork.accept(networks["SonosNetwork"]!, msg: msg) {
                return
            }
            
            if UnknownNetwork.accept(networks["UnknownNetwork"]!, msg: msg) {
                return
            }
        }
    }
}