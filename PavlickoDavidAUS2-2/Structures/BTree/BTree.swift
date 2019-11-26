//
//  BTree.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 23/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation
import UIKit

final class BTree<T: Record> {
    
    private let comparator: Comparator
    fileprivate var filename: String
    fileprivate var pathURL: String
    fileprivate var _fileManager: FileManager = FileManager.default
    fileprivate var _fileHandle: FileHandle?
    fileprivate var _scanner: Scanner?
    
    private var _root: UInt64
    private var _firstFreeBlock: UInt64 = UInt64.max
    private var _lastBlock: UInt64
    private var _order: Int
    
    public init(_ type: T, _ comparator: @escaping Comparator, _ filename: String, _ order: Int) {
        self.comparator = comparator
        self.filename = filename
        self._order = order

        self.pathURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + filename + ".bin"
        print("Cesta: \(pathURL)")
        
        if (!_fileManager.fileExists(atPath: pathURL)) {
            _fileManager.createFile(atPath: pathURL, contents: nil, attributes: nil)
        }
        _fileHandle = FileHandle(forUpdatingAtPath: pathURL)
        
        self._root = UInt64(type.getSize() * (order - 1) + 40)
        let block = Block<T>(type, order - 1, self._root)
        self._lastBlock = 2 * UInt64(block.getBlockByteSize())
        write(block)
        writeMetaBlock(block.getBlockByteSize())
    }
    
    func writeMetaBlock(_ size: Int) {
        var result: [UInt8] = []
        
        var tempBytes = decimalStringToUInt8Array(String(self._root))
        for temp in tempBytes {
            result.append(temp)
        }
        
        tempBytes = decimalStringToUInt8Array(String(self._firstFreeBlock))
        for temp in tempBytes {
            result.append(temp)
        }
        
        tempBytes = decimalStringToUInt8Array(String(self._lastBlock))
        for temp in tempBytes {
            result.append(temp)
        }
        
        while result.count != size {
            tempBytes = decimalStringToUInt8Array("255")
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
    
    var root: UInt64 {
        get {
            return self._root
        }
    }
    
    var firstFreeBlock: UInt64? {
        get {
            return self._firstFreeBlock
        }
    }
    
    var lastBlock: UInt64 {
        get {
            return self._lastBlock
        }
    }
    
    var order: Int {
        get {
            return self._order
        }
    }
    
    var blockSize: Int {
        get {
            return self._order - 1
        }
    }
    
    //MARK: - Insert
    public func insert(_ newItem: T) -> Bool {
        
        var block = getBlock(type: newItem, address: root, blockSize: blockSize)
        var stack: [Block<T>] = []
        stack.append(block)
            
        if block.validRecords == 0 {
            if (block.insert(newItem, comparator, left: nil, right: nil)) {
                write(block)
                return true
            }
        } else {
            while true {
            
                for i in 0...block.records.count - 1 {
                    
                    switch (comparator(newItem, block.records[i])) {
                    case .orderedSame:
                        return false
                    case .orderedAscending:
                        if (block.getLeft(i) == UInt64.max) {
                            if (block.isFull()) {
                                
                                return insertIntoFullBlock(stack: stack, newItem: newItem, left: nil, right: nil)
                                
                            } else {
                                if (block.insert(newItem, comparator, left: nil, right: nil)) {
                                    write(block)
                                    return true
                                }
                            }
                        } else {
                            block = getBlock(type: newItem, address: block.getLeft(i), blockSize: block.size)
                            stack.append(block)
                            break
                        }
                    case .orderedDescending:
                        if (block.getRight(i) == UInt64.max && block.isFull() && (i == block.records.count - 1)) {
                            
                            return insertIntoFullBlock(stack: stack, newItem: newItem, left: nil, right: nil)
                            
                        } else if (block.getRight(i) != UInt64.max) {
                            block = getBlock(type: newItem, address: block.getRight(i), blockSize: block.size)
                            stack.append(block)
                            break
                        }
                        
                    default:
                        return false
                    }
                }
            }
        }
        
        return false
    }
    
    func insertIntoFullBlock(stack: [Block<T>], newItem: T, left: UInt64?, right: UInt64?) -> Bool {
        
        var stack = stack
        var block = stack.last
        stack.removeLast()
        
        if (stack.isEmpty) {
            //Split root
            let newRootBlock = getEmptyBlock(type: newItem)
            let newRightBlock = getEmptyBlock(type: newItem)
            
            if (block!.insert(newItem, comparator, left: nil, right: nil)) {
                let median = block!.records.count / 2
                
                _ = newRootBlock.insert((block?.records[median])!, comparator, left: block?.address, right: newRightBlock.address)
                self._root = newRootBlock.address
                
                for i in median + 1...((block?.records.count)! - 1) {
                    _ = newRightBlock.insert((block?.records[i])!, comparator, left: block?.getLeft(i), right: block?.getRight(i))
                }
                
                block?.cut(at: median)
                
                writeMetaBlock((block?.getBlockByteSize())!)
                write(newRootBlock)
                write(block!)
                write(newRightBlock)
                
                return true
            }
        } else {
            //TODO
        }
        
        return false
    }
    
    func getEmptyBlock(type: T) -> Block<T> {
        
        var block: Block<T>
        
        if (firstFreeBlock != UInt64.max) {
            block = getBlock(type: type, address: firstFreeBlock!, blockSize: blockSize)
        } else {
            block = Block(type, blockSize, lastBlock)
        }

        self._lastBlock = lastBlock + UInt64(block.getBlockByteSize())
        return block
    }
    
    //MARK: - Search
    public func search(_ item: T) -> T? {
        
        var block = getBlock(type: item, address: root, blockSize: blockSize)
        
        if (block.validRecords == 0) {
            return nil
        }
        
        while true {
    
            for i in 0...block.validRecords - 1 {
                
                switch (comparator(item, block.records[i])) {
                case .orderedSame:
                    return block.records[i]
                case .orderedAscending:
                    if (block.getLeft(i) == UInt64.max) {
                        return nil
                    } else {
                        block = getBlock(type: item, address: block.getLeft(i), blockSize: block.size)
                        break
                    }
                case .orderedDescending:
                    if ((block.getRight(i) == UInt64.max) && (i == block.records.count)) {
                        return nil
                    } else if (block.getRight(i) != UInt64.max) {
                        block = getBlock(type: item, address: block.getRight(i), blockSize: block.size)
                        break
                    }
                default:
                    return nil
                }
            }
        }
    }
}

extension BTree {
    
    public func write(_ block: Block<T>) {
        _fileHandle?.seek(toFileOffset: block.address)
        _fileHandle?.write(Data(block.toBytes()))
    }
    
    public func getBlock(type: T, address: UInt64, blockSize: Int) -> Block<T> {
        
        let block = Block<T>(type.initEmpty() as! T, blockSize, address)
        let length = block.getBlockByteSize()
        do {
            try fileHandle.seek(toOffset: address)
        } catch {
            print(error)
        }
        let data: [UInt8] = [UInt8]((_fileHandle?.readData(ofLength: length))!)
        return Block(type: type, bytes: data, size: block.size, address: address)
    }
}

extension BTree {
    
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
