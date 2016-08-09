
//
//  ViewController.swift
//  Sniff
//
//  Created by Bharat Mediratta on 7/29/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import UIKit
import SwiftLoader

class PlayerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var networks = [String: Network]()
    var ssdp: SSDP?
    
    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if ssdp == nil {
            networks["SonosNetwork"] = SonosNetwork(notify: self.update)
            networks["UnknownNetwork"] = UnknownNetwork(notify: self.update)
            ssdp = SSDP(networks: networks)
            ssdp?.beginDiscovery()

            table.delegate = self
            table.dataSource = self
            
            SwiftLoader.show(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.reset()
    }
    
    @IBAction func refresh(sender: AnyObject) {
        self.reset()
    }
    
    func reset() {
        SwiftLoader.show(animated: true)
        for network in networks.values {
            network.reset()
        }
        table.reloadData()
    }
    
    func update() {
        SwiftLoader.hide()
        table.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetails") {
            let svc = segue.destinationViewController as! PlayerDetailViewController;
            let path = table.indexPathForSelectedRow
            svc.player = (networks["SonosNetwork"]!.get(path!.row) as! SonosPlayer)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var count = 0
        for network in networks.values {
            if network.count() > 0 {
                count = count + 1
            }
        }
        return count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return networks["SonosNetwork"]!.count()
            
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Device Cell")
        switch indexPath.section {
        case 0:
            cell!.textLabel?.text = networks["SonosNetwork"]!.get(indexPath.row).name
            
        default:
            break
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Sonos Players"
            
        case 1:
            return "Unknown"
            
        default:
            return nil
        }
    }
}

