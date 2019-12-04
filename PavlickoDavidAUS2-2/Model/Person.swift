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
    
    init() {
        self._name = ""
        self._nameCount = 0
        self._surname = ""
        self._surnameCount = 0
        self._age = 0
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
    
    func filename() -> String {
        return "person"
    }
    
    func toBytes() -> [UInt8] {
        
        var result: [UInt8] = [UInt8]()
        
        result.append(UInt8(self.nameCount))
        result.append(UInt8(self.surnameCount))
        
        var temp = Data(self.name.utf8)
        for char in temp {
            result.append(UInt8(char))
        }
        
        var emptyBytes = 20 - self.nameCount
        while emptyBytes > 0 {
            result.append(UInt8(0))
            emptyBytes -= 1
        }
        
        temp = Data(self.surname.utf8)
        for char in temp {
            result.append(UInt8(char))
        }
        
        emptyBytes = 20 - self.surnameCount
        while emptyBytes > 0 {
            result.append(UInt8(0))
            emptyBytes -= 1
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
            surname += String(Character(UnicodeScalar(Int(bytes[2 + i + 20]))!))
            i += 1
        }
        
        return Person(name: name, surname: surname, age: age)
    }
    
    func getSize() -> Int {
        
        return 3 + 20 + 20
    }
    
    func compare() -> Any {
        return age
    }
    
    func toString() -> String {
        return "Meno: \(name), Priezvisko: \(surname), Vek: \(age)"
    }
    
    static let comparator: Comparator = {
        lhs, rhs in guard let first = lhs as? Person, let second = rhs as? Person else {
            return ComparisonResult.orderedSame
        }
        
        if (first.age == second.age) {
            return ComparisonResult.orderedSame
        } else if (first.age < second.age) {
            return ComparisonResult.orderedAscending
        } else {
            return ComparisonResult.orderedDescending
        }
    }
    
    public func getComparator() -> Comparator {
        return Person.comparator
    }
    
    func emptyBytes() -> [UInt8] {
        
        var result: [UInt8] = [UInt8]()
        
        var i = 0
        while i < getSize() {
            result.append((UInt8(0)))
            i += 1
        }
        
        return result
    }
    
    func initEmpty() -> Any {
        return Person() as Any
    }
    
    func isEmpty() -> Bool {
        if (name == "" && nameCount == 0 && surname == "" && surnameCount == 0 && age == 0) {
            return true
        }
        
        return false
    }
}
