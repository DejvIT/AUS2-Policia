//
//  ViewController.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 16/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var bTreeTest: BTree<Test>! = BTree<Test>(Test.comparator, 5, 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = bTreeTest.insert(Test(256))
        _ = bTreeTest.insert(Test(233))
        
        _ = bTreeTest.insert(Test(999))
    }
}

