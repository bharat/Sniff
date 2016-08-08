//
//  ViewController.swift
//  Sniff
//
//  Created by Bharat Mediratta on 7/29/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController {
    var sonosNetwork: SonosNetwork?
    var player: SonosPlayer?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var hostLabel: UILabel!
    
    @IBAction func reboot(sender: AnyObject) {
        player?.reboot()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = player?.name
        hostLabel.text = player?.host
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

