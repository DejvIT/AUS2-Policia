//
//  BTree.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 23/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

final class BTree<T: Record> {
  
    private let comparator: Comparator
    public private(set)var _root: UInt64 = 0
    private var _order: Int
    private var _blockSize: Int
    private var _count: Int = 0
    
    public init(_ comparator: @escaping Comparator, _ order: Int, _ blockSize: Int) {
        self.comparator = comparator
        self._order = order
        self._blockSize = blockSize
    }
    
    var order: Int {
        get {
            return self._order
        }
    }
    
    var root: UInt64 {
        get {
            return self._root
        }
    }
    
    var blockSize: Int {
        get {
            return self._blockSize
        }
    }
    
    var count: Int {
        get {
            return self._count
        }
    }
    
    //MARK: - Insert
    public func insert(_ newItem: T) -> Bool {
        
        if count == 0 {
            let block = Block<T>(newItem, blockSize)
            self._count += 1
            return block.insert(newItem)
        } else {

            let fileManager = ImportExport(newItem)
            let block = fileManager.getBlock(address: root, blockSize: blockSize, type: newItem)
            
            let pivotBlock = block
            if (pivotBlock.insert(newItem)) {
                return true
            } else {
                
            }
            
        }
        
        return true
    }
    
    //MARK: - Search
    public func search(_ item: T) -> Block<T>? {

        if count > 0 {
            let fileManager = ImportExport(item)
            let pivotBlock = fileManager.getBlock(address: root, blockSize: blockSize, type: item)
            
            while true {
                
//                for record in pivotBlock._records.inOrder() {
//                    switch (comparator(item, record)) {
//                    case .orderedSame:
//                        return pivotBlock
//                    case .orderedAscending:
//                        if (pivot.left == nil) {
//                            if (!delete) {
//                                self.splay(node: pivot)
//                            }
//                            if (closest) {
//                                return pivot
//                            } else {
//                                return nil
//                            }
//                        } else {
//                            pivot = pivot.left!
//                        }
//                    case .orderedDescending:
//                        if (pivot.right == nil) {
//                            if (!delete) {
//                                self.splay(node: pivot)
//                            }
//                            if (closest) {
//                                return pivot.right
//                            }
//                            return nil
//                        } else {
//                            pivot = pivot.right!
//                        }
//                    default:
//                        return nil
//                    }
//                }
                
            }
        } else {
            return nil
        }
    }
}
