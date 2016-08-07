
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
    
    @IBOutlet var sonosPlayersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if sonosNetwork == nil {
            sonosNetwork = SonosNetwork(table: sonosPlayersTableView)
            sonosPlayersTableView.delegate = self
            sonosPlayersTableView.dataSource = self
            
            SwiftLoader.show(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetails") {
            let svc = segue.destinationViewController as! PlayerDetailViewController;
            let path = sonosPlayersTableView.indexPathForSelectedRow
            svc.player = sonosNetwork!.getPlayer(path!.row)
        }
    }

}

