//
//  Car.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 02/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

class Car: Record {
    
    private var _id: String
    private var _idCount: UInt8
    private var _vin: String
    private var _vinCount: UInt8
    private var _axlesCount: UInt8
    private var _weight: UInt16
    private var _inSearch: Bool
    private var _dateEndEC: AppDate
    private var _dateEndTC: AppDate
    
    init(id: String, vin: String, axles: UInt8, weight: UInt16, inSearch: Bool, endEC: AppDate, endTC: AppDate) {
        self._id = id
        self._idCount = UInt8(id.count > id.maxCarID ? id.maxCarID : id.count)
        self._vin = vin
        self._vinCount = UInt8(vin.count > vin.maxCarVIN ? vin.maxCarVIN : vin.count)
        self._axlesCount = axles
        self._weight = weight
        self._inSearch = inSearch
        self._dateEndEC = endEC
        self._dateEndTC = endTC
    }
    
    init() {
        self._id = ""
        self._idCount = 0
        self._vin = ""
        self._vinCount = 0
        self._axlesCount = UInt8.max
        self._weight = UInt16.max
        self._inSearch = false
        self._dateEndEC = AppDate()
        self._dateEndTC = AppDate()
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
    
    var axlesCount: UInt8 {
        get {
            return self._axlesCount
        }
    }
    
    var weight: UInt16 {
        get {
            return self._weight
        }
    }
    
    var inSearch: Bool {
        get {
            return self._inSearch
        }
    }
    
    var dateEndEC: AppDate {
        get {
            return self._dateEndEC
        }
    }
    
    var dateEndTC: AppDate {
        get {
            return self._dateEndTC
        }
    }
    
    func initEmpty() -> Any {
        return Car() as Any
    }
    
    public func setAxlesCount(_ count: UInt8) {
        self._axlesCount = count
    }
    
    public func setWeight(_ weight: UInt16) {
        self._weight = weight
    }
    
    public func setInSearch(_ inSearch: Bool) {
        self._inSearch = inSearch
    }
    
    public func setdateEndEC(_ date: AppDate) {
        self._dateEndEC = date
    }
    
    public func setdateEndTC(_ date: AppDate) {
        self._dateEndTC = date
    }

    //MARK: - To Bytes
    func toBytes() -> [UInt8] {
        
        var result: [UInt8] = [UInt8]()
        
        result.append(idCount)
        var temp = Data(id.utf8)
        for char in temp {
            result.append(UInt8(char))
        }
        
        var emptyBytes = id.maxCarID - Int(idCount)
        while emptyBytes > 0 {
            result.append(UInt8.max)
            emptyBytes -= 1
        }
        
        result.append(vinCount)
        temp = Data(vin.utf8)
        for char in temp {
            result.append(UInt8(char))
        }
        
        emptyBytes = vin.maxCarVIN - Int(vinCount)
        while emptyBytes > 0 {
            result.append(UInt8.max)
            emptyBytes -= 1
        }
        
        result.append(axlesCount)
        
        let weightBytes = Helper.shared.decimalStringToUInt8Array(String(weight), weight.size)
        for byte in weightBytes {
            result.append(byte)
        }
        
        result.append(UInt8(inSearch.intValue))
        
        let ecBytes = dateEndEC.toBytes()
        for byte in ecBytes {
            result.append(byte)
        }
        
        let tcBytes = dateEndTC.toBytes()
        for byte in tcBytes {
            result.append(byte)
        }
        
        return result
    }
    
    //MARK: - From Bytes
    func fromBytes(bytes: [UInt8]) -> Any {
        
        var carID: String = ""
        var i = 0
        let idCount = bytes[0]
        while i < idCount {
            i += 1
            carID += String(Character(UnicodeScalar(Int(bytes[i]))!))
        }
        
        var carVIN: String = ""
        i = 0
        let vinCount = bytes[carID.maxCarID + idCount.size]
        while i < vinCount {
            carVIN += String(Character(UnicodeScalar(Int(bytes[idCount.size + carID.maxCarID + vinCount.size + i]))!))
            i += 1
        }
        
        let axlesCount = bytes[idCount.size + carID.maxCarID + vinCount.size + carVIN.maxCarVIN]
        
        var weightBytes: [UInt8] = []
        for i in 1...weight.size {
            weightBytes.append(bytes[i - 1 + idCount.size + carID.maxCarID + vinCount.size + carVIN.maxCarVIN + axlesCount.size])
        }
        let weight = UInt16(Helper.shared.uInt8ArrayToDecimalString(weightBytes))!
        
        let inSearch = Int(bytes[idCount.size + carID.maxCarID + vinCount.size + carVIN.maxCarVIN + axlesCount.size + weight.size]).boolValue
        
        var dateBytes: [UInt8] = []
        for j in 1...dateEndEC.getSize() {
            dateBytes.append(bytes[j - 1 + idCount.size + carID.maxCarID + vinCount.size + carVIN.maxCarVIN + axlesCount.size + weight.size + inSearch.size])
        }
        let endEC = AppDate().fromBytes(bytes: dateBytes) as! AppDate
        
        dateBytes = []
        for j in 1...dateEndTC.getSize() {
            dateBytes.append(bytes[j - 1 + idCount.size + carID.maxCarID + vinCount.size + carVIN.maxCarVIN + axlesCount.size + weight.size + inSearch.size + endEC.getSize()])
        }
        let endTC = AppDate().fromBytes(bytes: dateBytes) as! AppDate
        
        return Car(id: carID, vin: carVIN, axles: axlesCount, weight: weight, inSearch: inSearch, endEC: endEC, endTC: endTC)
    }

    func getSize() -> Int {
        return id.maxCarID + idCount.size + vin.maxCarVIN + vinCount.size + axlesCount.size + weight.size + inSearch.size + dateEndEC.getSize() + dateEndTC.getSize()
    }
    
    func toString() -> String {
        return "ID: \(id), VIN: \(vin), Počet náprav: \(axlesCount), Hmotnosť: \(weight), Hľadané: \(inSearch), Koniec emisnej kontroly: \(dateEndEC.toString()), Koniec technickej kontroly: \(dateEndTC.toString())"
    }
    
    func isEmpty() -> Bool {
        if (id == "" && idCount == 0 && vin == "" && vinCount == 0 && axlesCount == UInt8.max && weight == UInt16.max && !inSearch && dateEndEC.isEmpty() && dateEndTC.isEmpty()) {
            return true
        }
        
        return false
    }
    
    func initRandom() -> Any {
        
        let randomSizeID = Int.random(in: 1...id.maxCarID)
        let randomSizeVIN = Int.random(in: 1...vin.maxCarVIN)
        let randomWeight = UInt16.random(in: 700...2250)
        let randomDateEC = AppDate().initRandom() as! AppDate
        let randomDateTC = AppDate().initRandom() as! AppDate
        
        let randomNumber: Float = Float.random(in: 0...1)
        var inSearch = false
        if randomNumber <= 0.5 {
            inSearch = true
        }
        
        return Car(id: randomSizeID.randomString, vin: randomSizeVIN.randomString, axles: 4, weight: randomWeight, inSearch: inSearch, endEC: randomDateEC, endTC: randomDateTC) as Any
    }
    
    static let comparator: Comparator = {
        lhs, rhs in guard let first = lhs as? Car, let second = rhs as? Car else {
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
