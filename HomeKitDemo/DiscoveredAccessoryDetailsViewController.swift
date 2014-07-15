//
//  AccessoryDetailsViewController.swift
//  HomeKitDemo
//
//  Created by Frédéric Falliere on 08/07/2014.
//  Copyright (c) 2014 Marcel Falliere. All rights reserved.
//

import UIKit
import HomeKit

class DiscoveredAccessoryDetailsViewController : UIViewController {

    let homeManager = HMHomeManager()
    
    strong var accessory :HMAccessory?

    @IBOutlet var labelName :UILabel
    @IBOutlet var reachable :UILabel
    @IBOutlet var roomName :UILabel
    
    override func viewWillAppear(animated: Bool) {
        labelName.text = accessory?.name

        if let room = accessory?.room {
            roomName.text = accessory?.room.name
        } else {
            roomName.text = "room not set"
        }
        
        if accessory?.reachable {
            reachable.text = "Accessory reachable !"
        } else {
            reachable.text = "This accessory is out of range, turned off, etc"
        }

    }
    
    @IBAction func buttonTapped(sender : AnyObject) {
        var home = homeManager.primaryHome
        if (homeManager.homes.count > 0) {
            home = homeManager.homes[0] as HMHome
        }
        
        NSLog("accessory : \(accessory)")
        NSLog("home : \(home)")
        
        if (home) {
            home.addAccessory(accessory, completionHandler: ({(error:NSError!) in
                if error {
                    var popup = UIAlertView(title:"Error", message:"Error when adding accessory to primary home (error is : \(error)", delegate: nil, cancelButtonTitle:"Ok :(")
                    popup.show()
                    
                    NSLog("error: \(error)")
                } else {

                    var popup = UIAlertView(title:"Ok", message:"Accessory had been added to your primary home", delegate: nil, cancelButtonTitle:"Ok :(")
                    popup.show()
                                    }
            }))
        } else {
            let error = UIAlertView(title: "Can't do !", message: "You did not set up your primary home", delegate: nil, cancelButtonTitle:"Ok")
            error.show()
        
        }
    }
    
}
