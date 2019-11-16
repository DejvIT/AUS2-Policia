//
//  Converter.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 16/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

public class Converter {
    
    var _byte: UInt8
    
    init(_ byte: UInt8) {
        self._byte = byte
    }
    
    var byte: UInt8 {
        return self._byte
    }
}
