//
//  USBDeviceManager.swift
//  USBDeviceSwift
//
//  Created by Artem Hruzd on 6/12/17.
//  Copyright © 2017 Artem Hruzd. All rights reserved.
//

import Cocoa

public struct VIDPID {
    public let vendorId:UInt16
    public let productId:UInt16
    
    public init (vendorId:UInt16, productId:UInt16) {
        self.vendorId = vendorId
        self.productId = productId
    }
}

public protocol USBDeviceDelegate: NSObjectProtocol {
    func usbConnected(_ device:USBDevice)
    func usbDisconnected(_ device:USBDevice)
}

open class USBDeviceManager<T:USBDevice>: NSObject {
    typealias Device = T
    public let vp:[VIDPID]
    public var devices:[T] = []
    public var delegateUSBDevice:USBDeviceDelegate?
    
    public init(_ vp:[VIDPID]) {
        self.vp = vp
    }
    
    open func add(id:UInt64, vendorId:UInt16, productId:UInt16, deviceName:String = "Unnamed USB Device") -> T {
        let device = T(id:id, vendorId: vendorId, productId: productId, deviceName: deviceName)
        self.devices.append(device)
        self.delegateUSBDevice?.usbConnected(device)
        return device
    }
    
    open func remove(id:UInt64) -> T? {
        if let index = self.devices.index(where: { $0.id == id }) {
            let device = self.devices.remove(at: index)
            self.delegateUSBDevice?.usbDisconnected(device)
            return device
        }
        return nil
    }
    
}