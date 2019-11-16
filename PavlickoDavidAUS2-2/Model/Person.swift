//
//  Person.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 16/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

public class Person {
    
    var _name: String
    var _nameCount: Int
    var _surname: String
    var _surnameCount: Int
    var _age: Int
    
    init(name: String, surname: String, age: Int) {
        self._name = name
        self._nameCount = name.count
        self._surname = surname
        self._surnameCount = surname.count
        self._age = age
    }
    
    var name: String {
        return self._name
    }
    
    var nameCount: Int {
        return self._nameCount
    }
    
    var surname: String {
        return self._surname
    }
    
    var surnameCount: Int {
        return self._surnameCount
    }
    
    var age: Int {
        return self._age
    }
    
    public func toBytes() -> [String] {
        
        var result: [String] = [String]()
        
        result.append(UInt8(self.nameCount).binaryDescription)
        result.append(UInt8(self.surnameCount).binaryDescription)
        
        var temp = Data(self.name.utf8)
        for char in temp {
            result.append(UInt8(char).binaryDescription)
        }
        
        temp = Data(self.surname.utf8)
        for char in temp {
            result.append(UInt8(char).binaryDescription)
        }
        
        result.append(UInt8(self.age).binaryDescription)
        
        return result
    }
    
    public func fromBytes(bytes: [String]) -> Person {
        
        let nameCount = Int(bytes[0], radix: 2)
        let surnameCount = Int(bytes[1], radix: 2)
        var name: String = ""
        var surname: String = ""
        let age: Int = Int(bytes[bytes.count - 1], radix: 2)!
        
        var i = 0
        while i < nameCount! {
            name += String(Character(UnicodeScalar(Int(bytes[2 + i], radix: 2)!)!))
            i += 1
        }
        
        i = 0
        while i < surnameCount! {
            surname += String(Character(UnicodeScalar(Int(bytes[2 + i + nameCount!], radix: 2)!)!))
            i += 1
        }
        
        return Person(name: name, surname: surname, age: age)
    }
    
    public func getSize() -> Int {
        
        return 3 + nameCount + surnameCount
    }
}

extension BinaryInteger {
    var binaryDescription: String {
        var binaryString = ""
        var internalNumber = self
        for _ in (1...self.bitWidth) {
            binaryString.insert(contentsOf: "\(internalNumber & 1)", at: binaryString.startIndex)
            internalNumber >>= 1
        }
        return binaryString
    }
}
