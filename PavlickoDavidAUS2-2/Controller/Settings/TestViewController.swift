//
//  TestViewController.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 08/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var testAppButton: UIButton!
    @IBOutlet weak var testButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testAppButton.layer.borderColor = UIColor.black.cgColor
        testAppButton.layer.borderWidth = 2
        testAppButton.layer.cornerRadius = 50
        testAppButton.layer.shadowColor = UIColor.white.cgColor
        testAppButton.layer.shadowRadius = 5
        testAppButton.layer.shadowOpacity = 0.75
        testAppButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        testButton.layer.borderColor = UIColor.black.cgColor
        testButton.layer.borderWidth = 2
        testButton.layer.cornerRadius = 50
        testButton.layer.shadowColor = UIColor.white.cgColor
        testButton.layer.shadowRadius = 5
        testButton.layer.shadowOpacity = 0.75
        testButton.layer.shadowOffset = CGSize(width: 0, height: 3)
    }

    @IBAction func onTestApp(_ sender: UIButton) {
        let loadingSpinner = Spinner.customBackground(onView: self.view)
        DispatchQueue.global(qos: .background).async {

            PoliceApp.shared.printSequenceRead()
            
            DispatchQueue.main.async {
                Spinner.removeSpinner(spinner: loadingSpinner)
            }
        }
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
        let bTreeTestVIN: BTree<CarVIN>! = BTree<CarVIN>(CarVIN(), CarVIN.comparator, "cars_vin", 3)
        let bTreeTestID: BTree<CarID>! = BTree<CarID>(CarID(), CarID.comparator, "cars_id", 5)
        let date = AppDate(23, 6, 1996)
        
        let car1 = Car(id: "1", vin: "VIN", axles: 4, weight: 1500, inSearch: false, endEC: date, endTC: date)
        let car2 = Car(id: "5", vin: "VIN 2", axles: 2, weight: 950, inSearch: false, endEC: date, endTC: date)
        let car3 = Car(id: "13", vin: "VIN 3", axles: 3, weight: 1500, inSearch: true, endEC: date, endTC: date)
        let car4 = Car(id: "11", vin: "VINko", axles: 2, weight: 1200, inSearch: false, endEC: date, endTC: date)
        let car5 = Car(id: "0", vin: "VINlofas", axles: 4, weight: 1500, inSearch: false, endEC: date, endTC: date)
        let car6 = Car(id: "8", vin: "VINmrdko", axles: 4, weight: 1500, inSearch: true, endEC: date, endTC: date)
        let car7 = Car(id: "9", vin: "VIN aa", axles: 2, weight: 1500, inSearch: false, endEC: date, endTC: date)
        let car8 = Car(id: "A", vin: "VINsa", axles: 4, weight: 850, inSearch: false, endEC: date, endTC: date)
        let car9 = Car(id: "c", vin: "ds", axles: 4, weight: 1500, inSearch: true, endEC: date, endTC: date)
        let car10 = Car(id: "G", vin: "sadfc", axles: 4, weight: 1500, inSearch: false, endEC: date, endTC: date)
        let car11 = Car(id: "L", vin: "fdsfdoi", axles: 2, weight: 1500, inSearch: false, endEC: date, endTC: date)
        let car12 = Car(id: "X", vin: "3r4fr", axles: 4, weight: 777, inSearch: false, endEC: date, endTC: date)
        let car13 = Car(id: "9", vin: "4r3fef", axles: 4, weight: 1500, inSearch: true, endEC: date, endTC: date)
        let car14 = Car(id: "3", vin: "34ffdsd", axles: 2, weight: 1500, inSearch: false, endEC: date, endTC: date)
        let car15 = Car(id: "P", vin: "43fd", axles: 4, weight: 1437, inSearch: false, endEC: date, endTC: date)
        
        let car1Address = heapFileTest.insert(car1)
        _ = bTreeTestVIN.insert(CarVIN(car1Address, car1.vin))
        _ = bTreeTestID.insert(CarID(car1Address, car1.id))
        let car2Address = heapFileTest.insert(car2)
        _ = bTreeTestVIN.insert(CarVIN(car2Address, car2.vin))
        _ = bTreeTestID.insert(CarID(car2Address, car2.id))
        let car3Address = heapFileTest.insert(car3)
        _ = bTreeTestVIN.insert(CarVIN(car3Address, car3.vin))
        _ = bTreeTestID.insert(CarID(car3Address, car3.id))
        let car4Address = heapFileTest.insert(car4)
        _ = bTreeTestVIN.insert(CarVIN(car4Address, car4.vin))
        _ = bTreeTestID.insert(CarID(car4Address, car4.id))
        let car5Address = heapFileTest.insert(car5)
        _ = bTreeTestVIN.insert(CarVIN(car5Address, car5.vin))
        _ = bTreeTestID.insert(CarID(car5Address, car5.id))
        let car6Address = heapFileTest.insert(car6)
        _ = bTreeTestVIN.insert(CarVIN(car6Address, car6.vin))
        _ = bTreeTestID.insert(CarID(car6Address, car6.id))
        let car7Address = heapFileTest.insert(car7)
        _ = bTreeTestVIN.insert(CarVIN(car7Address, car7.vin))
        _ = bTreeTestID.insert(CarID(car7Address, car7.id))
        let car8Address = heapFileTest.insert(car8)
        _ = bTreeTestVIN.insert(CarVIN(car8Address, car8.vin))
        _ = bTreeTestID.insert(CarID(car8Address, car8.id))
        let car9Address = heapFileTest.insert(car9)
        _ = bTreeTestVIN.insert(CarVIN(car9Address, car9.vin))
        _ = bTreeTestID.insert(CarID(car9Address, car9.id))
        let car10Address = heapFileTest.insert(car10)
        _ = bTreeTestVIN.insert(CarVIN(car10Address, car10.vin))
        _ = bTreeTestID.insert(CarID(car10Address, car10.id))
        let car11Address = heapFileTest.insert(car11)
        _ = bTreeTestVIN.insert(CarVIN(car11Address, car11.vin))
        _ = bTreeTestID.insert(CarID(car11Address, car11.id))
        let car12Address = heapFileTest.insert(car12)
        _ = bTreeTestVIN.insert(CarVIN(car12Address, car12.vin))
        _ = bTreeTestID.insert(CarID(car12Address, car12.id))
        let car13Address = heapFileTest.insert(car13)
        _ = bTreeTestVIN.insert(CarVIN(car13Address, car13.vin))
        _ = bTreeTestID.insert(CarID(car13Address, car13.id))
        let car14Address = heapFileTest.insert(car14)
        _ = bTreeTestVIN.insert(CarVIN(car14Address, car14.vin))
        _ = bTreeTestID.insert(CarID(car14Address, car14.id))
        let car15Address = heapFileTest.insert(car15)
        _ = bTreeTestVIN.insert(CarVIN(car15Address, car15.vin))
        _ = bTreeTestID.insert(CarID(car15Address, car15.id))
        
        print(heapFileTest.fileToString(type: Car()))
        print(bTreeTestVIN.fileToString(type: CarVIN()))
        print(bTreeTestID.fileToString(type: CarID()))
        
        var searchCar = heapFileTest.getRecord(car1, car1Address)
        print("1.) " + searchCar.toString())
        searchCar = heapFileTest.getRecord(car2, car2Address)
        print("2.) " + searchCar.toString())
        searchCar = heapFileTest.getRecord(car3, car3Address)
        print("3.) " + searchCar.toString())
        searchCar = heapFileTest.getRecord(car4, car4Address)
        print("4.) " + searchCar.toString())
        searchCar = heapFileTest.getRecord(car5, car5Address)
        print("5.) " + searchCar.toString())
        searchCar = heapFileTest.getRecord(car6, car6Address)
        print("6.) " + searchCar.toString())
        searchCar = heapFileTest.getRecord(car7, car7Address)
        print("7.) " + searchCar.toString())
        searchCar = heapFileTest.getRecord(car8, car8Address)
        print("8.) " + searchCar.toString())
        searchCar = heapFileTest.getRecord(car9, car9Address)
        print("9.) " + searchCar.toString())
        searchCar = heapFileTest.getRecord(car10, car10Address)
        print("10.) " + searchCar.toString())
        searchCar = heapFileTest.getRecord(car11, car11Address)
        print("12.) " + searchCar.toString())
        searchCar = heapFileTest.getRecord(car12, car12Address)
        print("13.) " + searchCar.toString())
        searchCar = heapFileTest.getRecord(car13, car13Address)
        print("14.) " + searchCar.toString())
        searchCar = heapFileTest.getRecord(car14, car14Address)
        print("15.) " + searchCar.toString())
        searchCar = heapFileTest.getRecord(car15, car15Address)
        print("15.) " + searchCar.toString())
        
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
        let date = AppDate(23, 6, 1996)
        
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
        let date = AppDate(23, 6, 1996)
        
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
