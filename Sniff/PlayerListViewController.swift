
//
//  ViewController.swift
//  Sniff
//
//  Created by Bharat Mediratta on 7/29/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PlayerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    var network: Network?
    var ssdp: SSDP?
    
    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if ssdp == nil {
            network = Network(self.update)
            ssdp = SSDP(network: network!)
            ssdp?.beginDiscovery()

            table.delegate = self
            table.dataSource = self
            
            startAnimating()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.reset()
    }
    
    @IBAction func refresh(_ sender: AnyObject) {
        self.reset()
    }
    
    func reset() {
        startAnimating()
        network!.reset()
        table.reloadData()
    }
    
    func update() {
        stopAnimating()
        table.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetails") {
            let svc = segue.destination as! PlayerDetailViewController;
            let path = table.indexPathForSelectedRow
            svc.device = network!.group(path!.section).at(path!.row)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return network!.groupcount()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return network!.group(section).count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Device Cell")
        let selected = network!.group(indexPath.section).at(indexPath.row)

        cell!.textLabel?.text = selected.name
        cell!.detailTextLabel?.text = selected.host
        
        if selected.icon != nil {
            let url = URL(string: selected.icon)
            let data = try? Data(contentsOf: url!)
            cell!.imageView?.image = UIImage(data: data!)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return network!.group(section).name
    }
}

