//
//  ObellaDevice.swift
//  Bluetooth Test
//
//  Created by Adam Wheeler on 6/23/15.
//  Copyright (c) 2015 AdamWheeler. All rights reserved.
//

import Foundation
import CoreBluetooth

//Device Name
let deviceName = "Obella"
var dataFromSensor = ""

//Service UUIDs
let HeartRateServiceUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
let DeviceInformationUUID = CBUUID(string: "0000180A-0000-1000-8000-00905F9B34FB")

//Characteristic UUIDs
let HeartRateCharacteristicUUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
let HeartRateConfigUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")

class ObellaBE
{
    
    // Check name of device from advertisement data
    class func deviceNameFound (advertisementData: [NSObject : AnyObject]!) -> Bool
    {
        let nameOfDeviceFound = (advertisementData as NSDictionary).objectForKey(CBAdvertisementDataLocalNameKey) as? NSString
        return (nameOfDeviceFound == deviceName)
    }
    
    // Check to see if the service has a valid UUID
    class func validService (service : CBService) -> Bool
    {
        //println(HeartRateServiceUUID == service.UUID) //print the Boolean of comparing each UUID to our constants
        if service.UUID == HeartRateServiceUUID || service.UUID == DeviceInformationUUID
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    // Check if the characteristic has a valid data UUID
    class func validDataCharacteristic (characteristic : CBCharacteristic) -> Bool
    {
        if characteristic.UUID == HeartRateCharacteristicUUID
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    // Check if the characteristic has a valid config UUID
    class func validConfigCharacteristic (characteristic : CBCharacteristic) -> Bool
    {
        if characteristic.UUID == HeartRateConfigUUID
            {
                return true
            }
        else
            {
                return false
            }
    }
    
    //THIS MAY NEED CHANGING 6/28/2015
    class func getHeartRate(value : NSData) -> NSString
    {
        //println(value)
        dataFromSensor = NSString(data: value, encoding: NSUTF8StringEncoding)! as String
        //print(dataFromSensor)
        return dataFromSensor
    }
}