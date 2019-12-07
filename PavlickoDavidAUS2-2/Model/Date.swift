//
//  Date.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 07/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

public class Date: Record {
    
    var _day: UInt8
    var _month: UInt8
    var _year: UInt16
    
    init(_ day: UInt8, _ month: UInt8, _ year: UInt16) {
        
        if (day < 1 || day > 30) {
            self._day = 1
        } else {
            self._day = day
        }
        
        if (month < 1 || month > 12) {
            self._month = 1
        } else {
            self._month = month
        }
        
        if (year < 1970) {
            self._year = 1970
        } else {
            self._year = year
        }
    }
    
    init() {
        self._day = 1
        self._month = 1
        self._year = 1970
    }
    
    public func getSize() -> Int {
        return day.size + month.size + year.size
    }
    
    var day: UInt8 {
        get {
            return self._day
        }
    }
    
    var month: UInt8 {
        get {
            return self._month
        }
    }
    
    var year: UInt16 {
        get {
            return self._year
        }
    }
    
    func toBytes() -> [UInt8] {
        
        var result: [UInt8] = [UInt8]()
        
        result.append(day)
        result.append(month)
        
        let yearBytes = Helper.shared.decimalStringToUInt8Array(String(year), year.size)
        for byte in yearBytes {
            result.append(byte)
        }
        
        return result
    }
    
    func fromBytes(bytes: [UInt8]) -> Any {
        
        var idBytes: [UInt8] = []
        
        let day = UInt8(bytes[0])
        let month = UInt8(bytes[1])
        
        for i in 1...year.size {
            idBytes.append(bytes[i - 1 + day.size + month.size])
        }
        let year = UInt16(Helper.shared.uInt8ArrayToDecimalString(idBytes))
        
        return Date(day, month, year!) as Any
    }
    
    func initEmpty() -> Any {
        return Date() as Any
    }
    
    func toString() -> String {
        return "\(day)-\(month)-\(year)"
    }
    
    func isEmpty() -> Bool {
        if (day == 1 && month == 1 && year == 1970) {
            return true
        }
        return false
    }
    
    
    
    
}
