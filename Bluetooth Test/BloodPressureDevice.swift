//
//  BloodPressureDevice.swift
//  Bluetooth Test
//
//  Created by Adam Wheeler on 7/12/15.
//  Copyright (c) 2015 AdamWheeler. All rights reserved.
//

import Foundation
import CoreBluetooth

let bloodPressureDeviceName = "A&D_UA-651BLE_86C6BC"

var systolicInt = UInt8(0)
var diastolicInt = UInt8(0)
var measuredHearRateInt = UInt8(0)

var systolic = ""
var diastolic = ""
var measuredHeartRate = ""

//Service UUIDs
let bloodPressureServiceUUID = CBUUID(string:"00001810-0000-1000-8000-00805F9B34FB")

//Characteristic UUIDs
let bloodPressureCharacteristicUUID = CBUUID(string:"00002A35-0000-1000-8000-00805F9B34FB")

//Config UUIDs
let bloodPressureConfigUUID = CBUUID(string:"0000180A-0000-1000-8000-00805F9B34FB")

class BloodPressureDevice
{
    // Check name of device from advertisement data
    class func deviceNameFound (advertisementData: [NSObject : AnyObject]!) -> (Bool)
    {
        let nameOfDeviceFound = (advertisementData as NSDictionary).objectForKey(CBAdvertisementDataLocalNameKey) as? NSString
        print("\(nameOfDeviceFound)")
        print("The value of deviceFound is: \(nameOfDeviceFound == bloodPressureDeviceName)")
        return(nameOfDeviceFound == bloodPressureDeviceName)
    }
    
    // Check to see if the service has a valid UUID
    class func validService (service : CBService) -> Bool
    {
        //print the Boolean of comparing each UUID to our constants
        if service.UUID == bloodPressureServiceUUID
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
        if characteristic.UUID == bloodPressureCharacteristicUUID
        {
            print("is charUUID == BPCharUUID?: \(characteristic.UUID == bloodPressureCharacteristicUUID)")
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
        if characteristic.UUID == bloodPressureConfigUUID
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    class func getBloodPressure(value : NSData) -> (NSString, NSString, NSString) //NSString
    {
        print(value)
        
        //NEW CODE
        let dataDescription = value.description
        print("Description is: \(dataDescription)")
        
        value.getBytes(&systolicInt, range: NSMakeRange(1, 1))
        value.getBytes(&diastolicInt, range: NSMakeRange(3,1))
        value.getBytes(&measuredHearRateInt, range: NSMakeRange(14, 1))
        
        systolic = String(systolicInt)
        diastolic = String(diastolicInt)
        measuredHeartRate = String(measuredHearRateInt)
        print("The value of systolicString in getBloodPressure is: \(systolic)")
        print("The value of diastolicString in getBloodPressure is: \(diastolic)")
        return(systolic, diastolic, measuredHeartRate)
    }
}
