//
//  CarVin.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 07/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

class CarVIN: Record {
    
    private var _heapAddress: UInt64
    private var _vin: String
    private var _vinCount: UInt8
    
    init(_ address: UInt64?, _ vin: String) {
        if (address != nil) {
            self._heapAddress = address!
        } else {
            self._heapAddress = UInt64.max
        }
        self._vin = vin
        self._vinCount = UInt8(vin.count > vin.maxCarVIN ? vin.maxCarVIN : vin.count)
    }
    
    init() {
        self._heapAddress = UInt64.max
        self._vin = ""
        self._vinCount = 0
    }
    
    var heapAddress: UInt64 {
        get {
            return self._heapAddress
        }
    }
    
    var vin: String {
        get {
            return self._vin
        }
    }
    
    var vinCount: UInt8 {
        get {
            return self._vinCount
        }
    }
    
    public func setAddress(_ address: UInt64) -> UInt64 {
        self._heapAddress = address
        return heapAddress
    }
    
    func toBytes() -> [UInt8] {
        
        var result: [UInt8] = [UInt8]()
        
        let addressBytes = Helper.shared.decimalStringToUInt8Array(String(heapAddress), heapAddress.size)
        for byte in addressBytes {
            result.append(byte)
        }
        
        result.append(vinCount)
        let temp = Data(vin.utf8)
        for char in temp {
            result.append(UInt8(char))
        }
        
        var emptyBytes = vin.maxCarVIN - Int(vinCount)
        while emptyBytes > 0 {
            result.append(UInt8.max)
            emptyBytes -= 1
        }
        
        return result
    }
    
    func fromBytes(bytes: [UInt8]) -> Any {
        
        var addressBytes: [UInt8] = []
        for i in 1...heapAddress.size {
            addressBytes.append(bytes[i - 1])
        }
        let address = UInt64(Helper.shared.uInt8ArrayToDecimalString(addressBytes))!
        
        var carVIN: String = ""
        var i = 0
        let idCount = bytes[address.size]
        while i < idCount {
            carVIN += String(Character(UnicodeScalar(Int(bytes[i + idCount.size + address.size]))!))
            i += 1
        }
        
        return CarVIN(address, carVIN) as Any
    }
    
    func getSize() -> Int {
        return heapAddress.size + vin.maxCarVIN + vinCount.size
    }
    
    func initEmpty() -> Any {
        return CarVIN() as Any
    }
    
    func toString() -> String {
        var address = "Not set"
        if (heapAddress != UInt64.max) {
            address = "\(heapAddress)"
        }
        return "Adresa: \(address), VIN: \(vin)"
    }
    
    func isEmpty() -> Bool {
        if (heapAddress == UInt64.max && vin == "" && vinCount == 0) {
            return true
        }
        return false
    }
    
    static let comparator: Comparator = {
        lhs, rhs in guard let first = lhs as? CarVIN, let second = rhs as? CarVIN else {
            return ComparisonResult.orderedSame
        }
        
        if (first.vin == second.vin) {
            return ComparisonResult.orderedSame
        } else if ((first.vin < second.vin) || (second.vin == "")) {
            return ComparisonResult.orderedAscending
        } else {
            return ComparisonResult.orderedDescending
        }
    }
}
