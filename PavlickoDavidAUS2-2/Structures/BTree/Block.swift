//
//  Block.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 16/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

class Block<T: Record> {
    
    private var _address: UInt64
    private var _size: UInt64
    private var _records: [T] = []
    private var _sons: [UInt64] = []
    private var _validRecords: Int = 0
    private let _type: T
    
    init(_ object: T, _ size: UInt64, _ address: UInt64) {
        self._type = object
        self._address = address
        self._size = size
        
        var i = 0
        while (i < size) {
            self._records.append(object.initEmpty() as! T)
            self._sons.append(UInt64.max)
            i += 1
        }
        self._sons.append(UInt64.max)
    }
    
    init(type: T, bytes: [UInt8], size: UInt64, address: UInt64) {
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
        
        i = 0
        while (i < self.size + 1) {
            var j = 0
            
            var object: [UInt8] = []
            while j < 8 {
                object.append(bytes[j + (i * 8) + (type.getSize() * records.count)])
                j += 1
            }
            _ = _sons.append(UInt64(Helper.shared.uInt8ArrayToDecimalString(object)) ?? UInt64.max)
            i += 1
        }
    }
    
    var address: UInt64 {
        get {
            return self._address
        }
    }
    
    var size: UInt64 {
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
    
    var sons: [UInt64] {
        get {
            return self._sons
        }
    }
    
    func getLeft(_ index: Int) -> UInt64 {
        return sons[index]
    }
    
    func getRight(_ index: Int) -> UInt64 {
        return sons[index + 1]
    }
    
    func getBlockByteSize() -> Int {
        return self.type.getSize() * Int(self.size) + Int(((self.size + 1) * 8))
    }
    
    func insert(_ record: T, _ position: Int, left: UInt64?, right: UInt64?) -> Bool {
        
        var newRoot = false
        if (left != nil) {
            self._sons.insert(left!, at: position)
            newRoot = true
        }
        
        if (right != nil) {
            self._sons.insert(right!, at: position + 1)
        } else {
            self._sons.insert(UInt64.max, at: position + 1)
        }
        
        self._records.insert(record, at: position)
        self._validRecords += 1
        
        if ((records.last?.isEmpty())!) {
            self._records.removeLast()
            self._sons.removeLast()
            if (newRoot) {
                self._sons.removeLast()
            }
        }
        
        return true
    }
    
    func cut(at: Int) {
        
        while records.count > size {
            self._records.removeLast()
            self._validRecords -= 1
        }
        
        while sons.count > size + 1 {
            self._sons.removeLast()
        }
        
        for i in at...records.count - 1 {
            self._records[i] = self._type.initEmpty() as! T
            self._sons[i + 1] = UInt64.max
            self._validRecords -= 1
        }
        self._sons[Int(size)] = UInt64.max
    }
    
    func toBytes() -> [UInt8] {
        var result: [UInt8] = []
        
        for record in records {
            let tempBytes = record.toBytes()
            for temp in tempBytes {
                result.append(temp)
            }
        }
        
        for son in sons {
            let tempBytes = Helper.shared.decimalStringToUInt8Array(String(son), 8)
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
        
        result += "Adressess of the sons:\n"
        result += "["
        
        for son in sons {
            if (son == UInt64.max) {
                result += " NIL "
            } else {
                result += " \(son) "
            }
        }
        result += "]\n"
        
        return result
    }
    
    func updateRecord(_ item: T, at: Int) {
        self._records[at] = item
    }
}

