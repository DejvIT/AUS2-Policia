//
//  HeapFile.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 02/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation
import UIKit

final class HeapFile<T: Record> {
    
    fileprivate var filename: String
    fileprivate var pathURL: String
    fileprivate var _fileManager: FileManager = FileManager.default
    fileprivate var _fileHandle: FileHandle?
    fileprivate var _scanner: Scanner?
    
    private var _firstFreeBlock: UInt64 = UInt64.max
    private var _nextBlock: UInt64
    private var _blockSize: Int
    
    public init(_ type: T, _ filename: String, _ size: Int) {
        
        self.filename = filename
        self._blockSize = size

        self.pathURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + filename + ".bin"
        print("Filepath: \(pathURL)\n")
        
        if (!_fileManager.fileExists(atPath: pathURL)) {
            _fileManager.createFile(atPath: pathURL, contents: nil, attributes: nil)
        }
        _fileHandle = FileHandle(forUpdatingAtPath: pathURL)
        
        self._nextBlock = UInt64(type.getSize() * self._blockSize)
        let block = HBlock<T>(type, self._blockSize, self._nextBlock)
        self._nextBlock = 2 * UInt64(block.getBlockByteSize())
        write(block)
        writeMetaBlock(block.getBlockByteSize())
        print("Block size of heap file set to: \(block.getBlockByteSize()) bytes.\n")
    }
    
    func writeMetaBlock(_ size: Int) {
        var result: [UInt8] = []
        
        var tempBytes = decimalStringToUInt8Array(String(self._firstFreeBlock))
        for temp in tempBytes {
            result.append(temp)
        }
        
        tempBytes = decimalStringToUInt8Array(String(self._nextBlock))
        for temp in tempBytes {
            result.append(temp)
        }
        
        while (result.count < size) {
            tempBytes = decimalStringToUInt8Array(String(UInt64.max))
            for temp in tempBytes {
                result.append(temp)
            }
        }
        
        _fileHandle?.seek(toFileOffset: 0)
        _fileHandle?.write(Data(result))
    }
        
    var fileManager: FileManager {
        get {
            return self._fileManager
        }
    }
    
    var fileHandle: FileHandle {
        get {
            return self._fileHandle!
        }
    }
    
    var scanner: Scanner {
        get {
            return self._scanner!
        }
    }
    
    var firstFreeBlock: UInt64? {
        get {
            return self._firstFreeBlock
        }
    }
    
    var nextBlock: UInt64 {
        get {
            return self._nextBlock
        }
    }
    
    var blockSize: Int {
        get {
            return self._blockSize
        }
    }
    
    //MARK: - Insert
    public func insert(_ newItem: T) -> UInt64? {
        
        var block: HBlock<T>
        
        if (firstFreeBlock != nil) {
            block = getBlock(type: newItem, address: firstFreeBlock!, blockSize: blockSize)
        } else {
            block = getEmptyBlock(type: newItem)
        }
            
        if (block.validRecords == 0) {
            if (block.insert(newItem)) {
                write(block)
                return block.address
            }
        }
            
        return nil
    }
    
    func getEmptyBlock(type: T) -> HBlock<T> {
        
        var block: HBlock<T>
        
        if (firstFreeBlock != UInt64.max) {
            block = getBlock(type: type, address: firstFreeBlock!, blockSize: blockSize)
        } else {
            block = HBlock(type, blockSize, nextBlock)
        }

        self._nextBlock = nextBlock + UInt64(block.getBlockByteSize())
        return block
    }
    
    //MARK: - Delete
    public func delete(_ item: T) -> Bool {
        
        //TODO
        return true
    }
}

//MARK: - Write
extension HeapFile {
    
    public func write(_ block: HBlock<T>) {
        _fileHandle?.seek(toFileOffset: block.address)
        _fileHandle?.write(Data(block.toBytes()))
    }
    
    public func getBlock(type: T, address: UInt64, blockSize: Int) -> HBlock<T> {
        
        let block = HBlock<T>(type.initEmpty() as! T, blockSize, address)
        let length = block.getBlockByteSize()
        do {
            try fileHandle.seek(toOffset: address)
        } catch {
            print(error)
        }
        let data: [UInt8] = [UInt8]((_fileHandle?.readData(ofLength: length))!)
        return HBlock(type: type, bytes: data, size: block.size, address: address)
    }
}

extension HeapFile {
    
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

//MARK: - Read File
extension HeapFile {
    
    public func fileToString(type: T) -> String {
        
        var result: String = ""
        
        let length = type.getSize() * blockSize
        do {
            try fileHandle.seek(toOffset: 0)
        } catch {
            print(error)
        }
        
        let metaBlock: [UInt8] = [UInt8]((_fileHandle?.readData(ofLength: length))!)
        var object: [UInt8] = []
        var j = 0
        while j < 8 {
            object.append(metaBlock[j])
            j += 1
        }
        
        let rootAddress = uInt8ArrayToDecimalString(object)
        result += "Root address: \(rootAddress)\n"
        
        object = []
        while j < 2 * 8 {
            object.append(metaBlock[j])
            j += 1
        }
        
        let firstFreeBlockAddress = uInt8ArrayToDecimalString(object)
        if (UInt64.max == UInt64(firstFreeBlockAddress)) {
            result += "First free block address: NIL\n"
        } else {
            result += "First free block address: \(firstFreeBlockAddress)\n"
        }
        
        object = []
        while j < 3 * 8 {
            object.append(metaBlock[j])
            j += 1
        }
        
        let lastBlockAddress = uInt8ArrayToDecimalString(object)
        result += "Next block address: \(lastBlockAddress)\n"
        
        var address = length
        while UInt64(address) < UInt64(lastBlockAddress)! {
            let readBlock = getBlock(type: type, address: UInt64(address), blockSize: blockSize)
            
            result += readBlock.toString()
            address += length
        }
        
        return result
    }
}
