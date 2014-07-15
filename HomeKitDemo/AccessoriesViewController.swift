//
//  AccessoriesViewController.swift
//  HomeKitDemo
//
//  Created by Frédéric Falliere on 09/07/2014.
//  Copyright (c) 2014 Marcel Falliere. All rights reserved.
//

import UIKit
import HomeKit

class AccessoriesViewController : UITableViewController, UITableViewDataSource, UITableViewDelegate {

    var home :HMHome?
    
    override func viewWillAppear(animated: Bool)  {
        title = "Accessories"
        self.tableView.reloadData()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "details" {
            let dest :AccessoryDetailsViewController = segue.destinationViewController as AccessoryDetailsViewController!
            dest.accessory = sender as? HMAccessory
            dest.home = self.home
        }
    }

}


// pragma mark UITableViewDataSource, UITableViewDelegate

extension AccessoriesViewController {
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        if let accessories = home?.accessories {
            return accessories.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        if let accessories = home?.accessories {
            
            let accessory = accessories[indexPath.row] as HMAccessory
            
            cell.textLabel.text = accessory.name
            cell.detailTextLabel.text = "\(accessory.room.name)"
            
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        performSegueWithIdentifier("details", sender: home?.accessories[indexPath.row])
    }
    
    
    
}