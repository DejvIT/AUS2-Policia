//
//  Record.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 16/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

protocol Record {
    
    func initEmpty() -> Any
    
    func toBytes() -> [UInt8]
    
    func fromBytes(bytes: [UInt8]) -> Any
    
    func getSize() -> Int
    
    func toString() -> String
    
    func isEmpty() -> Bool
    
    func initRandom() -> Any
    
}
