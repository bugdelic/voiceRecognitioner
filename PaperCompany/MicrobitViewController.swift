//
//  MicrobitViewController.swift
//  PaperCompany
//
//  Created by satorupan on 2018/02/13.
//  Copyright © 2018年 satorupan. All rights reserved.
//

import UIKit
import CoreBluetooth
class MicrobitViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
//class MicrobitViewController: UIViewController {
    let manager: CBCentralManager = CBCentralManager()
    var peripherals: [CBPeripheral] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tappedScan(_ sender: Any) {
        if manager.isScanning {
            debugPrint("stop scan")
            manager.stopScan()
        } else {
            debugPrint("scan start")
            manager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    @IBAction func tappedDisconnect(_ sender: Any) {
        peripherals.forEach { (peripheral) in
            manager.cancelPeripheralConnection(peripheral)
        }
    }
    
    // MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        debugPrint(#function)
        var stateString = ""
        switch central.state {
        case .poweredOff:
            stateString = "powerOff"
        case .poweredOn:
            stateString = "powerOn"
        case .resetting:
            stateString = "resetting"
        case .unauthorized:
            stateString = "unauthorized"
        case .unknown:
            stateString = "unknown"
        case .unsupported:
            stateString = "unsupported"
        }
        debugPrint("central state: \(stateString)")
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        debugPrint("\(#function), peripheral: \(peripheral.name)")
        peripheral.discoverServices([MicroBitService.button.uuid()])
        //        peripheral.discoverServices(nil)
    }
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        debugPrint(#function)
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        debugPrint("\(#function), pripheral: \(peripheral.name)")
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        debugPrint("\(#function), peripheral: \(peripheral.name)")
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //        debugPrint(#function)
        if peripheral.name?.range(of: "micro:bit") != nil{
            debugPrint("didDiscover, peripheral: \(peripheral.name)")
            if peripherals.filter({ (keepedPeripheral) -> Bool in
                return keepedPeripheral.identifier == peripheral.identifier ? true : false
            }).count == 0 {
                peripherals.append(peripheral)
                peripheral.delegate = self
            }
            manager.connect(peripheral, options: nil)
        }
    }
    
    // MARK: - CBPeripheralDelegate
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        debugPrint(#function)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        debugPrint(#function)
        peripheral.services?.forEach({ (service) in
            debugPrint("ServiceUUID: \(service.uuid)")
            peripheral.discoverCharacteristics(MicroBitService.button.characteristics(), for: service)
            //            peripheral.discoverCharacteristics(nil, for: service)
        })
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        debugPrint(#function)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        debugPrint(#function)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        debugPrint(#function)
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        debugPrint(#function)
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        debugPrint(#function)
        service.characteristics?.forEach({ (characteristic) in
            debugPrint("CharacteristicUUID: \(characteristic.uuid)")
            peripheral.setNotifyValue(true, for: characteristic)
            //            peripheral.readValue(for: characteristic)
        })
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        debugPrint(#function)
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        debugPrint(#function)
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        debugPrint("\(#function): \(characteristic.value)")
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        debugPrint(#function)
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        debugPrint(#function)
    }
}
