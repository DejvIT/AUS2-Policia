//
//  ViewController.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 16/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onTest(_ sender: UIButton) {
//        testGenerator()
//        lectureTest()
//        drivingLicenseTest()
//        printIntMaxes()
//        carTest()
//        carIDTest()
//        carVINTest()
        testHeapFile()
    }
    
    public func printIntMaxes() {
        
        print(Int.max)
        print(UInt8.max)
        print(UInt16.max)
        print(UInt32.max)
        print(UInt64.max)
        
    }
    
    public func testHeapFile() {

        let heapFileTest: HeapFile<Car>! = HeapFile<Car>(Car(), "heap_cars", 4)
        let date = Date(23, 6, 1996)
        
        var addresses: Array<UInt64> = Array()
        
        addresses.append(heapFileTest.insert(Car(id: "1", vin: "VIN", axles: 4, weight: 1500, inSearch: false, endEC: date, endTC: date)))
        addresses.append(heapFileTest.insert(Car(id: "5", vin: "VIN 2", axles: 2, weight: 950, inSearch: false, endEC: date, endTC: date)))
        addresses.append(heapFileTest.insert(Car(id: "13", vin: "VIN 3", axles: 3, weight: 1500, inSearch: true, endEC: date, endTC: date)))
        addresses.append(heapFileTest.insert(Car(id: "11", vin: "VINko", axles: 2, weight: 1200, inSearch: false, endEC: date, endTC: date)))
        addresses.append(heapFileTest.insert(Car(id: "0", vin: "VINlofas", axles: 4, weight: 1500, inSearch: false, endEC: date, endTC: date)))
        addresses.append(heapFileTest.insert(Car(id: "8", vin: "VINmrdko", axles: 4, weight: 1500, inSearch: true, endEC: date, endTC: date)))
        addresses.append(heapFileTest.insert(Car(id: "9", vin: "VIN aa", axles: 2, weight: 1500, inSearch: false, endEC: date, endTC: date)))
        addresses.append(heapFileTest.insert(Car(id: "A", vin: "VINsa", axles: 4, weight: 850, inSearch: false, endEC: date, endTC: date)))
        addresses.append(heapFileTest.insert(Car(id: "c", vin: "ds", axles: 4, weight: 1500, inSearch: true, endEC: date, endTC: date)))
        addresses.append(heapFileTest.insert(Car(id: "G", vin: "sadfc", axles: 4, weight: 1500, inSearch: false, endEC: date, endTC: date)))
        addresses.append(heapFileTest.insert(Car(id: "L", vin: "fdsfdoi", axles: 2, weight: 1500, inSearch: false, endEC: date, endTC: date)))
        addresses.append(heapFileTest.insert(Car(id: "X", vin: "3r4fr", axles: 4, weight: 777, inSearch: false, endEC: date, endTC: date)))
        addresses.append(heapFileTest.insert(Car(id: "9", vin: "4r3fef", axles: 4, weight: 1500, inSearch: true, endEC: date, endTC: date)))
        addresses.append(heapFileTest.insert(Car(id: "3", vin: "34ffdsd", axles: 2, weight: 1500, inSearch: false, endEC: date, endTC: date)))
        addresses.append(heapFileTest.insert(Car(id: "P", vin: "43fd", axles: 4, weight: 1437, inSearch: false, endEC: date, endTC: date)))
        
        print(heapFileTest.fileToString(type: Car()))
    }
    
    public func testGenerator() {

            let generator = Generator(5, "testing_generator")
            generator.bTree(loop: 10000, insert: 10, search: 0, delete: 0, progressBar: nil)
//            generator.insertExact()
            generator.bTreeSearch()
            print(generator.getResult())
//            print(generator.bTreeTest.fileToString(type: Test()))
    }
    
    public func carVINTest() {
        
        let bTreeTest: BTree<CarVIN>! = BTree<CarVIN>(CarVIN(), CarVIN.comparator, "cars_vin", 3)
        
        _ = bTreeTest.insert(CarVIN(nil, "5"))
        _ = bTreeTest.insert(CarVIN(nil, "3"))
        _ = bTreeTest.insert(CarVIN(nil, "2"))
        _ = bTreeTest.insert(CarVIN(nil, "8"))
        _ = bTreeTest.insert(CarVIN(nil, "6"))
        _ = bTreeTest.insert(CarVIN(nil, "1"))
        _ = bTreeTest.insert(CarVIN(nil, "4"))
        _ = bTreeTest.insert(CarVIN(nil, "9"))
        _ = bTreeTest.insert(CarVIN(nil, "7"))
        
        print(bTreeTest.fileToString(type: CarVIN()))
    }
    
    public func carIDTest() {
        
        let bTreeTest: BTree<CarID>! = BTree<CarID>(CarID(), CarID.comparator, "cars_id", 3)
        
        _ = bTreeTest.insert(CarID(nil, "5"))
        _ = bTreeTest.insert(CarID(nil, "3"))
        _ = bTreeTest.insert(CarID(nil, "2"))
        _ = bTreeTest.insert(CarID(nil, "8"))
        _ = bTreeTest.insert(CarID(nil, "6"))
        _ = bTreeTest.insert(CarID(nil, "1"))
        _ = bTreeTest.insert(CarID(nil, "4"))
        _ = bTreeTest.insert(CarID(nil, "9"))
        _ = bTreeTest.insert(CarID(nil, "7"))
        
        print(bTreeTest.fileToString(type: CarID()))
    }
    
    public func carTest() {
        
        let bTreeTest: BTree<Car>! = BTree<Car>(Car(), Car.comparator, "test_cars", 3)
        let date = Date(23, 6, 1996)
        
        _ = bTreeTest.insert(Car(id: "1", vin: "VIN", axles: 4, weight: 1500, inSearch: false, endEC: date, endTC: date))
        _ = bTreeTest.insert(Car(id: "5", vin: "VIN 2", axles: 2, weight: 950, inSearch: false, endEC: date, endTC: date))
        _ = bTreeTest.insert(Car(id: "13", vin: "VIN 3", axles: 3, weight: 1500, inSearch: true, endEC: date, endTC: date))
        _ = bTreeTest.insert(Car(id: "11", vin: "VINko", axles: 2, weight: 1200, inSearch: false, endEC: date, endTC: date))
        _ = bTreeTest.insert(Car(id: "0", vin: "VINlofas", axles: 4, weight: 1500, inSearch: false, endEC: date, endTC: date))
        _ = bTreeTest.insert(Car(id: "8", vin: "VINmrdko", axles: 4, weight: 1500, inSearch: true, endEC: date, endTC: date))
        _ = bTreeTest.insert(Car(id: "9", vin: "VIN aa", axles: 2, weight: 1500, inSearch: false, endEC: date, endTC: date))
        _ = bTreeTest.insert(Car(id: "A", vin: "VINsa", axles: 4, weight: 850, inSearch: false, endEC: date, endTC: date))
        _ = bTreeTest.insert(Car(id: "c", vin: "ds", axles: 4, weight: 1500, inSearch: true, endEC: date, endTC: date))
        _ = bTreeTest.insert(Car(id: "G", vin: "sadfc", axles: 4, weight: 1500, inSearch: false, endEC: date, endTC: date))
        _ = bTreeTest.insert(Car(id: "L", vin: "fdsfdoi", axles: 2, weight: 1500, inSearch: false, endEC: date, endTC: date))
        _ = bTreeTest.insert(Car(id: "X", vin: "3r4fr", axles: 4, weight: 777, inSearch: false, endEC: date, endTC: date))
        _ = bTreeTest.insert(Car(id: "9", vin: "4r3fef", axles: 4, weight: 1500, inSearch: true, endEC: date, endTC: date))
        _ = bTreeTest.insert(Car(id: "3", vin: "34ffdsd", axles: 2, weight: 1500, inSearch: false, endEC: date, endTC: date))
        _ = bTreeTest.insert(Car(id: "P", vin: "43fd", axles: 4, weight: 1437, inSearch: false, endEC: date, endTC: date))
        
        print(bTreeTest.fileToString(type: Car()))
    }
    
    public func drivingLicenseTest() {
        
        let bTreeTest: BTree<DrivingLicense>! = BTree<DrivingLicense>(DrivingLicense(), DrivingLicense.comparator, "driving_licenses", 3)
        let date = Date(23, 6, 1996)
        
        _ = bTreeTest.insert(DrivingLicense(id: 1, name: "David", surname: "Adin", expiration: date, validLicense: true, offenses: 0))
        _ = bTreeTest.insert(DrivingLicense(id: 2, name: "Rene", surname: "Dva", expiration: date, validLicense: false, offenses: 1))
        _ = bTreeTest.insert(DrivingLicense(id: 3, name: "Fero", surname: "Tri", expiration: date, validLicense: true, offenses: 2))
        _ = bTreeTest.insert(DrivingLicense(id: 4, name: "Ladislav", surname: "Cetyre", expiration: date, validLicense: true, offenses: 3))
        _ = bTreeTest.insert(DrivingLicense(id: 5, name: "Mrazik", surname: "Piat", expiration: date, validLicense: false, offenses: 8))
        _ = bTreeTest.insert(DrivingLicense(id: 6, name: "Leonidas", surname: "Sest", expiration: date, validLicense: false, offenses: 12))
        _ = bTreeTest.insert(DrivingLicense(id: 7, name: "Ondra", surname: "Sedm", expiration: date, validLicense: true, offenses: 0))
        _ = bTreeTest.insert(DrivingLicense(id: 8, name: "Jany", surname: "Vosm", expiration: date, validLicense: true, offenses: 6))
        
        print(bTreeTest.fileToString(type: DrivingLicense()))
    }
    
    public func lectureTest() {
        
        //A B C D E F G H I J K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z
        //0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
        let bTreeTest: BTree<Test>! = BTree<Test>(Test(), Test.comparator, "lecture_btree", 5)
        
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

