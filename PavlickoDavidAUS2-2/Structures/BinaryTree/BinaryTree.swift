//
//  BinaryTree.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 23/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

public class BinaryTree<T> {
  
    private let comparator: Comparator
    public private(set)var _root: BinaryNode<T>?
    private var _count: Int = 0
    
    public init(_ comparator: @escaping Comparator) {
        self.comparator = comparator
    }
    
    public func getCount() -> Int {
        return self._count
    }
    
    public func getRoot() -> BinaryNode<T>? {
        return self._root
    }
    
    public func insert(_ newItem: T) -> Bool {
        
        guard let root = self._root else {
            self._root = BinaryNode(newItem)
            _count += 1
            return true
        }
        
        var pivot = root
        
        while true {
            
            switch (comparator(newItem, pivot.value)) {
            case .orderedSame:
                return false
            case .orderedAscending:
                if (pivot.left == nil) {
                    pivot._leftChild = BinaryNode(newItem)
                    pivot._leftChild?._parent = pivot
                    _count += 1
                    return true
                } else {
                    pivot = pivot.left!
                }
            case .orderedDescending:
                if (pivot.right == nil) {
                    pivot._rightChild = BinaryNode(newItem)
                    pivot._rightChild?._parent = pivot
                    _count += 1
                    return true
                } else {
                    pivot = pivot.right!
                }
            default:
                return false
            }
        }
    }
    
    public func levelOrder() -> [T] {
           
        var result: [T] = []
        var discoveredNodes: [BinaryNode<T>] = [self._root!]
       
        while discoveredNodes.count > 0 {
           
            for item in discoveredNodes {

                let pivot = discoveredNodes[0]
                result.append(pivot.value)
               
                if (item.left != nil) {
                    discoveredNodes.append(item.left!)
                }
               
                if (item.right != nil) {
                    discoveredNodes.append(item.right!)
                }
               
                discoveredNodes.remove(at: 0)
            }
        }
           
        return result
    }
    
    public func inOrder() -> [T] {
        
        var result: [T] = []
        
        if (self.getCount() > 0) {
            
            var discoveredNodes: [BinaryNode<T>] = []
            var pivot = self._root
            
            while (pivot != nil || discoveredNodes.isEmpty == false)
            {
                while (pivot !=  nil)
                {
                    discoveredNodes.append(pivot!)
                    pivot = pivot?.left
                }
                  
                pivot = discoveredNodes[discoveredNodes.count - 1]
                discoveredNodes.remove(at: discoveredNodes.count - 1)
            
                result.append(pivot!.value)
                  
                pivot = pivot?.right
            
            }
        }
        
        return result
    }
    
    public func search(_ item: T) -> BinaryNode<T>? {
        
        guard var pivot = self._root else {
            return nil
        }
        
        while true {
            
            switch (comparator(item, pivot.value)) {
            case .orderedSame:
                return pivot
            case .orderedAscending:
                if (pivot.left == nil) {
                    return nil
                } else {
                    pivot = pivot.left!
                }
            case .orderedDescending:
                if (pivot.right == nil) {
                    return nil
                } else {
                    pivot = pivot.right!
                }
            default:
                return nil
            }
        }
    }
    
