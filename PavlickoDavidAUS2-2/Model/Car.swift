//
//  Car.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 02/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

class Car: Record {
    
    private var _id: String
    private var _idCount: Int
    private var _vin: String
    private var _vinCount: Int
    private var _axlesCount: Int
    private var _weight: Int
    private var _inSearch: Bool
    private var _dateEndEC: Date
    private var _dateEndTC: Date
    
    init() {
        self._id = ""
        self._idCount = 0
        self._vin = ""
        self._vinCount = 0
        self._axlesCount = 255
        self._weight = Int.max
        self._inSearch = false
        self._dateEndEC = Date()
        self._dateEndTC = Date()
    }
    
    func initEmpty() -> Any {
        return Car() as Any
    }

    func toBytes() -> [UInt8] {
        var result: [UInt8] = []
        
        return result
    }

    func fromBytes(bytes: [UInt8]) -> Any {
        return Car() as Any
    }

    func getSize() -> Int {
        return -1
    }

    func getKeyToString() -> String {
        return "[\(self._vin), \(self)"
    }
    
    func toString() -> String {
        var result: String = ""
        
        return result
    }

    func isEmpty() -> Bool {
        return true
    }
}
