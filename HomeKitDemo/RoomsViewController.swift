//
//  RoomsViewController.swift
//  HomeKitDemo
//
//  Created by Frédéric Falliere on 08/07/2014.
//  Copyright (c) 2014 Marcel Falliere. All rights reserved.
//

import UIKit
import HomeKit

class RoomsViewController : UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var home :HMHome?
    var pickerMode = false
    var accessoryViewController :AccessoryDetailsViewController?
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let dest = segue.destinationViewController as? RoomDetailsViewController {
            dest.room = sender as? HMRoom
            dest.home = home
        }
    }
}


// pragma mark UITableViewDataSource, UITableViewDelegate

extension RoomsViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let rooms = home?.rooms {
            return rooms.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        if let rooms = home?.rooms {
            
            let room = rooms[indexPath.row] as HMRoom
            
            cell.textLabel?.text = room.name
            
            if let accessoriesOfCurrentRoom :[AnyObject] = room.accessories {
                cell.detailTextLabel?.text = "Number of accessories : \(accessoriesOfCurrentRoom.count)"
            } else {
                cell.detailTextLabel?.text = "No accessories :("
            }
        
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if pickerMode {
            accessoryViewController?.setPickedRoom(home?.rooms[indexPath.row] as HMRoom)
            dismissViewControllerAnimated(true, completion: nil)

        } else {
            performSegueWithIdentifier("details", sender: home?.rooms[indexPath.row])
        }

    }
    
    
    
    
}