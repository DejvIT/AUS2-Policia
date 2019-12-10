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
    private var _nextBlock: UInt64
    private var _order: Int
    
    //Test array
    private var _readArray: Array<Block<T>> = Array()
    
    public init(_ type: T, _ comparator: @escaping Comparator, _ filename: String, _ order: Int) {
        
        var order = order
        if (order < 3) {
            order = 3
        }
        
        self.comparator = comparator
        self.filename = filename
        self._order = order

        self.pathURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + filename + ".bin"
        print("Filepath [BTree]: \(pathURL)\n")
        
        if (!_fileManager.fileExists(atPath: pathURL)) {
            _fileManager.createFile(atPath: pathURL, contents: nil, attributes: nil)
        }
        _fileHandle = FileHandle(forUpdatingAtPath: pathURL)
        
        self._root = UInt64(type.getSize() * (order - 1) + (order * 8))
        let block = Block<T>(type, order - 1, self._root)
        self._nextBlock = 2 * UInt64(block.getBlockByteSize())
        write(block)
        writeMetaBlock(block.getBlockByteSize())
        print("Block size of BTree set to: \(block.getBlockByteSize()) bytes.\n")
    }
    
    func writeMetaBlock(_ size: Int) {
        var result: [UInt8] = []
        
        var tempBytes = Helper.shared.decimalStringToUInt8Array(String(self._root), self._root.size)
        for temp in tempBytes {
            result.append(temp)
        }
        
        tempBytes = Helper.shared.decimalStringToUInt8Array(String(self._firstFreeBlock), self._firstFreeBlock.size)
        for temp in tempBytes {
            result.append(temp)
        }
        
        tempBytes = Helper.shared.decimalStringToUInt8Array(String(self._nextBlock), self._nextBlock.size)
        for temp in tempBytes {
            result.append(temp)
        }
        
        while (result.count < size) {
            result.append(UInt8.max)
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
    
    var nextBlock: UInt64 {
        get {
            return self._nextBlock
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
            if (block.insert(newItem, 0, left: nil, right: nil)) {
                write(block)
                return true
            }
        } else {
            while true {
            
                var newPivot = false
                
                for i in 0...block.records.count - 1 {
                    
                    if (newPivot) {
                        break
                    }
                    
                    switch (comparator(newItem, block.records[i])) {
                    case .orderedSame:
                        return false
                    case .orderedAscending:
                        if (block.getLeft(i) == UInt64.max) {
                            if (block.isFull()) {
                                
                                return insertIntoFullBlock(stack: stack, newItem: newItem, position: i)
                                
                            } else {
                                if (block.insert(newItem, i, left: nil, right: nil)) {
                                    write(block)
                                    return true
                                }
                            }
                        } else {
                            block = getBlock(type: newItem, address: block.getLeft(i), blockSize: block.size)
                            stack.append(block)
                            newPivot = true
                            break
                        }
                    case .orderedDescending:
                        if (block.getRight(i) == UInt64.max && block.isFull() && (i == block.records.count - 1)) {
                            
                            return insertIntoFullBlock(stack: stack, newItem: newItem, position: i + 1)
                            
                        } else if ((block.getRight(i) != UInt64.max) && (i == block.records.count - 1)) {
                            block = getBlock(type: newItem, address: block.getRight(i), blockSize: block.size)
                            stack.append(block)
                            newPivot = true
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
    
    func insertIntoFullBlock(stack: [Block<T>], newItem: T, position: Int) -> Bool {
        
        var stack = stack
        var block = stack.last
        stack.removeLast()
        var splitting = true
        var inserted = false
        
        while (splitting) {
            
            if (stack.isEmpty) {
                
                let newRootBlock = getEmptyBlock(type: newItem)
                let newRightBlock = getEmptyBlock(type: newItem)
                
                if !inserted {
                    inserted = block!.insert(newItem, position, left: nil, right: nil)
                }
                
                let median = block!.records.count / 2
                
                _ = newRootBlock.insert((block?.records[median])!, 0, left: block?.address, right: newRightBlock.address)
                self._root = newRootBlock.address
                
                for i in median + 1...((block?.records.count)! - 1) {
                    if (i == median + 1) {
                        _ = newRightBlock.insert((block?.records[i])!, i - (median + 1), left: block?.getLeft(i), right: block?.getRight(i))
                    } else {
                        _ = newRightBlock.insert((block?.records[i])!, i - (median + 1), left: nil, right: block?.getRight(i))
                    }
                }
                
                block?.cut(at: median)
                
                writeMetaBlock((block?.getBlockByteSize())!)
                write(newRootBlock)
                write(block!)
                write(newRightBlock)

                splitting = false
                return true
                
            } else {
                
                let newRightBlock = getEmptyBlock(type: newItem)
                
                if !inserted {
                    inserted = block!.insert(newItem, position, left: nil, right: nil)
                }
                
                let median = block!.records.count / 2

                let parentBlock = stack.last
                stack.removeLast()
                
                if (!(parentBlock?.isFull())!) {
                    splitting = false
                }
                
                var parentExtended = false
                for i in 0...parentBlock!.records.count - 1 {
                    if (parentExtended) {
                        break
                    }
                    switch (comparator(newItem, parentBlock!.records[i])) {
                    case .orderedAscending:
                        _ = parentBlock!.insert((block!.records[median]), i, left: nil, right: newRightBlock.address)
                        parentExtended = true
                    case .orderedDescending:
                        if (i == parentBlock!.records.count - 1) {
                            _ = parentBlock!.insert((block!.records[median]), i + 1, left: nil, right: newRightBlock.address)
                            parentExtended = true
                        }
                    default:
                        break
                    }
                }
                
                for i in median + 1...((block?.records.count)! - 1) {
                    if (i == median + 1) {
                        _ = newRightBlock.insert((block?.records[i])!, i - (median + 1), left: block?.getLeft(i), right: block?.getRight(i))
                    } else {
                        _ = newRightBlock.insert((block?.records[i])!, i - (median + 1), left: nil, right: block?.getRight(i))
                    }
                }
                
                block?.cut(at: median)
                
                writeMetaBlock((block?.getBlockByteSize())!)
                if (!splitting) {
                    write(parentBlock!)
                }
                write(block!)
                write(newRightBlock)
                
                block = parentBlock
                
                if (!splitting) {
                    return true
                }
            }
        }
        
        return false
    }
    
    func getEmptyBlock(type: T) -> Block<T> {
        
        var block: Block<T>
        
        if (firstFreeBlock != UInt64.max) {
            block = getBlock(type: type, address: firstFreeBlock!, blockSize: blockSize)
        } else {
            block = Block(type, blockSize, nextBlock)
        }

        self._nextBlock = nextBlock + UInt64(block.getBlockByteSize())
        return block
    }
    
    //MARK: - Search
    public func search(_ item: T) -> T? {
        
        var block = getBlock(type: item, address: root, blockSize: blockSize)
        
        if (block.validRecords == 0) {
            return nil
        }
        
        while true {
            
            var newPivot = false
    
            for i in 0...block.records.count - 1 {
                
                if (newPivot) {
                    break
                }
        
                switch (comparator(item, block.records[i])) {
                case .orderedSame:
                    return block.records[i]
                case .orderedAscending:
                    if (block.getLeft(i) == UInt64.max) {
                        return nil
                    } else {
                        block = getBlock(type: item, address: block.getLeft(i), blockSize: block.size)
                        newPivot = true
                        break
                    }
                case .orderedDescending:
                    if ((block.getRight(i) == UInt64.max) && (i == block.records.count - 1)) {
                        return nil
                    } else if (block.getRight(i) != UInt64.max && (i == block.records.count - 1)) {
                        block = getBlock(type: item, address: block.getRight(i), blockSize: block.size)
                        newPivot = true
                        break
                    }
                default:
                    return nil
                }
            }
        }
    }
    
    public func searchBlock(_ item: T) -> Block<T>? {
        
        var block = getBlock(type: item, address: root, blockSize: blockSize)
        
        if (block.validRecords == 0) {
            return nil
        }
        
        while true {
            
            var newPivot = false
    
            for i in 0...block.records.count - 1 {
                
                if (newPivot) {
                    break
                }
        
                switch (comparator(item, block.records[i])) {
                case .orderedSame:
                    return block
                case .orderedAscending:
                    if (block.getLeft(i) == UInt64.max) {
                        return nil
                    } else {
                        block = getBlock(type: item, address: block.getLeft(i), blockSize: block.size)
                        newPivot = true
                        break
                    }
                case .orderedDescending:
                    if ((block.getRight(i) == UInt64.max) && (i == block.records.count - 1)) {
                        return nil
                    } else if (block.getRight(i) != UInt64.max && (i == block.records.count - 1)) {
                        block = getBlock(type: item, address: block.getRight(i), blockSize: block.size)
                        newPivot = true
                        break
                    }
                default:
                    return nil
                }
            }
        }
    }
    
    //MARK: - Delete
    public func delete(_ item: T) -> Bool {
        
        //TODO
        return true
    }
}

//MARK: - Write
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

//MARK: - Read File
extension BTree {
    
    var readArray: Array<Block<T>> {
        get {
            return self._readArray
        }
    }
    
    public func fileToString(type: T) -> String {
        
        var result: String = ""
        
        let length = type.getSize() * (blockSize) + (order * 8)
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
        
        let rootAddress = Helper.shared.uInt8ArrayToDecimalString(object)
        result += "Root address: \(rootAddress)\n"
        
        object = []
        while j < 2 * 8 {
            object.append(metaBlock[j])
            j += 1
        }
        
        let firstFreeBlockAddress = Helper.shared.uInt8ArrayToDecimalString(object)
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
        
        let lastBlockAddress = Helper.shared.uInt8ArrayToDecimalString(object)
        result += "Next block address: \(lastBlockAddress)\n"
        
        var address = length
        while UInt64(address) < UInt64(lastBlockAddress)! {
            let readBlock = getBlock(type: type, address: UInt64(address), blockSize: order - 1)
            
            //Checking
//            self._readArray.append(readBlock)
            
            result += readBlock.toString()
            address += length
        }
        
        return result
    }
    
    public func fileToRecords(type: T) -> Array<T> {
        
        var result: Array<T> = Array<T>()
        
        let length = type.getSize() * (blockSize) + (order * 8)
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
        
        _ = Helper.shared.uInt8ArrayToDecimalString(object)
        
        object = []
        while j < 2 * 8 {
            object.append(metaBlock[j])
            j += 1
        }
        
        _ = Helper.shared.uInt8ArrayToDecimalString(object)
        
        object = []
        while j < 3 * 8 {
            object.append(metaBlock[j])
            j += 1
        }
        
        let lastBlockAddress = Helper.shared.uInt8ArrayToDecimalString(object)
        
        var address = length
        while UInt64(address) < UInt64(lastBlockAddress)! {
            let readBlock = getBlock(type: type, address: UInt64(address), blockSize: order - 1)
            
            if (readBlock.validRecords > 0) {
                for i in 1...readBlock.validRecords {
                    result.append(readBlock.records[i - 1])
                }
            }
            address += length
        }
        
        return result
    }
}
