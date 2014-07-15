//
//  CharactericsViewController.swift
//  HomeKitDemo
//
//  Created by Frédéric Falliere on 09/07/2014.
//  Copyright (c) 2014 Marcel Falliere. All rights reserved.
//

import UIKit
import HomeKit

class CharacteristicsViewController : UITableViewController, UITableViewDelegate, UITableViewDataSource {

    
    var service :HMService?
    
    override func viewWillAppear(animated: Bool)  {
        title = service?.name
        
        var i = 0
        while i < service?.characteristics.count {
            let ch :HMCharacteristic = self.service?.characteristics[i] as HMCharacteristic
            NSLog("charact type : \(ch.characteristicType) ; value->\(ch.value)")
            i++
        }
    }
}

extension CharacteristicsViewController {
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        if let characteristics = service?.characteristics {
            NSLog("rows : \(characteristics.count)")
            return characteristics.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let ch :HMCharacteristic = self.service?.characteristics[indexPath.row] as HMCharacteristic
        
        if ch.characteristicType == HMCharacteristicTypePowerState {
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("public.hap.characteristic.on", forIndexPath: indexPath) as UITableViewCell
            
            // ...
            
            let button:UIButton = cell.viewWithTag(10) as UIButton
            button.addTarget(self, action:"cellButtonTapped:", forControlEvents:UIControlEvents.TouchUpInside)
            
            return cell
            
        } else if ch.characteristicType == HMCharacteristicTypeSaturation || ch.characteristicType == HMCharacteristicTypeBrightness  {
            
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("slider100percent", forIndexPath: indexPath) as UITableViewCell
            
            let name:UILabel = cell.viewWithTag(10) as UILabel
            name.text = ch.characteristicType
            let slider:UISlider = cell.viewWithTag(20) as UISlider
            slider.addTarget(self, action:"slider100percentValueChanged:", forControlEvents:UIControlEvents.ValueChanged)
            
            return cell
            
            
            
        }  else if ch.characteristicType == HMCharacteristicTypeHue  {
            
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("hueCell", forIndexPath: indexPath) as UITableViewCell
            
            let name:UILabel = cell.viewWithTag(10) as UILabel
            name.text = ch.characteristicType
            let slider:UISlider = cell.viewWithTag(20) as UISlider
            slider.addTarget(self, action:"slider100percentValueChanged:", forControlEvents:UIControlEvents.ValueChanged)
            
            return cell
            
        } else {
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
            
            let name:UILabel = cell.viewWithTag(10) as UILabel
            name.text = ch.characteristicType
            let value:UILabel = cell.viewWithTag(20) as UILabel
            value.text = "\(ch.value)"
            
            return cell
            
        }
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 60;
    }
    
    func cellButtonTapped(sender :AnyObject!) {
        let buttonPosition :CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath :NSIndexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
        let ch :HMCharacteristic = self.service?.characteristics[indexPath.row] as HMCharacteristic
        
        if ch.characteristicType == HMCharacteristicTypePowerState {
            let value :Bool = ch.value as Bool!
            ch.writeValue(!value , completionHandler: ({(error :NSError!) in
                NSLog("Ok, error:\(error)")
            }))
        }
        
    }
    
    func slider100percentValueChanged(sender :AnyObject!) {
        let buttonPosition :CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath :NSIndexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
        let ch :HMCharacteristic = self.service?.characteristics[indexPath.row] as HMCharacteristic
        
        let slider :UISlider = sender as UISlider
        
        ch.writeValue(Int(slider.value), completionHandler: ({(error :NSError!) in
            NSLog("Ok, error:\(error)")
        }))
        
    }
    

}
