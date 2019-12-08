//
//  PoliceApp.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 08/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import Foundation

public class PoliceApp {
    
    static let shared = PoliceApp()
    
    private var _heapFile: HeapFile<Car>?
    private var _bTreeVIN: BTree<CarVIN>?
    private var _bTreeID: BTree<CarID>?
    private var _bTreeDrivingLicense: BTree<DrivingLicense>?
    
    private var _drivingLIcenses: Array<DrivingLicense>?
    
    var heapFile: HeapFile<Car>? {
        get {
            return self._heapFile
        }
    }
    
    var bTreeVIN: BTree<CarVIN>? {
        get {
            return self._bTreeVIN
        }
    }
    
    var bTreeID: BTree<CarID>? {
        get {
            return self._bTreeID
        }
    }
    
    var bTreeDrivingLicense: BTree<DrivingLicense>? {
        get {
            return self._bTreeDrivingLicense
        }
    }
    
    var drivingLicenses: Array<DrivingLicense>? {
        get {
            return self._drivingLIcenses
        }
    }
    
    public func setHeapFile(_ filename: String, _ blockSize: UInt16) {
        self._heapFile = HeapFile<Car>(Car(), filename, blockSize)
    }
    
    public func setBTreeVIN(_ filename: String, _ blockSize: Int) {
        self._bTreeVIN = BTree<CarVIN>(CarVIN(), CarVIN.comparator, filename, blockSize)
    }
    
    public func setBTreeID(_ filename: String, _ blockSize: Int) {
        self._bTreeID = BTree<CarID>(CarID(), CarID.comparator, filename, blockSize)
    }
    
    public func setBTreeDrivingLicense(_ filename: String, _ blockSize: Int) {
        self._bTreeDrivingLicense = BTree<DrivingLicense>(DrivingLicense(), DrivingLicense.comparator, filename, blockSize)
    }
    
    public func generateData(_ countCars: Int, _ countDLs: Int) {
        
        if (heapFile != nil && bTreeID != nil && bTreeVIN != nil) {

            var carsQuantityNeeded = countCars
            while carsQuantityNeeded > 0 {
                let generatedCar = Car().initRandom() as! Car
                let tempAddress = self._heapFile?.insert(generatedCar)
                if (self._bTreeVIN!.insert(CarVIN(tempAddress, generatedCar.vin)) && self._bTreeID!.insert(CarID(tempAddress, generatedCar.id))) {
                    carsQuantityNeeded -= 1
                }
            }
        }
        
        if (bTreeDrivingLicense != nil) {

            var drivingLicenseQuantityNeeded = countDLs
            while drivingLicenseQuantityNeeded > 0 {
                let generatedLicense = DrivingLicense().initRandom() as! DrivingLicense
                if (self._bTreeDrivingLicense!.insert(generatedLicense)) {
                    drivingLicenseQuantityNeeded -= 1
                }
            }
        }
        
        print("Data have been successfully generated!")
    }
    
    public func printSequenceRead() {
        
        if (heapFile != nil) {
            print("\n##########😎 App HeapFile 😎##########\n")
            print(heapFile!.fileToString(type: Car()))
        }
        
        if (bTreeVIN != nil) {
            print("\n##########😎 App BTree VIN 😎##########\n")
            print(bTreeVIN!.fileToString(type: CarVIN()))
        }
        
        if (bTreeID != nil) {
            print("\n##########😎 App BTree ID 😎##########\n")
            print(bTreeID!.fileToString(type: CarID()))
        }
        
        if (bTreeDrivingLicense != nil) {
            print("\n##########😎 App BTree Driving License 😎##########\n")
            print(bTreeDrivingLicense!.fileToString(type: DrivingLicense()))
        }
    }
    
    public func readDrivingLicenses() {
        self._drivingLIcenses = bTreeDrivingLicense!.fileToRecords(type: DrivingLicense())
    }
    
    public func drivingLicensesCount() -> Int {
        return drivingLicenses?.count ?? 0
    }
}
