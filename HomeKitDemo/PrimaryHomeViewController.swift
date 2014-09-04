//
//  SecondViewController.swift
//  HomeKitDemo
//
//  Created by Frédéric Falliere on 08/07/2014.
//  Copyright (c) 2014 Marcel Falliere. All rights reserved.
//

import UIKit
import HomeKit

class PrimaryHomeViewController: UIViewController {
    
    let homeManager = HMHomeManager()
    
    @IBOutlet var mainHomeName :UILabel?
    @IBOutlet var numberOfRooms :UILabel?
    @IBOutlet var numberOfAccessories :UILabel?
    
    @IBOutlet var listOfRoomsButton :UIButton?
    @IBOutlet var listOfAccessoriesButton :UIButton?
    
    override func viewWillAppear(animated: Bool) {
       updateUi()
    }
    
    func updateUi() {
        NSLog("primary home : \(homeManager.primaryHome) count:\(homeManager.homes.count)")
        if (homeManager.primaryHome) {
            mainHomeName?.text = homeManager.primaryHome.name
            
            numberOfRooms?.text = "\(homeManager.primaryHome.rooms.count) rooms"
            listOfRoomsButton?.enabled = homeManager.primaryHome.rooms.count > 0
            
            numberOfAccessories?.text = "\(homeManager.primaryHome.accessories.count) accessories"
            listOfAccessoriesButton?.enabled = homeManager.primaryHome.accessories.count > 0
        } else {
            mainHomeName?.text = "n/a"
            self.presentPrimaryHomePromp()
        }
    }
    
    func setOrUpdatePrimaryHomeName(name:String!) {
        NSLog("primary home : \(homeManager.primaryHome)")
        if (homeManager.primaryHome) {
            homeManager.primaryHome.updateName(name, completionHandler:({(error:NSError!) in
                if error {
                    NSLog("error updating home: \(error)")
                } else {
                    NSLog("no error, home name updated")
                    self.updateUi()
                }
            }))

        } else {
            homeManager.addHomeWithName(name, completionHandler:({(home:HMHome!, error:NSError!) in
                if error {
                    NSLog("error creating home: \(error)")
                } else {
                    
                    NSLog("no error, home created")
                    
                    self.homeManager.updatePrimaryHome(home, completionHandler:({(error:NSError!) in
                        NSLog("primary home set ! ")
                        self.updateUi()
                    }))

                    

                }
            }))
        }
        
    }
    
    func saveNewRoomToPrimaryHome(name:String!) {
        homeManager.primaryHome.addRoomWithName(name, completionHandler: ({(room:HMRoom!, error:NSError!) in
            if error {
                NSLog("error creating room: \(error)")
            } else {
                NSLog("no error, home created")
                self.updateUi()
            }
        }))

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "rooms" {
            let dest :RoomsViewController = segue.destinationViewController as RoomsViewController!
            dest.home = homeManager.primaryHome
            dest.pickerMode = false
        }
        
        if segue.identifier == "accessories" {
            let dest :AccessoriesViewController = segue.destinationViewController as AccessoriesViewController!
            dest.home = homeManager.primaryHome
        }
        
    }
    
    func presentPrimaryHomePromp() {
        var alert = UIAlertController(title: "Primary Home", message: "Pick a name for your primary home ! (Yes, with iOS8, having a home is as simple as picking a name >.<)", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: ({(alertAction: UIAlertAction!) in
            for textField in alert.textFields {
                if let input = textField as? UITextField {
                    if input.tag == 1 {
                        self.setOrUpdatePrimaryHomeName(input.text)
                    }
                }
            }
            
            }))
        alert.addAction(action)
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Home name"
            textField.secureTextEntry = false
            textField.tag = 1
            })
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    @IBAction func changeName(sender : AnyObject) {
        presentPrimaryHomePromp()
    }
    
    @IBAction func addRoom(sender : AnyObject) {
        var alert = UIAlertController(title: "Add a room", message: "Pick a name for yournew room.", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: ({(alertAction: UIAlertAction!) in
            for textField in alert.textFields {
                if let input = textField as? UITextField {
                    if input.tag == 1 {
                        self.saveNewRoomToPrimaryHome(input.text)
                    }
                }
            }
            
            }))
        alert.addAction(action)
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Room name"
            textField.secureTextEntry = false
            textField.tag = 1
            })
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

