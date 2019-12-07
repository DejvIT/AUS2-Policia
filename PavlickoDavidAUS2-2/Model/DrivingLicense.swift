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
    private var _nameCount: Int
    private var _surname: String
    private var _surnameCount: Int
    private var _dateTime: UInt64
    private var _validLicense: Bool
    private var _trafficOffenses: Int
    
    init(id: UInt64, name: String, surname: String, dateTime: UInt64, validLicense: Bool, offenses: Int) {
        self._id = id
        self._name = name
        self._nameCount = name.count
        self._surname = surname
        self._surnameCount = surname.count
        self._dateTime = dateTime
        self._validLicense = validLicense
        self._trafficOffenses = offenses
    }
    
    init() {
        self._id = UInt64.max
        self._name = ""
        self._nameCount = 0
        self._surname = ""
        self._surnameCount = 0
        self._dateTime = UInt64.max
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
    
    var nameCount: Int {
        return self._nameCount
    }
    
    var surname: String {
        return self._surname
    }
    
    var surnameCount: Int {
        return self._surnameCount
    }
    
    var dateTime: UInt64 {
        return self._dateTime
    }
    
    var validLicense: Bool {
        return self._validLicense
    }
    
    var trafficOffenses: Int {
        return self._trafficOffenses
    }
    
    func initEmpty() -> Any {
        return DrivingLicense() as Any
    }
    
    func toBytes() -> [UInt8] {
        
        var result: [UInt8] = [UInt8]()
        
        let idBytes = decimalStringToUInt8Array(String(id))
        for byte in idBytes {
            result.append(byte)
        }
        
        result.append(UInt8(nameCount))
        result.append(UInt8(surnameCount))
        
        var temp = Data(name.utf8)
        for char in temp {
            result.append(UInt8(char))
        }
        
        var emptyBytes = 35 - nameCount
        while emptyBytes > 0 {
            result.append(UInt8.max)
            emptyBytes -= 1
        }
        
        temp = Data(surname.utf8)
        for char in temp {
            result.append(UInt8(char))
        }
        
        emptyBytes = 35 - surnameCount
        while emptyBytes > 0 {
            result.append(UInt8.max)
            emptyBytes -= 1
        }
        
        let dateTimeBytes = decimalStringToUInt8Array(String(dateTime))
        for byte in dateTimeBytes {
            result.append(byte)
        }
        
        result.append(UInt8(validLicense.intValue))
        result.append(UInt8(trafficOffenses))
        
        return result
    }
    
    func fromBytes(bytes: [UInt8]) -> Any {
        
        var idBytes: [UInt8] = []
        
        for i in 0...7 {
            idBytes.append(bytes[i])
        }
        let id = uInt8ArrayToDecimalString(idBytes)
        
        let nameCount = Int(bytes[8])
        let surnameCount = Int(bytes[9])
        var name: String = ""
        var surname: String = ""
        
        var i = 0
        while i < nameCount {
            name += String(Character(UnicodeScalar(Int(bytes[10 + i]))!))
            i += 1
        }
        
        i = 0
        while i < surnameCount {
            surname += String(Character(UnicodeScalar(Int(bytes[45 + i]))!))
            i += 1
        }
        
        i = 70
        var dateTimeBytes: [UInt8] = []
        for j in 0...7 {
            dateTimeBytes.append(bytes[j + i + 10])
        }
        let dateTime = uInt8ArrayToDecimalString(dateTimeBytes)
        
        let validLicense = Int(bytes[88]).boolValue
        let offenses = Int(bytes[89])
        
        return DrivingLicense(id: UInt64(id)!, name: name, surname: surname, dateTime: UInt64(dateTime)!, validLicense: validLicense, offenses: offenses)
    }
    
    func getSize() -> Int {
        return 8 + 35 + 1 + 35 + 1 + 8 + 1 + 1
    }
    
    func getKeyToString() -> String {
        return "\(id)"
    }
    
    func toString() -> String {
        return "ID: \(id), Meno: \(name), Priezvisko: \(surname), Platnosť do: \(dateTime), Platný: \(validLicense), Počet priestupkov: \(trafficOffenses)"
    }
    
    func isEmpty() -> Bool {
        if (id == UInt64.max && nameCount == 0 && surnameCount == 0 && dateTime == UInt64.max && !validLicense && trafficOffenses == 255) {
            return true
        }
        
        return false
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

extension DrivingLicense {
    
    func decimalStringToUInt8Array(_ decimalString: String) -> [UInt8] {

        // Convert input string into array of Int digits
        let digits = Array(decimalString).compactMap { Int(String($0)) }

        // Nothing to process? Return an empty array.
        guard digits.count > 0 else { return [] }

        let numdigits = digits.count

        // Array to hold the result, in reverse order
        var bytes = [UInt8]()

        // Convert array of digits into array of Int values each
        // representing 6 digits of the original number.  Six digits
        // was chosen to work on 32-bit and 64-bit systems.
        // Compute length of first number.  It will be less than 6 if
        // there isn't a multiple of 6 digits in the number.
        var ints = Array(repeating: 0, count: (numdigits + 5)/6)
        var rem = numdigits % 6
        if rem == 0 {
            rem = 6
        }
        var index = 0
        var accum = 0
        for digit in digits {
            accum = accum * 10 + digit
            rem -= 1
            if rem == 0 {
                rem = 6
                ints[index] = accum
                index += 1
                accum = 0
            }
        }

        // Repeatedly divide value by 256, accumulating the remainders.
        // Repeat until original number is zero
        while ints.count > 0 {
            var carry = 0
            for (index, value) in ints.enumerated() {
                var total = carry * 1000000 + value
                carry = total % 256
                total /= 256
                ints[index] = total
            }

            bytes.append(UInt8(truncatingIfNeeded: carry))

            // Remove leading Ints that have become zero.
            while ints.count > 0 && ints[0] == 0 {
                ints.remove(at: 0)
            }
        }

        while bytes.count < 8 {
            bytes.append(UInt8(0))
        }
        
        // Reverse the array and return it
        return bytes.reversed()
    }
    
    func uInt8ArrayToDecimalString(_ uint8array: [UInt8]) -> String {

        // Nothing to process? Return an empty string.
        guard uint8array.count > 0 else { return "" }

        // For efficiency in calculation, combine 3 bytes into one Int.
        let numvalues = uint8array.count
        var ints = Array(repeating: 0, count: (numvalues + 2)/3)
        var rem = numvalues % 3
        if rem == 0 {
            rem = 3
        }
        var index = 0
        var accum = 0
        for value in uint8array {
            accum = accum * 256 + Int(value)
            rem -= 1
            if rem == 0 {
                rem = 3
                ints[index] = accum
                index += 1
                accum = 0
            }
        }

        // Array to hold the result, in reverse order
        var digits = [Int]()

        // Repeatedly divide value by 10, accumulating the remainders.
        // Repeat until original number is zero
        while ints.count > 0 {
            var carry = 0
            for (index, value) in ints.enumerated() {
                var total = carry * 256 * 256 * 256 + value
                carry = total % 10
                total /= 10
                ints[index] = total
            }

            digits.append(carry)

            // Remove leading Ints that have become zero.
            while ints.count > 0 && ints[0] == 0 {
                ints.remove(at: 0)
            }
        }

        // Reverse the digits array, convert them to String, and join them
        return digits.reversed().map(String.init).joined()
    }
}
