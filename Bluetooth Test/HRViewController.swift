//
//  ViewController.swift
//  Bluetooth Test
//
//  Created by Adam Wheeler on 6/23/15.
//  Copyright (c) 2015 AdamWheeler. All rights reserved.
//

import UIKit
import CoreBluetooth

class HRViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate
{
    
    //Setup UI labels in storyboard
    @IBOutlet weak var deviceNameLabel: UILabel!
//    @IBOutlet weak var deviceService: UILabel!
//    @IBOutlet weak var deviceCharacteristic: UILabel!
//    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!

    
    @IBAction func backButton() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //BLE variables
    var centralManager: CBCentralManager!
    var devicePeripheral: CBPeripheral!
//    var systolicString = String()
//    var diastolicString = String()
//    var measuredHeartRateString = String()
    
    let HeartRateServiceUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    
    //Misc Variables

    override func viewDidLoad()
    {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /******* CBCentralManagerDelegate *******/
    
    // Check status of BLE hardware
    func centralManagerDidUpdateState(central: CBCentralManager)
    {
        if central.state == CBCentralManagerState.PoweredOn {
            // Scan for peripherals if BLE is turned on
            central.scanForPeripheralsWithServices(nil, options: nil)
            //self.statusLabel.text = "Searching for BLE Devices"
        }
        else {
            // Can have different conditions for all states if needed - show generic alert for now
            //self.statusLabel.text = "Bluetooth Not Enabled"
        }
    }

    // Check out the discovered peripherals to find a matching name (i.e 'Obella')
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber)
    {
        
        if ObellaBE.deviceNameFound(advertisementData) == (true)
        {
            //self.statusLabel.text = "Obella BE Found"
            deviceNameLabel.text = "Obella BE"
            
            // Stop scanning, set as the peripheral to use and establish connection
            self.centralManager.stopScan()
            self.devicePeripheral = peripheral
            self.devicePeripheral.delegate = self
            self.centralManager.connectPeripheral(peripheral, options: nil)
        }
        else
        {
            //self.statusLabel.text = "Obella BE NOT Found"
        }
        
//*********Blood Pressure Testing
        print("\(BloodPressureDevice.deviceNameFound)", appendNewline: false) //check to see if BP name is found or not
        if BloodPressureDevice.deviceNameFound(advertisementData) == (true)
        {
            //self.statusLabel.text = "BP Cuff Found"
            self.deviceNameLabel.text = "BP Cuff"

        
        //Stop scanning and connect to the peripheral
        self.centralManager.stopScan()
        self.devicePeripheral = peripheral
        self.devicePeripheral.delegate = self
        self.centralManager.connectPeripheral(peripheral, options: nil)
        }
        else
        {
            //self.statusLabel.text = "Device Not Found"
        }
    }
    
// Discover services of the peripheral
        func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral)
        {
            //self.statusLabel.text = "Discovering peripheral services"
            peripheral.discoverServices(nil)
    }
    
// If disconnected, start searching again
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?)
    {
        //self.statusLabel.text = "-"
        deviceNameLabel.text = "-"
        //deviceCharacteristic.text = "-"
        heartRateLabel.text = "-"
        //deviceService.text = "-"
        central.scanForPeripheralsWithServices(nil, options: nil)
    }
    
/******* CBCentralPeripheralDelegate *******/
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?)
    {
        //self.statusLabel.text = "Looking at peripheral services"
        
        for service in peripheral.services!
        {
            let thisService = service //as! CBService
            
            //deviceService.text = String(stringInterpolationSegment: service.UUID) //Print Service UUID for connected device
            if ObellaBE.validService(thisService)
            {
                //deviceService.text = "HR Service Found"
                
                // Discover characteristics of all valid services
                peripheral.discoverCharacteristics(nil, forService: thisService)
            }
            else if BloodPressureDevice.validService(thisService)
            {
                //deviceService.text = "Blood Pressure"
                
                //Discover characteristic of all valid services
                peripheral.discoverCharacteristics(nil, forService: thisService)
            }
            else
            {
                //deviceService.text = "Service Not Found"
            }
        }
    }
    
// Enable notification and sensor for each characteristic of valid service
        func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?)
    {
            
            //self.statusLabel.text = "Enabling sensors"
        
            var enableValue = 1
            let enablyBytes = NSData(bytes: &enableValue, length: sizeof(UInt8))
            
            for charateristic in service.characteristics!
            {
                let thisCharacteristic = charateristic
                //Obella Code
                if ObellaBE.validDataCharacteristic(thisCharacteristic)
                {
                    // Enable Sensor Notification
                    self.devicePeripheral.setNotifyValue(true, forCharacteristic: thisCharacteristic)
                    print("Enable Sensor Notification")
                    
                }
                if ObellaBE.validConfigCharacteristic(thisCharacteristic)
                {
                    // Enable Sensor
                    self.devicePeripheral.writeValue(enablyBytes, forCharacteristic: thisCharacteristic, type: CBCharacteristicWriteType.WithResponse)
                }
                
                //Blood Pressure Code
                if BloodPressureDevice.validDataCharacteristic(thisCharacteristic)
                {
                    // Enable Sensor Notification
                    self.devicePeripheral.setNotifyValue(true, forCharacteristic: thisCharacteristic)
                    print("Enabling Sensor Notification")
                    //deviceCharacteristic.text = "Blood Pressure Char"
                }
                if BloodPressureDevice.validConfigCharacteristic(thisCharacteristic)
                {
                    self.devicePeripheral.writeValue(enablyBytes, forCharacteristic: thisCharacteristic, type: CBCharacteristicWriteType.WithResponse)
                }
            }
    }
    
        // Get data values when they are updated
        func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?)
        {
            
            //self.statusLabel.text = "Connected"
            
            if characteristic.UUID == HeartRateCharacteristicUUID
            {
                print(characteristic.UUID == HeartRateCharacteristicUUID)
                //println("\n", characteristic.value)
                ObellaBE.getHeartRate(characteristic.value!)
                //println("\n", dataFromSensor)
                heartRateLabel.text = dataFromSensor
            }
                
            else if characteristic.UUID == bloodPressureCharacteristicUUID
            {
                //println("\(characteristic.value)")
                BloodPressureDevice.getBloodPressure(characteristic.value!)
                print("The value of systolic is: \(systolic) and diastolic is: \(diastolic)")
                //systolicLabel.text = systolic
                //diastolicLabel.text = diastolic
                heartRateLabel.text = measuredHeartRate
            }
        }
}