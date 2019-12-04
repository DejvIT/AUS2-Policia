//
//  Help.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 03/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

extension Bool {
    
    var intValue: Int {
        return self ? 1 : 0
    }
    
}

extension Int {
    
    var boolValue: Bool {
        return self == 1 ? true : false
    }
}
