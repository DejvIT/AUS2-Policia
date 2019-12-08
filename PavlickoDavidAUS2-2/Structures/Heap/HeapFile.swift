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
    
    private var _firstFreeBlock: UInt64
    private var _nextBlock: UInt64
    private var _blockSize: UInt16
    
    public init(_ type: T, _ filename: String, _ size: UInt16) {
        
        self.filename = filename
        self._blockSize = size

        self.pathURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + filename + ".bin"
        print("Filepath [HeapFile]: \(pathURL)\n")
        
        if (!_fileManager.fileExists(atPath: pathURL)) {
            _fileManager.createFile(atPath: pathURL, contents: nil, attributes: nil)
        }
        _fileHandle = FileHandle(forUpdatingAtPath: pathURL)
        
        self._nextBlock = UInt64(type.getSize() * Int(self._blockSize))
        let block = HBlock<T>(type, self._blockSize, self._nextBlock)
        self._firstFreeBlock = UInt64(block.getBlockByteSize())
        self._nextBlock = 2 * UInt64(block.getBlockByteSize())
        write(block)
        writeMetaBlock(block.getBlockByteSize())
        print("Block size of Heap file set to: \(block.getBlockByteSize()) bytes.\n")
    }
    
    func writeMetaBlock(_ size: Int) {
        var result: [UInt8] = []
        
        var tempBytes = Helper.shared.decimalStringToUInt8Array(String(self._firstFreeBlock), self._firstFreeBlock.size)
        for temp in tempBytes {
            result.append(temp)
        }
        
        tempBytes = Helper.shared.decimalStringToUInt8Array(String(self._nextBlock), self._nextBlock.size)
        for temp in tempBytes {
            result.append(temp)
        }
        
        tempBytes = Helper.shared.decimalStringToUInt8Array(String(self._blockSize), self._blockSize.size)
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
    
    var firstFreeBlock: UInt64 {
        get {
            return self._firstFreeBlock
        }
    }
    
    var nextBlock: UInt64 {
        get {
            return self._nextBlock
        }
    }
    
    var blockSize: UInt16 {
        get {
            return self._blockSize
        }
    }
    
    //MARK: - Insert
    public func insert(_ newItem: T) -> UInt64 {
        
        let block: HBlock<T> = getEmptyBlock(type: newItem)
            
        let address = block.insert(newItem)
        
        if (block.isFull()) {
            self._firstFreeBlock = nextBlock
        }
        
        write(block)
        writeMetaBlock(block.getBlockByteSize())
        
        return address
    }
    
    func getEmptyBlock(type: T) -> HBlock<T> {
        
        var block: HBlock<T>
        
        if (firstFreeBlock != nextBlock) {
            block = getBlock(type: type, address: firstFreeBlock, blockSize: blockSize)
        } else {
            block = HBlock(type, blockSize, nextBlock)
            self._nextBlock = nextBlock + UInt64(block.getBlockByteSize())
        }

        return block
    }
    
    //MARK: - Delete
    public func delete(_ item: T) -> Bool {
        
        //TODO
        return true
    }
}

extension HeapFile {

    //MARK: - Write
    public func write(_ block: HBlock<T>) {
        _fileHandle?.seek(toFileOffset: block.address)
        _fileHandle?.write(Data(block.toBytes()))
    }
    
    public func getBlock(type: T, address: UInt64, blockSize: UInt16) -> HBlock<T> {
        
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
    
    //MARK: - Get Record from file
    public func getRecord(_ item: T, _ address: UInt64) -> T {
        
        let length = item.getSize()
        do {
            try fileHandle.seek(toOffset: address)
        } catch {
            print(error)
        }
        let data: [UInt8] = [UInt8]((_fileHandle?.readData(ofLength: length))!)
        return item.fromBytes(bytes: data) as! T
    }
}

//MARK: - Read File
extension HeapFile {
    
    public func fileToString(type: T) -> String {
        
        var result: String = ""
        
        let length = type.getSize() * Int(blockSize)
        do {
            try fileHandle.seek(toOffset: 0)
        } catch {
            print(error)
        }
        
        let metaBlock: [UInt8] = [UInt8]((_fileHandle?.readData(ofLength: length))!)
        
        var object: [UInt8] = []
        var j = 0
        while j < firstFreeBlock.size {
            object.append(metaBlock[j])
            j += 1
        }
        let firstFreeBlockAddress = UInt64(Helper.shared.uInt8ArrayToDecimalString(object))!
        if (nextBlock == UInt64.max) {
            result += "First free block address: NIL\n"
        } else {
            result += "First free block address: \(firstFreeBlockAddress)\n"
        }
        
        object = []
        j = 0
        while j < nextBlock.size {
            object.append(metaBlock[j + firstFreeBlockAddress.size])
            j += 1
        }
        let nextBlockAddress = UInt64(Helper.shared.uInt8ArrayToDecimalString(object))!
        if (nextBlock == UInt64.max) {
            result += "Next block address: NIL\n"
        } else {
            result += "Next block address: \(nextBlockAddress)\n"
        }
        
        object = []
        j = 0
        while j < blockSize.size {
            object.append(metaBlock[j + firstFreeBlockAddress.size + nextBlockAddress.size])
            j += 1
        }
        let blockSize = UInt16(Helper.shared.uInt8ArrayToDecimalString(object))!
        result += "Block size: \(blockSize)\n"
        
        var address = length
        while address < nextBlockAddress {
            let readBlock = getBlock(type: type, address: UInt64(address), blockSize: blockSize)
            
            result += readBlock.toString()
            address += length
        }
        
        return result
    }
}
