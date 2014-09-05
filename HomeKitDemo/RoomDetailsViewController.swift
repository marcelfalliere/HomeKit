//
//  RoomDetailsViewController.swift
//  HomeKitDemo
//
//  Created by Frédéric Falliere on 08/07/2014.
//  Copyright (c) 2014 Marcel Falliere. All rights reserved.
//

import UIKit
import HomeKit

class RoomDetailsViewController : UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var mainHomeName :UILabel?
    
    var room :HMRoom?
    var home :HMHome?
    
    override func viewDidLoad()  {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool)  {
        title = room?.name
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "details" {
            
            if let dest = segue.destinationViewController as? AccessoryDetailsViewController {
                dest.accessory = sender as? HMAccessory
                dest.home = home
            }
            
        }
    }
    
}



// pragma mark UITableViewDataSource, UITableViewDelegate

extension RoomDetailsViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let accessories = room?.accessories {
            return accessories.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        if let accessories = room?.accessories {
            
            let accessory = accessories[indexPath.row] as HMAccessory
            
            cell.textLabel?.text = accessory.name
        }
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("details", sender: room?.accessories[indexPath.row])
    }
    
}