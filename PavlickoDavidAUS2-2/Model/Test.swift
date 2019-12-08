//
//  Test.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 23/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

public class Test: Record {
    
    var _value: UInt32
    
    init(_ value: UInt32) {
        self._value = value
    }
    
    init() {
        self._value = UInt32.max
    }
    
    var value: UInt32 {
        return self._value
    }
    
    func toBytes() -> [UInt8] {
        return value.toBytes
    }
    
    func fromBytes(bytes: [UInt8]) -> Any {
        return Test(UInt32(Helper.shared.uInt8ArrayToDecimalString(bytes))!)
    }
    
    func getSize() -> Int {
        return value.size
    }
    
    func getKeyToString() -> String {
        return "\(value)"
    }
    
    func toString() -> String {
        return "\(value)"
    }
    
    func compare() -> Any {
        return value
    }
    
    static let comparator: Comparator = {
        lhs, rhs in guard let first = lhs as? Test, let second = rhs as? Test else {
            return ComparisonResult.orderedSame
        }
        
        if (first.value == second.value) {
            return ComparisonResult.orderedSame
        } else if (first.value < second.value) {
            return ComparisonResult.orderedAscending
        } else {
            return ComparisonResult.orderedDescending
        }
    }
    
    func isEmpty() -> Bool {
        
        if (value == UInt32.max) {
            return true
        }
        return false
    }
    
    func initEmpty() -> Any {
        return Test() as Any
    }
    
    func initRandom() -> Any {
        return Test(UInt32.random(in: 1...UInt32.max/2))
    }
    
}
