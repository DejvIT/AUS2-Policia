//
//  HBlock.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 02/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

class HBlock<T: Record> {
    
    private var _address: UInt64
    private var _size: Int
    private var _records: [T] = []
    private var _validRecords: Int = 0
    private let _type: T
    private let _nextFreeBlock: UInt64 = UInt64.max
    
    init(_ object: T, _ size: Int, _ address: UInt64) {
        self._type = object
        self._address = address
        self._size = size
        
        var i = 0
        while (i < size) {
            self._records.append(object.initEmpty() as! T)
            i += 1
        }
    }
    
    init(type: T, bytes: [UInt8], size: Int, address: UInt64) {
        self._type = type
        self._size = size
        self._address = address
        
        var i = 0
        while (i < self.size) {
            var j = 0
            
            var object: [UInt8] = []
            while j < self._type.getSize() {
                object.append(bytes[j + i * self._type.getSize()])
                j += 1
            }
            let readObject = self._type.fromBytes(bytes: object) as! T
            _ = _records.append(readObject)
            
            if (!readObject.isEmpty()) {
                self._validRecords += 1
            }
            
            i += 1
        }
    }
    
    var address: UInt64 {
        get {
            return self._address
        }
    }
    
    var size: Int {
        get {
            return self._size
        }
    }
    
    var type: T {
        get {
            return self._type
        }
    }
    
    var validRecords: Int {
        get {
            return self._validRecords
        }
    }
    
    var records: [T] {
        get {
            return self._records
        }
    }
    
    var nextFreeBlock: UInt64? {
        get {
            return self._nextFreeBlock
        }
    }
    
    func getBlockByteSize() -> Int {
        return self.type.getSize() * self.size
    }
    
    func insert(_ record: T) -> Bool {
        
        for i in 0..._records.count - 1 {
            
            if (records[i].isEmpty()) {

                self._records[i] = record
                self._validRecords += 1
                return true
            }
        }
        
        return false
    }
    
    func toBytes() -> [UInt8] {
        var result: [UInt8] = []
        
        for record in records {
            let tempBytes = record.toBytes()
            for temp in tempBytes {
                result.append(temp)
            }
        }
        
        return result
    }
    
    func isFull() -> Bool {
        
        if (size == validRecords) {
            return true
        }
        
        return false
    }
    
    func toString() -> String {
        
        var result: String = "\nAdress: \(address)\nRecords:\n"
        
        result += "["
        for record in records {
            if (record.isEmpty()) {
                result += " NIL "
            } else {
                result += " \(record.toString()) "
            }
        }
        result += "]\n"
        
        return result
    }
    
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

