//
//  DetailViewController.swift
//  Sniff
//
//  Created by Bharat Mediratta on 7/29/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var sonosNetwork: Network?
    var device: Device?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var hostLabel: UILabel!
    
    @IBAction func reboot(_ sender: AnyObject) {
        device?.action("reboot")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = device?.name
        hostLabel.text = device?.host
        
        navigationItem.title = device?.type
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

