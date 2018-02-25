//
//  MicroBitService.swift
//  PaperCompany
//
//  Created by satorupan on 2018/02/13.
//  Copyright © 2018年 satorupan. All rights reserved.
//

import Foundation
import CoreBluetooth

enum MicroBitService {
    case button
    case accelerometer
    case ioPin
    case led
    case magnetometer
    case temperature
    case uart
    case eventService
    
    
    func uuid() -> CBUUID {
        switch self {
        case .button:
            return CBUUID(string: "E95D9882-251D-470A-A062-FA1922DFA9A8")
        case .accelerometer:
            return CBUUID(string: "E95D0753-251D-470A-A062-FA1922DFA9A8")
        case .ioPin:
            return CBUUID(string: "E95D127B-251D-470A-A062-FA1922DFA9A8")
        case .led:
            return CBUUID(string: "E95Dd91D-251D-470A-A062-FA1922DFA9A8")
        case .magnetometer:
            return CBUUID(string: "E95DF2D8-251D-470A-A062-FA1922DFA9A8")
        case .temperature:
            return CBUUID(string: "E95D6100-251D-470A-A062-FA1922DFA9A8")
        case .uart:
            return CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
        case .eventService:
            return CBUUID(string: "")
        }
    }
    
    func characteristics() -> [CBUUID] {
        switch self {
        case .button:
            return [
                ButtonCharacteristic.button1State.uuid(),
                ButtonCharacteristic.button2State.uuid()
            ]
        case .accelerometer:
            return [
                AccelerometerCharacteristic.data.uuid(),
                AccelerometerCharacteristic.period.uuid(),
            ]
        case .ioPin:
            return [
                IoPinCharacteristic.pinData.uuid(),
                IoPinCharacteristic.pinAdConfiguration.uuid(),
                IoPinCharacteristic.pinIoConfiguration.uuid()
            ]
        case .led:
            return [
                LedCharacteristic.matrixState.uuid(),
                LedCharacteristic.text.uuid(),
                LedCharacteristic.scrollingDelay.uuid()
            ]
        case .magnetometer:
            return [
                MagnetometerCharacteristic.data.uuid(),
                MagnetometerCharacteristic.period.uuid(),
                MagnetometerCharacteristic.bearing.uuid()
            ]
        case .temperature:
            return [
                TemperatureCharacteristic.temperature.uuid()
            ]
        case .uart:
            return [
                UartCharacteristic.rx.uuid(),
                UartCharacteristic.tx.uuid()
            ]
        case .eventService:
            return [
            ]
        }
    }
    
    private enum AccelerometerCharacteristic: String {
        case data   = "E95DCA4B-251D-470A-A062-FA1922DFA9A8"
        case period = "E95DFB24-251D-470A-A062-FA1922DFA9A8"
        
        func uuid() -> CBUUID {
            return CBUUID(string: self.rawValue)
        }
    }
    
    private enum ButtonCharacteristic: String {
        case button1State = "E95DDA90-251D-470A-A062-FA1922DFA9A8"
        case button2State = "E95DDA91-251D-470A-A062-FA1922DFA9A8"
        
        func uuid() -> CBUUID {
            return CBUUID(string: self.rawValue)
        }
    }
    
    private enum IoPinCharacteristic: String {
        case pinData            = "E95D8D00-251D-470A-A062-FA1922DFA9A8"
        case pinAdConfiguration = "E95DDA90-251D-470A-A062-FA1922DFA9A8"
        case pinIoConfiguration = "E95DDA91-251D-470A-A062-FA1922DFA9A8"
        
        func uuid() -> CBUUID {
            return CBUUID(string: self.rawValue)
        }
    }
    
    private enum LedCharacteristic: String {
        case matrixState    = "E95D7b77-251D-470A-A062-FA1922DFA9A8"
        case text           = "E95D93EE-251D-470A-A062-FA1922DFA9A8"
        case scrollingDelay = "E95D0d2d-251D-470A-A062-FA1922DFA9A8"
        
        func uuid() -> CBUUID {
            return CBUUID(string: self.rawValue)
        }
    }
    
    private enum MagnetometerCharacteristic: String {
        case data    = "E95Dfb11-251D-470A-A062-FA1922DFA9A8"
        case period  = "E95D386C-251D-470A-A062-FA1922DFA9A8"
        case bearing = "E95D9715-251D-470A-A062-FA1922DFA9A8"
        
        func uuid() -> CBUUID {
            return CBUUID(string: self.rawValue)
        }
    }
    
    private enum TemperatureCharacteristic: String {
        case temperature = "E95D9250-251D-470A-A062-FA1922DFA9A8"
        
        func uuid() -> CBUUID {
            return CBUUID(string: self.rawValue)
        }
    }
    
    private enum UartCharacteristic: String {
        case rx = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
        case tx = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
        
        func uuid() -> CBUUID {
            return CBUUID(string: self.rawValue)
        }
    }
    
    private enum EventServiceCharacteristic: String {
        case microbitRequirements = "E95DB84C-251D-470A-A062-FA1922DFA9A8";
        case microbitEvent        = "E95D9775-251D-470A-A062-FA1922DFA9A8";
        case clientRequirements   = "E95D23C4-251D-470A-A062-FA1922DFA9A8";
        case clientEvent          = "E95D5404-251D-470A-A062-FA1922DFA9A8";
        
        func uuid() -> CBUUID {
            return CBUUID(string: self.rawValue)
        }
    }
}
