
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
    var sonosNetwork: SonosNetwork?
    
    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if sonosNetwork == nil {
            sonosNetwork = SonosNetwork(notify: self.update)
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
        self.sonosNetwork?.reset()
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
            svc.player = sonosNetwork!.getPlayer(path!.row)
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return sonosNetwork!.count()
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Sonos Player Cell")
        cell!.textLabel?.text = sonosNetwork!.getPlayer(indexPath.row).name
        return cell!
    }
}

