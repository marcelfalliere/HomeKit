//
//  AccessoryDetailViewController.swift
//  HomeKitDemo
//
//  Created by Frédéric Falliere on 09/07/2014.
//  Copyright (c) 2014 Marcel Falliere. All rights reserved.
//

import UIKit
import HomeKit

class AccessoryDetailsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, HMAccessoryDelegate {
    
    @IBOutlet var accessoryName :UILabel?
    
    @IBOutlet var roomName :UILabel?
    
    @IBOutlet var reachable :UILabel?
    
    @IBOutlet var tableView :UITableView?
    
    var accessory :HMAccessory?
    var home :HMHome?
    
    override func viewWillAppear(animated: Bool)  {
        title = accessory?.name;
        
        render()
        
        if let mAccessory = self.accessory {
            mAccessory.delegate = self
        }
    }
    
    @IBAction func changeName(sender: AnyObject!) {
        var alert = UIAlertController(title: "Change name", message: "Input a new name for this accessory", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: ({(alertAction: UIAlertAction!) in
            
            if let textFields:[AnyObject]! = alert.textFields as [AnyObject]! {
            
                for textField in textFields {
                    if let input = textField as? UITextField {
                        if input.tag == 1 {
                            self.accessory?.updateName(input.text, completionHandler:({(error:NSError!) in
                                if (error != nil) {
                                    NSLog("error updating acccessory name. error:\(error)")
                            } else {
                                    NSLog("name update !")
                                self.render()
                            }
                            }))
                        }
                }
            }
                
            }
            
            }))
        alert.addAction(action)
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Accessory name"
            textField.secureTextEntry = false
            textField.tag = 1
            })
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func render() {
        NSLog("render !")
        
        accessoryName?.text = accessory?.name
        roomName?.text = accessory?.room.name
        reachable?.text = accessory?.reachable == true ? "Reachable !" : "Accessory not reachable"
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "characteristics" {
            if let dest = segue.destinationViewController as? CharacteristicsViewController {
                dest.service = sender as? HMService
            }

        } else if segue.identifier == "pickRoom" {
            if let dest = segue.destinationViewController as? RoomsViewController {
                dest.home = self.home
                dest.pickerMode = true
                dest.accessoryViewController = self
            }
            
        }
    }
    
    
    func setPickedRoom(room: HMRoom) {
        NSLog("room has been picked")
        
        
        home?.assignAccessory(accessory, toRoom: room, completionHandler: ({(error:NSError!) in
            if (error != nil) {
                var popup = UIAlertView(title:"Error", message:"Error when assigning the accessory to the picked room (error is : \(error)", delegate: nil, cancelButtonTitle:"Ok :(")
                popup.show()
            } else {
                var popup = UIAlertView(title:"Ok", message:"Accessory added to room \(room.name) with success!", delegate: nil, cancelButtonTitle:"Ok")
                popup.show()

            }
        }))
        
    }
    
    
}


// pragma mark HMAccessoryDelegate
extension AccessoryDetailsViewController {
    
    func accessoryDidUpdateName(accessory: HMAccessory!) {
        render()
    }
    
    func accessoryDidUpdateReachability(accessory: HMAccessory!)  {
        render()
    }
    
    func accessoryDidUpdateServices(accessory: HMAccessory!) {
        tableView?.reloadData()
    }
    
    
}


// pragma mark UITableViewDataSource, UITableViewDelegate

extension AccessoryDetailsViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let services = accessory?.services {
            return services.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("service-cell", forIndexPath: indexPath) as UITableViewCell
        
        if let services = accessory?.services {
            
            let service = services[indexPath.row] as HMService
            
            cell.textLabel?.text = "\(service.name)"
            cell.detailTextLabel?.text = "\(service.characteristics.count) characteristics"
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("characteristics", sender: accessory?.services[indexPath.row])
        
    }
    
    
}