//
//  BinaryNode.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 23/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

public class BinaryNode<T> {
    
    var _value: T
    var _leftChild: BinaryNode<T>?
    var _rightChild: BinaryNode<T>?
    var _parent: BinaryNode<T>?

    init(_ value: T) {
        self._value = value
    }
    
    var value: T {
        get {
            return self._value
        }
    }
    
    var left: BinaryNode<T>? {
        get {
            return self._leftChild
        }
    }
    
    var right: BinaryNode<T>? {
        get {
            return self._rightChild
        }
    }
    
    var parent: BinaryNode<T>? {
        get {
            return self._parent
        }
    }
}
