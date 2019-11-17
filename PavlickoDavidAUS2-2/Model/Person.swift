//
//  Person.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 16/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

public class Person: Record {
    
    
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
    
    func toBytes() -> [UInt8] {
        
        var result: [UInt8] = [UInt8]()
        
        result.append(UInt8(self.nameCount))
        result.append(UInt8(self.surnameCount))
        
        var temp = Data(self.name.utf8)
        for char in temp {
            result.append(UInt8(char))
        }
        
        temp = Data(self.surname.utf8)
        for char in temp {
            result.append(UInt8(char))
        }
        
        result.append(UInt8(self.age))
        
        return result
    }
    
    func fromBytes(bytes: [UInt8]) -> Any {
        
        let nameCount = Int(bytes[0])
        let surnameCount = Int(bytes[1])
        var name: String = ""
        var surname: String = ""
        let age: Int = Int(bytes[bytes.count - 1])
        
        var i = 0
        while i < nameCount {
            name += String(Character(UnicodeScalar(Int(bytes[2 + i]))!))
            i += 1
        }
        
        i = 0
        while i < surnameCount {
            surname += String(Character(UnicodeScalar(Int(bytes[2 + i + nameCount]))!))
            i += 1
        }
        
        return Person(name: name, surname: surname, age: age)
    }
    
    func getSize() -> Int {
        
        return 3 + nameCount + surnameCount
    }
    
    func isValid() -> Bool {
        return true
    }
    
    func compare() -> Bool {
        return true
    }
}
