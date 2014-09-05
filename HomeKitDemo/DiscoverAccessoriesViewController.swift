//
//  DiscoverAccessoriesViewController.swift
//  HomeKitDemo
//
//  Created by Frédéric Falliere on 08/07/2014.
//  Copyright (c) 2014 Marcel Falliere. All rights reserved.
//

import UIKit
import HomeKit

class DiscoverAccessoriesViewController : UITableViewController, UITableViewDataSource,UITableViewDelegate, HMAccessoryBrowserDelegate {
    
    let accessoryBrowser = HMAccessoryBrowser()
    let homeManager = HMHomeManager()
    var accessories: [HMAccessory] = []
    
    override func viewDidLoad()  {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(animated: Bool) {
        accessoryBrowser.delegate = self
        accessoryBrowser.startSearchingForNewAccessories()
    }
    
    override func viewDidDisappear(animated: Bool) {
        accessoryBrowser.stopSearchingForNewAccessories()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        /*if let dest = segue.destinationViewController as? AccessoryDetailsViewController {
            dest.accessory = sender as HMAccessory
        }*/
        
    }
    
    func localAccessoriesContains(discoveredAccessory: HMAccessory!) -> Bool {
        for accessory in accessories {
            let aid:String = accessory.identifier.UUIDString
            let daid:String = discoveredAccessory.identifier.UUIDString
            NSLog("comparing \(aid) and \(daid)")
            if accessory.identifier.UUIDString == discoveredAccessory.identifier.UUIDString || accessory.name == discoveredAccessory.name {
                return true
            }
        }
        return false
    }
    
    func removeFromLocalAccessories(accessoryToRemove: HMAccessory!) {
        var indexToRemove = -1
        for (index,accessory) in enumerate(accessories) {
            if accessory.identifier.UUIDString == accessoryToRemove.identifier.UUIDString || accessory.name == accessoryToRemove.name {
                indexToRemove = index
            }
        }
        if indexToRemove >= 0 {
            accessories.removeAtIndex(indexToRemove)
        }
    }
    
}

// pragma mark HMAccessoryBrowserDelegate

extension DiscoverAccessoriesViewController {
    
    func accessoryBrowser(browser: HMAccessoryBrowser!, didFindNewAccessory accessory: HMAccessory!) {
        if !localAccessoriesContains(accessory) {
            accessories.append(accessory);
            tableView.reloadData()
            NSLog("new accessory found")
        };
        
    }
    
    func accessoryBrowser(browser: HMAccessoryBrowser!, didRemoveNewAccessory accessory: HMAccessory!) {
        removeFromLocalAccessories(accessory)
        tableView.reloadData()
    }
    
}

// pragma mark UITableViewDataSource, UITableViewDelegate

extension DiscoverAccessoriesViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return accessories.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = accessories[indexPath.row].name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        homeManager.primaryHome.addAccessory(accessories[indexPath.row] as HMAccessory, completionHandler: ({(error:NSError!) in
            if ( error != nil) {
                var popup = UIAlertView(title:"Error", message:"Error when adding accessory to primary home (error is : \(error)", delegate: nil, cancelButtonTitle:"Ok :(")
                popup.show()
                
                NSLog("error: \(error)")
            } else {
                
                var popup = UIAlertView(title:"Success!", message:"Accessory added with success ! Now go to your home and assign it a room", delegate: nil, cancelButtonTitle:"Ok !!!")
                popup.show()
                
            }
        }))
    }
    
}