    public func delete(_ item: T) -> Bool {
        
        guard var foundNode = self.search(item) else {
            return false
        }

        let parent = foundNode.parent
        
        if (foundNode.left == nil && foundNode.right == nil) {
            
            if (parent == nil) {    //Otestovane, tato vetva je pre zmazanie posledneho prvku v strome -> korena
                self._root = nil
            } else {    //Otestovane, tato vetva je pre zmazanie listu, kt. nema ziadneho laveho / praveho syna
                
                if (parent?.left != nil) {
                    
                    if (comparator((parent?.left?.value)!, foundNode.value) == .orderedSame) {
                        parent?._leftChild = nil
                    } else {

                        parent?._rightChild = nil
                    }
                } else {

                    parent?._rightChild = nil
                }
            
                foundNode._parent = nil
            
            }
            
        } else if ((foundNode.left != nil && foundNode.right == nil) || (foundNode.left == nil && foundNode.right != nil)) {    //Otestovane, tuna sa prepaja referencia s otca na syna
            
            if (parent == nil) { //parent not found, foundNode is root

                print("parent = null")
                if (foundNode.left != nil) {    //check if root has leftChild
                    self._root = foundNode.left
                    print("parent = null 1")
                } else {
                    self._root = foundNode.right
                    print("parent = null 2")
                }
                
            } else {    //skontrolovane
                
                if (foundNode.left != nil) {

                    if (parent?.left != nil) {

                        if (comparator((parent?.left?.value)!, foundNode.value) == .orderedSame) {
                            
                            parent?._leftChild = foundNode.left
                            foundNode.left?._parent = parent
                            
                        } else {
                            
                            parent?._rightChild = foundNode.left
                            foundNode.left?._parent = parent
                        }
                        
                    } else {

                        print("parent = exists 1 2")
                        parent?._rightChild = foundNode.left
                        foundNode.left!._parent = parent
                    }

                    foundNode._leftChild = nil
                    
                } else {    //skontrolovane

                    if (parent?.left != nil) {

                        if (comparator((parent?.left?.value)!, foundNode.value) == .orderedSame) {
                            
                            parent?._leftChild = foundNode.right
                            foundNode.right?._parent = parent
                            
                        } else {

                            parent?._rightChild = foundNode.right
                            foundNode.right?._parent = parent
                        }

                        
                    } else {

                        parent?._rightChild = foundNode.right
                        foundNode.right!._parent = parent
                    }

                    foundNode._rightChild = nil
                }

                foundNode._parent = nil
            }
            
        } else {

            let leftSubPivot = foundNode.left!
            let rightSubPivot = foundNode.right!
            let newNode = self.findMaxOfLeftSubTree(subPivot: leftSubPivot)
//            var newNodeParent = newNode.parent
            let newNodeParent = comparator(newNode.parent!.value, foundNode.value) == .orderedSame ? parent : newNode.parent
//            if (comparator(newNode.parent!.value, foundNode.value) == .orderedSame) {
//                newNodeParent = parent
//            }

            if (newNode.left != nil) {
//                newNodeParent!._rightChild = newNode.left
                newNodeParent!._rightChild = comparator(newNode.parent!.value, foundNode.value) == .orderedSame ? newNode : newNode.left
                newNodeParent?._rightChild?._parent = newNodeParent
            } else {
                newNodeParent!._rightChild = nil
            }
            
            if (comparator(foundNode.left?.value as Any, newNodeParent?.value as Any) == .orderedSame) {

                newNodeParent?._parent = newNode
                
            } else {
                
                foundNode.left?._parent = newNode
            }
            
            rightSubPivot._parent = newNode
            
            if (parent == nil) {
                
                self._root = newNode
                self._root?._parent = nil
                rightSubPivot._parent = self._root
                leftSubPivot._parent = self._root
                self._root?._rightChild = rightSubPivot
                self._root?._leftChild = leftSubPivot
                
            } else {
                
                if (comparator(parent?.left?.value as Any, foundNode.value) == .orderedSame) {

                    foundNode._parent?._leftChild = newNode
                    
                } else {

                    foundNode._parent?._rightChild = newNode
                    
                }
                
                foundNode = newNode
                if (comparator(newNode.parent!.value, foundNode.value) != .orderedSame) {

                    foundNode._leftChild = leftSubPivot
                }
                foundNode._rightChild = rightSubPivot
                foundNode._parent = parent
                
            }
        }
        
        self._count -= 1
        return true
    }
    
    public func findMaxOfLeftSubTree(subPivot: BinaryNode<T>) -> BinaryNode<T> {
        
        var pivot = subPivot
        while true {
            
            if (pivot.right != nil) {
                pivot = pivot.right!
            } else {

                return pivot
            }
        }
    }
    
}
