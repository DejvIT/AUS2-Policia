//
//  ViewController.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 16/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var bTreeTest: BTree<Test>! = BTree<Test>(Test(), Test.comparator, "test", 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = bTreeTest.insert(Test(100))
        _ = bTreeTest.insert(Test(200))
        _ = bTreeTest.insert(Test(300))
        _ = bTreeTest.insert(Test(400))
        
        _ = bTreeTest.insert(Test(500))
        _ = bTreeTest.insert(Test(111))
    }
}

