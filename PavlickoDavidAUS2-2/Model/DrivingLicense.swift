//
//  DrivingLicense.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 03/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

class DrivingLicense: Record {
    
    private var _id: UInt64
    private var _name: String
    private var _nameCount: UInt8
    private var _surname: String
    private var _surnameCount: UInt8
    private var _expiration: AppDate
    private var _validLicense: Bool
    private var _trafficOffenses: UInt8
    
    init(id: UInt64, name: String, surname: String, expiration: AppDate, validLicense: Bool, offenses: Int) {
        self._id = id
        self._name = name
        self._nameCount = UInt8(name.count > name.maxSurname ? name.maxName : name.count)
        self._surname = surname
        self._surnameCount = UInt8(surname.count > surname.maxSurname ? surname.maxSurname : surname.count)
        self._expiration = expiration
        self._validLicense = validLicense
        self._trafficOffenses = UInt8(offenses)
    }
    
    init() {
        self._id = UInt64.max
        self._name = ""
        self._nameCount = 0
        self._surname = ""
        self._surnameCount = 0
        self._expiration = AppDate()
        self._validLicense = false
        self._trafficOffenses = 255
    }
    
    var id: UInt64 {
        get {
            return self._id
        }
    }
    
    var name: String {
        return self._name
    }
    
    var nameCount: UInt8 {
        return self._nameCount
    }
    
    var surname: String {
        return self._surname
    }
    
    var surnameCount: UInt8 {
        return self._surnameCount
    }
    
    var expiration: AppDate {
        return self._expiration
    }
    
    var validLicense: Bool {
        return self._validLicense
    }
    
    var trafficOffenses: UInt8 {
        return self._trafficOffenses
    }
    
    func initEmpty() -> Any {
        return DrivingLicense() as Any
    }
    
    //MARK: - To Bytes
    func toBytes() -> [UInt8] {
        
        var result: [UInt8] = [UInt8]()
        
        let idBytes = Helper.shared.decimalStringToUInt8Array(String(id), id.size)
        for byte in idBytes {
            result.append(byte)
        }
        
        result.append(nameCount)
        result.append(surnameCount)
        
        var temp = Data(name.utf8)
        for char in temp {
            result.append(UInt8(char))
        }
        
        var emptyBytes = name.maxName - Int(nameCount)
        while emptyBytes > 0 {
            result.append(UInt8.max)
            emptyBytes -= 1
        }
        
        temp = Data(surname.utf8)
        for char in temp {
            result.append(UInt8(char))
        }
        
        emptyBytes = surname.maxSurname - Int(surnameCount)
        while emptyBytes > 0 {
            result.append(UInt8.max)
            emptyBytes -= 1
        }
        
        let expirationBytes = expiration.toBytes()
        for byte in expirationBytes {
            result.append(byte)
        }
        
        result.append(UInt8(validLicense.intValue))
        result.append(trafficOffenses)
        
        return result
    }
    
    //MARK: - From Bytes
    func fromBytes(bytes: [UInt8]) -> Any {
        
        var idBytes: [UInt8] = []
        
        for i in 1...id.size {
            idBytes.append(bytes[i - 1])
        }
        let id = UInt64(Helper.shared.uInt8ArrayToDecimalString(idBytes))!
        
        let nameCount = bytes[id.size]
        let surnameCount = bytes[id.size + 1]
        var name: String = ""
        var surname: String = ""
        
        var i = 0
        while i < nameCount {
            name += String(Character(UnicodeScalar(Int(bytes[id.size + nameCount.size + surnameCount.size + i]))!))
            i += 1
        }
        
        i = 0
        while i < surnameCount {
            surname += String(Character(UnicodeScalar(Int(bytes[id.size + nameCount.size + surnameCount.size + name.maxName + i]))!))
            i += 1
        }
        
        var dateBytes: [UInt8] = []
        for j in 1...expiration.getSize() {
            dateBytes.append(bytes[j - 1 + id.size + nameCount.size + surnameCount.size + name.maxName + surname.maxSurname])
        }
        let date = AppDate().fromBytes(bytes: dateBytes) as! AppDate
        
        let validLicense = Int(bytes[id.size + nameCount.size + surnameCount.size + name.maxName + surname.maxSurname + date.getSize()]).boolValue
        let offenses = Int(bytes[id.size + nameCount.size + surnameCount.size + name.maxName + surname.maxSurname + date.getSize() + validLicense.size])
        
        return DrivingLicense(id: id, name: name, surname: surname, expiration: date, validLicense: validLicense, offenses: offenses)
    }
    
    //MARK: - Size
    func getSize() -> Int {
        return id.size + name.maxName + nameCount.size + surname.maxSurname + surnameCount.size + expiration.getSize() + validLicense.size + trafficOffenses.size
    }
    
    func toString() -> String {
        return "ID: \(id), Meno: \(name), Priezvisko: \(surname), Platnosť do: \(expiration.toString()), Platný: \(validLicense), Počet priestupkov: \(trafficOffenses)"
    }
    
    func isEmpty() -> Bool {
        if (id == UInt64.max && nameCount == 0 && surnameCount == 0 && expiration.isEmpty() && !validLicense && trafficOffenses == 255) {
            return true
        }
        
        return false
    }
    
    func initRandom() -> Any {
        let randomSizeName = Int.random(in: 3...10)
        let randomSizeSurname = Int.random(in: 5...15)
        let randomExpiration = AppDate().initRandom() as! AppDate
        
        let validLicense = randomExpiration.isValid()
        
        let randomOffenses = Int.random(in: 0...23)
        
        return DrivingLicense(id: UInt64(11).randomID, name: randomSizeName.randomString, surname: randomSizeSurname.randomString, expiration: randomExpiration, validLicense: validLicense, offenses: randomOffenses) as Any
    }
    
    static let comparator: Comparator = {
        lhs, rhs in guard let first = lhs as? DrivingLicense, let second = rhs as? DrivingLicense else {
            return ComparisonResult.orderedSame
        }
        
        if (first.id == second.id) {
            return ComparisonResult.orderedSame
        } else if (first.id < second.id) {
            return ComparisonResult.orderedAscending
        } else {
            return ComparisonResult.orderedDescending
        }
    }
}
