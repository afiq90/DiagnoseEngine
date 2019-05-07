//
//  DiagnosingEngine.swift
//  HealthCheck-Modularization
//
//  Created by Afiq Hamdan on 07/05/2019.
//  Copyright © 2019 amtrust. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation
import UIKit

public class DiagnosingEngine: NSObject {
    
    private var bluetoothManager: CBCentralManager!
    private var locationManager: CLLocationManager!
    
    public var bluetoothBool: Bool = false
    public var gpsBool: Bool = false
    private let currentDevice = UIDevice.current
    
    public static let shared = DiagnosingEngine()
    
    public override init() {}
    
    public func deviceInfo() -> String {
        let deviceModelName = currentDevice.model+currentDevice.name
        return deviceModelName
    }
    
    public func isBluetoothWorking() {
        bluetoothManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    public func isGPSWorking() {
        locationManager = CLLocationManager()
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    public func isWifiWorking() -> Bool {
        return false
    }
    
    public func isBatteryWorking() -> Bool {
        
        let state: Int = currentDevice.batteryState.rawValue
        
        print("battery status is \(state)") // 0 unknown, 1 unplugged, 2 charging, 3 full
        
        if state == 0 {
            return false
        } else {
            return true
        }
    }
    
}

// extension for bluetooth manager
extension DiagnosingEngine: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("start scan")
        
        if central.state == .poweredOn {
            bluetoothBool = true
        } else {
            bluetoothBool = false
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("bluetoothBool"), object: nil)
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered \(String(describing: peripheral.name)) at \(RSSI)")
    }
    
}

// extension for location manager
extension DiagnosingEngine: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location manager update started")
        gpsBool = true
        
        NotificationCenter.default.post(name: NSNotification.Name("gpsBool"), object: nil)
        manager.stopUpdatingLocation()
    }
}
