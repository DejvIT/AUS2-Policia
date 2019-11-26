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
    
    private var _root: UInt64 = 0
    private var _firstFreeBlock: UInt64?
    private var _lastFreeBlock: UInt64?
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
        
        write(Block<T>(type, order - 1, root))
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
    
    var lastFreeBlock: UInt64? {
        get {
            return self._lastFreeBlock
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
        var result = false
            
        if block.validRecords == 0 {
            result = block.insert(newItem)
        } else {
            while true {
            
                for i in 0...block.records.count - 1 {
                    
                    switch (comparator(newItem, block.records[i])) {
                    case .orderedSame:
                        result = false
                    case .orderedAscending:
                        if (block.getLeft(i) == UInt64.max) {
                            if (block.isFull()) {
                                //Insert into full block
                            } else {
                                return block.insert(newItem)
                            }
                        } else {
                            block = getBlock(type: newItem, address: block.getLeft(i), blockSize: block.size)
                            break
                        }
                    case .orderedDescending:
                        if (block.getRight(i) == UInt64.max) {
                            if (i == block.records.count) {
                                //Insert into full block
                            }
                        } else {
                            block = getBlock(type: newItem, address: block.getRight(i), blockSize: block.size)
                            break
                        }
                    default:
                        result = false
                    }
                }
            }
        }
        
        write(block)
        return result
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
                    } else {
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
        
        let block = Block<T>(type, blockSize, address)
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
