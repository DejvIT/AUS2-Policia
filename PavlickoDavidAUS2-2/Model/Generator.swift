//
//  TestGenerator.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 30/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation
import UIKit

class Generator {
    
    private var _bTreeTest: BTree<Test>!
    private var _testArray : Array<UInt32> = Array()
    
    init(_ order: Int, _ filename: String) {
        self._bTreeTest = BTree<Test>(Test(), Test.comparator, filename, order)
    }
    
    var bTreeTest: BTree<Test> {
        get {
            return self._bTreeTest
        }
    }
    
    var testArray: Array<UInt32> {
        get {
            return self._testArray
        }
    }
    
    public func insertExact() {
        
        let array: Array<UInt32> = [24,40,79,1,78,74,40,29,10,37,30,10,15,52,29,1,63,77,64,15]
        
        for item in array {
            
            if (bTreeTest.insert(Test(item))) {
                self._testArray.append(item)
            }
        }
    }
    
    // MARK: - BTree random
    public func bTree(loop: Int, insert: Int, search: Int, delete: Int, progressBar: UIProgressView?) {

        let maximum = loop * 4
        var loop = loop
        var hundreth: Int = Int(Double(loop) / Double(100))
        
        if hundreth == 0 {
            hundreth = 1
        }
        
        let insertRatio: Double = Double(insert) / (Double(insert) + Double(search) + Double(delete))
        let searchRatio: Double = Double(search) / (Double(insert) + Double(search) + Double(delete))
        let deleteRatio: Double = Double(delete) / (Double(insert) + Double(search) + Double(delete))
        
        while loop > 0 {
            loop -= 1
            
            if loop == 45 {
                
            }
            
            if loop % hundreth == 0 && progressBar != nil {
                DispatchQueue.main.async {
                    progressBar?.progress += 0.01
                }
            }
            
            let random: Double = Double.random(in: 0...1)
            if (random <= insertRatio) {
                
                let randomNumber = Test(UInt32(Int.random(in: 0 ... maximum)))

                if (bTreeTest.insert(randomNumber)) {
                    print("\(loop + 1).) 😊 Inserting number \(randomNumber.value).")
                    self._testArray.append(randomNumber.value)
                } else {
                    loop += 1
                }
                
            } else if (random <= (insertRatio + searchRatio)) {
                
                if (testArray.isEmpty) {
                    loop += 1
                } else {
                    let randomNumber = testArray.randomElement()!
                    let rnTest = Test(randomNumber)
                    print("\(loop + 1).) 😎 Searching number \(rnTest.value) 😂")
                    _ = bTreeTest.search(rnTest)
                }
                
            } else if (random <= (insertRatio + searchRatio + deleteRatio)) {
                
                //TODO
                loop += 1
                
            } else {
                print("Some shit has happened! 😩😭😡")
            }
        }
    }
    
    // MARK: - BTree insert
    public func bTreeInsert(loop: Int, progressBar: UIProgressView?) {
        
        let maximum = loop * 4
        var loop = loop
        var hundreth: Int = Int(Double(loop) / Double(100))
        
        if hundreth == 0 {
            hundreth = 1
        }
        
        while loop > 0 {
            loop -= 1
            
            if loop % hundreth == 0 && progressBar != nil {
                DispatchQueue.main.async {
                    progressBar?.progress += 0.01
                }
            }
            
            let randomNumber = Test(UInt32(Int.random(in: 0 ... maximum)))
            print("\(loop + 1).) 😊 Trying to insert number \(randomNumber.value)")
            
            if (bTreeTest.insert(randomNumber)) {
                print("\(randomNumber.value) successfully inserted!")
                self._testArray.append(randomNumber.value)
            } else {
                print("\(randomNumber.value) already inserted!")
            }
        }
    }
    
    // MARK: - BTree search
    public func bTreeSearch() {

        print("\nSearching...")
        var notFound = 0
        
        if testArray.count > 0 {
            
            for value in testArray {
                    
                if (bTreeTest.search(Test(value)) == nil) {
                    notFound += 1
                }
            }
            
        } else {
            print("There is nothing to search!")
        }
        
        if (notFound > 0) {
            print("Not found count: \(notFound)")
        } else {
            print("Every value has been successfully searched!")
        }
        
    }
    
    // MARK: - BTree delete
    public func bTreeDelete(loop: Int, progressBar: UIProgressView?) {
    
        var loop = loop
        let hundreth: Int = Int(Double(loop) / Double(100))
        
        while loop > 0 {
            loop -= 1
            
            if loop % hundreth == 0 && progressBar != nil {
                DispatchQueue.main.async {
                    progressBar?.progress += 0.01
                }
            }
            
            //TODO

        }
    }
    
    //MARK: - Testing result
    public func getResult() -> String {
        var result = ""
        
        _ = bTreeTest.fileToString(type: Test())
        let arrayBlocksFromFile = bTreeTest.readArray
        var readValues: Array<UInt32> = Array()
        
        for block in arrayBlocksFromFile {
            for record in block.records {
                if !record.isEmpty() {
                    readValues.append(record.value)
                }
            }
        }
        
        readValues.sort()
        self._testArray.sort()
        
        if testArray.count == readValues.count {
            result += "\n[\n"
            for i in 0 ... testArray.count - 1 {
                result += " \(testArray[i]), \(readValues[i]) \n"
            }
            result += "]\n"
        }

        result += "\nCount inserted (left column):    \(testArray.count)\n"
        result += "Count after read (right column): \(readValues.count)\n"
        
        return result
    }
}

