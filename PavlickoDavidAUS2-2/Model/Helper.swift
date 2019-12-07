//
//  Help.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 03/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation
import UIKit

extension Bool {
    
    var intValue: Int {
        return self ? 1 : 0
    }
    
    var size: Int {
        return 1
    }
    
}

extension Int {
    
    var boolValue: Bool {
        return self == 1 ? true : false
    }
}

extension UInt8 {
    
    var size: Int {
        return 1
    }
    
    var toBytes: [UInt8] {
        return Helper.shared.decimalStringToUInt8Array(String(self), 1)
    }
}

extension UInt16 {
    
    var size: Int {
        return 2
    }
    
    var toBytes: [UInt8] {
        return Helper.shared.decimalStringToUInt8Array(String(self), 2)
    }
}

extension UInt32 {
    
    var size: Int {
        return 4
    }
    
    var toBytes: [UInt8] {
        return Helper.shared.decimalStringToUInt8Array(String(self), 4)
    }
}

extension UInt64 {
    
    var size: Int {
        return 8
    }
    
    var toBytes: [UInt8] {
        return Helper.shared.decimalStringToUInt8Array(String(self), 8)
    }
}

extension String {
    
    var maxCarID: Int {
        return 7
    }
    
    var maxCarVIN: Int {
        return 17
    }
    
    var maxName: Int {
        return 35
    }
    
    var maxSurname: Int {
        return 35
    }
}

final class Helper {
    
    static let shared = Helper()
    
    func decimalStringToUInt8Array(_ decimalString: String, _ size: Int) -> [UInt8] {

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

        while bytes.count < size {
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
