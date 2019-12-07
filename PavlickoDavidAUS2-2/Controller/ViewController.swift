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

//        testGenerator()
//        lectureTest()
        drivingLicenseTest()
    }
    
    public func testGenerator() {

            let generator = Generator(50, "generator")
            generator.bTree(loop: 1000, insert: 10, search: 0, delete: 0, progressBar: nil)
//            generator.insertExact()
            generator.bTreeSearch()
            print(generator.getResult())
            print(generator.bTreeTest.fileToString(type: Test()))
    }
    
    public func drivingLicenseTest() {
        
        let bTreeTest: BTree<DrivingLicense>! = BTree<DrivingLicense>(DrivingLicense(), DrivingLicense.comparator, "drivinglicense", 3)
        
        _ = bTreeTest.insert(DrivingLicense(id: 1, name: "Test", surname: "Adin", dateTime: 2141231, validLicense: true, offenses: 0))
        _ = bTreeTest.insert(DrivingLicense(id: 2, name: "Test", surname: "Dva", dateTime: 2141231, validLicense: true, offenses: 1))
        _ = bTreeTest.insert(DrivingLicense(id: 3, name: "Test", surname: "Tri", dateTime: 2141231, validLicense: true, offenses: 2))
        _ = bTreeTest.insert(DrivingLicense(id: 4, name: "Test", surname: "Cetyre", dateTime: 2141231, validLicense: true, offenses: 3))
        _ = bTreeTest.insert(DrivingLicense(id: 5, name: "Test", surname: "Piat", dateTime: 2141231, validLicense: true, offenses: 8))
        _ = bTreeTest.insert(DrivingLicense(id: 6, name: "Test", surname: "Sest", dateTime: 2141231, validLicense: true, offenses: 12))
        _ = bTreeTest.insert(DrivingLicense(id: 7, name: "Test", surname: "Sedm", dateTime: 2141231, validLicense: true, offenses: 0))
        _ = bTreeTest.insert(DrivingLicense(id: 8, name: "Test", surname: "Vosm", dateTime: 2141231, validLicense: true, offenses: 6))
        
        print(bTreeTest.fileToString(type: DrivingLicense()))
    }
    
    public func lectureTest() {
        
        //A B C D E F G H I J K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z
        //0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
        let bTreeTest: BTree<Test>! = BTree<Test>(Test(), Test.comparator, "test", 5)
        
        _ = bTreeTest.insert(Test(2))
        _ = bTreeTest.insert(Test(13))
        _ = bTreeTest.insert(Test(6))
        _ = bTreeTest.insert(Test(0))
        
        _ = bTreeTest.insert(Test(7))
        
        _ = bTreeTest.insert(Test(4))
        _ = bTreeTest.insert(Test(10))
        _ = bTreeTest.insert(Test(16))
        
        _ = bTreeTest.insert(Test(12))
        
        _ = bTreeTest.insert(Test(5))
        _ = bTreeTest.insert(Test(22))
        _ = bTreeTest.insert(Test(11))
        _ = bTreeTest.insert(Test(19))
        
        _ = bTreeTest.insert(Test(25))
        
        _ = bTreeTest.insert(Test(3))
        _ = bTreeTest.insert(Test(15))
        _ = bTreeTest.insert(Test(17))
        _ = bTreeTest.insert(Test(23))
        _ = bTreeTest.insert(Test(24))
        
        _ = bTreeTest.insert(Test(18))
        //End of lecture
        
        print(bTreeTest.fileToString(type: Test()))
    }
    
}

