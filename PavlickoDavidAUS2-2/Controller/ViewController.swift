//
//  ViewController.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 16/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let block = Block<Person>(size: 2)
        block.insert(block: block, address: 1)
        let person = Person(name: "Dejv", surname: "Unknown", age: 23)

        let bytes = person.toBytes()
        print(bytes)

        let newPerson = person.fromBytes(bytes: bytes)
        print(newPerson)
        
    }
}

