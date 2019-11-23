//
//  Block.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 16/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

class Block<T: Record> {
    
    private let type: T
    var _address: UInt64?
    var _size: Int
    var _records: BinaryTree<T>!
    var _sons: BinaryTree<T>!
    
    init(_ type: T, _ size: Int) {
        self.type = type
        self._size = size
        self._records = BinaryTree<T>(type.getComparator())
        self._sons = BinaryTree<T>(type.getComparator())
    }
    
    init(_ type: T) {
        self.type = type
        self._size = 1
        self._records = BinaryTree<T>(type.getComparator())
        self._sons = BinaryTree<T>(type.getComparator())
    }
    
    init(bytes: [UInt8], size: Int, address: UInt64, type: T) {
        self.type = type
        self._size = size
        self._address = address
        self._records = BinaryTree<T>(type.getComparator())
        self._sons = BinaryTree<T>(type.getComparator())
        
        var i = 0
        while i < Int(bytes[0]) {
            var j = 0
            
            var object: [UInt8] = []
            while j < type.getSize() {
                object.append(bytes[j + i * type.getSize() + 1])
                j += 1
            }
            _ = insert(type.fromBytes(bytes: object) as! T)
            i += 1
        }
    }
    
    var address: UInt64? {
        get {
            return self._address
        }
    }
    
    var size: Int {
        get {
            return self._size
        }
    }
    
    func getBlockByteSize() -> Int {
        return type.getSize() * self.size + 1
    }
    
    func insert(_ record: T) -> Bool {
        
        if _records.getCount() < size {
            _ = self._records.insert(record)
            write()
            return true
        }
        
        return false
    }
    
    func write() {
        let fileManager = ImportExport(type)
        fileManager.insert(block: self, address: address ?? 0)
    }
    
    func toBytes() -> [UInt8] {
        var result: [UInt8] = []
        
        result.append(UInt8(self._records.getCount()))
        
        for record in _records.inOrder() {
            let tempBytes = record.toBytes()
            for temp in tempBytes {
                result.append(temp)
            }
        }
        
        while result.count < getBlockByteSize() {
            let tempBytes = type.emptyBytes()
            for temp in tempBytes {
                result.append(temp)
            }
        }
        
        return result
    }
}
