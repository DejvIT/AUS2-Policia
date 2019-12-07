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
}

