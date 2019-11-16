//
//  ViewController.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 16/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let importExport = ImportExport()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let person = Person(name: "Dejv", surname: "Unknown", age: 23)
        let binars = person.toBytes()
        print(binars)
        
        let newPerson = person.fromBytes(bytes: binars)
        print(newPerson)
    }

    func bits() {
//        let name = "DAVID"
//        let binaryData = Data(name.utf8)
//        print([UInt8](binaryData))
//
//        var string = ""
//        for index in binaryData {
//            string += String(index, radix: 2)
//            print("\(string) | \(string.count)")
//        }
    
        let number = 111
        let binaryData = UInt16(number).binaryDescription
        print(UInt16(number).binaryDescription)
        print(Int(binaryData, radix: 2)!)
    }
    
    func import() {
        importExport.prepareForImport()
        
        importExport.read { [weak self] component in
            if let component = component {
                
            }
        }
    }
    
    func export () {
        
        importExport.prepareForExport()
        
        importExport.write(line: "TIME;\(airport.time.toExport())\n")
        
    }

}

