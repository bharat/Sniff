//
//  Sonos.swift
//  Sniff
//
//  Created by Bharat Mediratta on 7/28/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import Regex
import SwiftLoader

class SonosNetwork: GCDAsyncUdpSocketDelegate {
    var multicastGroup          = "239.255.255.250"
    var multicastPort: UInt16   = 1900
    var ssdpSocket: GCDAsyncUdpSocket!
    var players = [String: SonosPlayer]()
    var table: UITableView!
    
    init(table: UITableView) {
        self.table = table
        
        // players.insert(MockSonosPlayer(network: self))
        beginDiscovery()
    }
    
    func count() -> Int {
        return players.count
    }
    
    func getPlayer(index: Int) -> SonosPlayer {
        return players.values.sort()[index]
    }
    
    func update() {
        SwiftLoader.hide()
        self.table.reloadData()
    }
    
    func foundPlayer(host: String) {
        if players[host] != nil {
            return
        }
        print("Found player \(host)")
    
        let player = SonosPlayer(network: self, host: host)
        
        // We have to load the name before we can insert the player into the table since we display
        // and sort on name.
        player.getName({
            self.players[host] = player
            self.update()
            
            // After we've loaded the name then see if we can find other players
            player.checkTopology()
        })
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
            "ST: urn:schemas-upnp-org:device:ZonePlayer:1\r\n" +
            "USER-AGENT: Sniff/1.0\r\n" +
            "\r\n"
        ).dataUsingEncoding(NSUTF8StringEncoding)
        print("Beginning discovery")
        ssdpSocket.sendData(data!, withTimeout: 1, tag: 0)
    }
    
    @objc func udpSocket(sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        print("sent data with tag: ", tag)
    }
    
    @objc func udpSocket(sock: GCDAsyncUdpSocket, didReceiveData data: NSData, fromAddress address: NSData, withFilterContext filterContext: AnyObject?) {
        // print("received response")
        let msg = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        if msg.containsString("NOTIFY") {
            // print("received notify: \(msg)")
            if msg.containsString("ZonePlayer") {
                print("detected ZonePlayer")
                if let urlString = Regex("LOCATION: (.*)").match(msg)?.captures[0] {
                    if let url = NSURL(string: urlString) {
                        self.foundPlayer(url.host!)
                    }
                }
            }
        }
    }
}