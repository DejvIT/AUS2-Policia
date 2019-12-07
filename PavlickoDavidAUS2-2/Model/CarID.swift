//
//  CarID.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 07/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

class CarID: Record {
    
    private var _heapAddress: UInt64
    private var _id: String
    private var _idCount: UInt8
    
    init(_ address: UInt64?, _ id: String) {
        if (address != nil) {
            self._heapAddress = address!
        } else {
            self._heapAddress = UInt64.max
        }
        self._id = id
        self._idCount = UInt8(id.count > id.maxCarID ? id.maxCarID : id.count)
    }
    
    init() {
        self._heapAddress = UInt64.max
        self._id = ""
        self._idCount = 0
    }
    
    var heapAddress: UInt64 {
        get {
            return self._heapAddress
        }
    }
    
    var id: String {
        get {
            return self._id
        }
    }
    
    var idCount: UInt8 {
        get {
            return self._idCount
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
        
        result.append(idCount)
        let temp = Data(id.utf8)
        for char in temp {
            result.append(UInt8(char))
        }
        
        var emptyBytes = id.maxCarID - Int(idCount)
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
        
        var carID: String = ""
        var i = 0
        let idCount = bytes[address.size]
        while i < idCount {
            carID += String(Character(UnicodeScalar(Int(bytes[i + idCount.size + address.size]))!))
            i += 1
        }
        
        return CarID(address, carID) as Any
    }
    
    func getSize() -> Int {
        return heapAddress.size + id.maxCarID + idCount.size
    }
    
    func initEmpty() -> Any {
        return CarID() as Any
    }
    
    func toString() -> String {
        var address = "Not set"
        if (heapAddress != UInt64.max) {
            address = "\(heapAddress)"
        }
        return "Adresa: \(address), EČV: \(id)"
    }
    
    func isEmpty() -> Bool {
        if (heapAddress == UInt64.max && id == "" && idCount == 0) {
            return true
        }
        return false
    }
    
    static let comparator: Comparator = {
        lhs, rhs in guard let first = lhs as? CarID, let second = rhs as? CarID else {
            return ComparisonResult.orderedSame
        }
        
        if (first.id == second.id) {
            return ComparisonResult.orderedSame
        } else if ((first.id < second.id) || (second.id == "")) {
            return ComparisonResult.orderedAscending
        } else {
            return ComparisonResult.orderedDescending
        }
    }
}
