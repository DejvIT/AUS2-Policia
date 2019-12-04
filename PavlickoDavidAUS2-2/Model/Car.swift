//
//  Car.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 02/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

class Car: Record {
    
    private var _vin: String
    
    init() {
        self._vin = ""
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

    func toString() -> String {
        var result: String = ""
        
        return result
    }

    func isEmpty() -> Bool {
        return true
    }
}
