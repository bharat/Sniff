
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
    var networks: Networks?
    var ssdp: SSDP?
    
    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if ssdp == nil {
            networks = Networks()
            networks!.add(SonosZonePlayerNetwork(notify: self.update))
            networks!.add(SonosSpeakerGroupNetwork(notify: self.update))
            networks!.add(UnknownNetwork(notify: self.update))
            ssdp = SSDP(networks: networks!)
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
        networks!.reset()
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
            svc.device = networks![path!.section][path!.row]
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var count = 0
        for network in networks! {
            if network.count() > 0 {
                count = count + 1
            }
        }
        return count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networks![section].count()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Device Cell")
        cell!.textLabel?.text = networks![indexPath.section][indexPath.row].name
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return networks![section].title()
    }
}

