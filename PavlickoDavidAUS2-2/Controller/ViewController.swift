//
//  ViewController.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 16/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var importExport = ImportExport(Person())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let block = Block<Person>(size: 4, address: 0)
        let person = Person(name: "Dejv", surname: "Unknown", age: 23)
        _ = block.insert(record: person)
        
        importExport.insert(block: block, address: block.address!)
        let result = importExport.getBlock(address: 0, record: Person())
        print(result)

//        let bytes = person.toBytes()
//        print(bytes)
//
//        let newPerson = person.fromBytes(bytes: bytes)
//        print(newPerson)
        
    }
}

