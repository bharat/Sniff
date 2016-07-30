//
//  Sonos.swift
//  Sniff
//
//  Created by Bharat Mediratta on 7/28/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class SonosNetwork: GCDAsyncUdpSocketDelegate {
    var ssdpAddress          = "239.255.255.250"
    var ssdpPort: UInt16     = 1900
    var ssdpSocket: GCDAsyncUdpSocket!
    var sonosPlayers = [String: SonosPlayer]()
    
    init() {
        ssdpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        broadcast()
        
        for tuple in [["Dining Room", "10.0.0.1"], ["Living Room", "10.0.0.2"], ["Office", "10.0.0.3"]] {
            sonosPlayers[tuple[0]] = SonosPlayer(name: tuple[0], ipAddr: tuple[1])
        }
    }
    
    func count() -> Int {
        return sonosPlayers.count
    }
    
    func getPlayer(index: Int) -> SonosPlayer {
        let sortedKeys = sonosPlayers.keys.sort()
        let name = sortedKeys[index]
        return sonosPlayers[name]!
    }
    
    func broadcast() {
        try! ssdpSocket.bindToPort(ssdpPort)
        try! ssdpSocket.beginReceiving()
        try! ssdpSocket.enableBroadcast(true)
        try! ssdpSocket.joinMulticastGroup(ssdpAddress)
        
        // Use "ST: ssdp:all" to see all devices
        let data = (
            "M-SEARCH * HTTP/1.1\r\n" +
            "HOST: 239.255.255.250:1900\r\n" +
            "MAN: ssdp:discover\r\n" +
            "MX: 3\r\n" +
            "ST: urn:schemas-upnp-org:device:ZonePlayer:1\r\n" +
            "USER-AGENT: Sniff/1.0\r\n" +
            "\r\n"
        ).dataUsingEncoding(NSUTF8StringEncoding)
        print("Sending data!")
        ssdpSocket.sendData(data!, withTimeout: 1, tag: 0)
    }
    
    @objc func udpSocket(sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        print("sent data with tag: ", tag)
    }
    
    @objc func udpSocket(sock: GCDAsyncUdpSocket, didReceiveData data: NSData, fromAddress address: NSData, withFilterContext filterContext: AnyObject?) {
        print("received response")
        let msg = NSString(data: data, encoding: NSUTF8StringEncoding)
        print(msg)
        let reg: NSRegularExpression = try! NSRegularExpression(pattern: "http:\\/\\/([0-9\\.]*)", options: NSRegularExpressionOptions(rawValue: 0))
        let match: NSTextCheckingResult? = reg.firstMatchInString(
            msg as! String,
            options: NSMatchingOptions(rawValue: 0),
            range: NSMakeRange(0, (msg?.length)!))
        
        if (match != nil) {
            let host = msg?.substringWithRange((match?.range)!)
            print("Host: ", host!)
        }
    }
}