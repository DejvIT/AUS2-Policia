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
    
    fileprivate var pathURL: String
    fileprivate var _fileManager: FileManager = FileManager.default
    fileprivate var _fileHandle: FileHandle?
    fileprivate var _scanner: Scanner?
    
    private var _heapFile: HeapFile<Car>?
    private var _bTreeVIN: BTree<CarVIN>?
    private var _bTreeID: BTree<CarID>?
    private var _bTreeDrivingLicense: BTree<DrivingLicense>?
    
    private var _drivingLIcenses: Array<DrivingLicense>?
    private var _cars: Array<Car>?
    
    init() {
        self.pathURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/police_app.bin"
        print(pathURL)
        
        var fileExisted = true
        if (!_fileManager.fileExists(atPath: pathURL)) {
            _fileManager.createFile(atPath: pathURL, contents: nil, attributes: nil)
            fileExisted = false
        }
        _fileHandle = FileHandle(forUpdatingAtPath: pathURL)
        
        if fileExisted {
            readMetaData()
        } else {
            writeMetaData()
        }
    }
    
    var fileManager: FileManager {
        get {
            return self._fileManager
        }
    }
    
    var fileHandle: FileHandle {
        get {
            return self._fileHandle!
        }
    }
    
    var scanner: Scanner {
        get {
            return self._scanner!
        }
    }
    
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
    
    var cars: Array<Car>? {
        get {
            return self._cars
        }
    }
    
    //MARK: - To Bytes
    func metaDataToBytes() -> [UInt8] {
        
        var result: [UInt8] = [UInt8]()
        
        //Heap
        result.append(heapFile?.filenameCount ?? UInt8(0))
        var temp = Data(heapFile?.filename.utf8 ?? String().utf8)
        for char in temp {
            result.append(UInt8(char))
        }
        
        var emptyBytes = (String().maxFileName) - Int(heapFile?.filenameCount ?? 0)
        while emptyBytes > 0 {
            result.append(UInt8.max)
            emptyBytes -= 1
        }
        
        let blockBytes = heapFile?.blockSize.toBytes ?? UInt16(0).toBytes
        for byte in blockBytes {
            result.append(byte)
        }
        
        //BTreeVIN
        result.append(bTreeVIN?.filenameCount ?? UInt8(0))
        temp = Data(bTreeVIN?.filename.utf8 ?? String().utf8)
        for char in temp {
            result.append(UInt8(char))
        }
        
        emptyBytes = (String().maxFileName) - Int(bTreeVIN?.filenameCount ?? 0)
        while emptyBytes > 0 {
            result.append(UInt8.max)
            emptyBytes -= 1
        }
        
        var orderBytes = bTreeVIN?.order.toBytes ?? UInt64(0).toBytes
        for byte in orderBytes {
            result.append(byte)
        }
        
        //BTreeID
        result.append(bTreeVIN?.filenameCount ?? UInt8(0))
        temp = Data(bTreeID?.filename.utf8 ?? String().utf8)
        for char in temp {
            result.append(UInt8(char))
        }
        
        emptyBytes = (String().maxFileName) - Int(bTreeID?.filenameCount ?? 0)
        while emptyBytes > 0 {
            result.append(UInt8.max)
            emptyBytes -= 1
        }
        
        orderBytes = bTreeID?.order.toBytes ?? UInt64(0).toBytes
        for byte in orderBytes {
            result.append(byte)
        }
        
        //BTreeDrivingLicense
        print(bTreeDrivingLicense?.filenameCount ?? UInt8(0))
        result.append(bTreeDrivingLicense?.filenameCount ?? UInt8(0))
        temp = Data(bTreeDrivingLicense?.filename.utf8 ?? String().utf8)
        for char in temp {
            result.append(UInt8(char))
        }
        
        emptyBytes = (String().maxFileName) - Int(bTreeDrivingLicense?.filenameCount ?? 0)
        while emptyBytes > 0 {
            result.append(UInt8.max)
            emptyBytes -= 1
        }
        
        orderBytes = bTreeDrivingLicense?.order.toBytes ?? UInt64(0).toBytes
        for byte in orderBytes {
            result.append(byte)
        }
        
        return result
    }
    
    //MARK: - From Bytes
    func metaDataFromBytes(bytes: [UInt8]) {

        //Heap
        var fileName = ""
        var i = 0
        let heapFilenameCount: UInt8 = bytes[i]
        while i < heapFilenameCount {
            i += 1
            fileName += String(Character(UnicodeScalar(Int(bytes[i]))!))
        }
        
        if (fileName.count > 0) {
            var blockBytes: [UInt8] = []
            for i in 1...UInt16().size {
                blockBytes.append(bytes[i - 1 + fileName.maxFileName + heapFilenameCount.size])
            }
            let blockSize = UInt16(Helper.shared.uInt8ArrayToDecimalString(blockBytes))!
            
            self._heapFile = HeapFile<Car>(Car(), fileName, blockSize)
        }
        
        //BTrees
        for j in 1...3 {
            fileName = ""
            i = 0
            let fileNameCount: UInt8 = bytes[(j * String().maxFileName) + (j * UInt8().size) + UInt16().size + ((j - 1) * UInt64().size)]
            while i < fileNameCount {
                i += 1
                fileName += String(Character(UnicodeScalar(Int(bytes[i + (j * String().maxFileName) + (j * UInt8().size) + UInt16().size + ((j - 1) * UInt64().size)]))!))
            }
            
            if (fileName.count > 0) {
                var orderBytes: [UInt8] = []
                for i in 1...UInt64().size {
                    orderBytes.append(bytes[i + (((j + 1) * String().maxFileName) + (j * UInt8().size) + UInt16().size + ((j - 1) * UInt64().size))])
                }
                let orderSize = UInt64(Helper.shared.uInt8ArrayToDecimalString(orderBytes))!
                
                switch j {
                case 1:
                    self._bTreeVIN = BTree<CarVIN>(CarVIN(), CarVIN.comparator, fileName, orderSize)
                case 2:
                    self._bTreeID = BTree<CarID>(CarID(), CarID.comparator, fileName, orderSize)
                case 3:
                    self._bTreeDrivingLicense = BTree<DrivingLicense>(DrivingLicense(), DrivingLicense.comparator, fileName, orderSize)
                default:
                    break
                }
            }
        }
        
    }
    
    //MARK: - Meta Size
    func getMetaSize() -> Int {
        return 4 * String().maxFileName + 4 * UInt8().size + UInt16().size + 3 * UInt64().size
    }
    
    public func setHeapFile(_ filename: String, _ blockSize: UInt16) {
        self._heapFile = HeapFile<Car>(Car(), filename, blockSize)
        writeMetaData()
    }
    
    public func setBTreeVIN(_ filename: String, _ order: UInt64) {
        self._bTreeVIN = BTree<CarVIN>(CarVIN(), CarVIN.comparator, filename, order)
        writeMetaData()
    }
    
    public func setBTreeID(_ filename: String, _ order: UInt64) {
        self._bTreeID = BTree<CarID>(CarID(), CarID.comparator, filename, order)
        writeMetaData()
    }
    
    public func setBTreeDrivingLicense(_ filename: String, _ order: UInt64) {
        self._bTreeDrivingLicense = BTree<DrivingLicense>(DrivingLicense(), DrivingLicense.comparator, filename, order)
        writeMetaData()
    }
    
    public func generateData(_ countCars: Int, _ countDLs: Int) {
        
        if (heapFile != nil && bTreeID != nil && bTreeVIN != nil) {

            var carsQuantityNeeded = countCars
            while carsQuantityNeeded > 0 {
                let generatedCar = Car().initRandom() as! Car
                if (self.bTreeID!.search(CarID(nil, generatedCar.id)) == nil && self.bTreeVIN!.search(CarVIN(nil, generatedCar.vin)) == nil) {
                    let tempAddress = self._heapFile?.insert(generatedCar)
                    if (self._bTreeVIN!.insert(CarVIN(tempAddress, generatedCar.vin)) && self._bTreeID!.insert(CarID(tempAddress, generatedCar.id))) {
                        carsQuantityNeeded -= 1
                    }
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
        if (bTreeDrivingLicense != nil) {
            self._drivingLIcenses = bTreeDrivingLicense!.fileToRecords(type: DrivingLicense())
        }
    }
    
    public func drivingLicensesCount() -> Int {
        return drivingLicenses?.count ?? 0
    }
    
    public func readCars() {
        if (heapFile != nil) {
            self._cars = heapFile!.fileToRecords(type: Car())
        }
    }
    
    public func carsCount() -> Int {
        return cars?.count ?? 0
    }
    
    func insertCar(_ car: Car) -> Bool {
        if (self.bTreeID!.search(CarID(nil, car.id)) == nil && self.bTreeVIN!.search(CarVIN(nil, car.vin)) == nil) {
            let tempAddress = self._heapFile?.insert(car)
            _ = self._bTreeVIN!.insert(CarVIN(tempAddress, car.vin))
            _ = self._bTreeID!.insert(CarID(tempAddress, car.id))
            return true
        }
        
        return false
    }
    
    func updateDrivingLicense(_ drivingLicense: DrivingLicense) {
        let block = bTreeDrivingLicense?.searchBlock(drivingLicense)
        for i in 0...block!.validRecords - 1 {
            if (block!.records[i].id == drivingLicense.id) {
                block!.updateRecord(drivingLicense, at: i)
                bTreeDrivingLicense?.write(block!)
            }
        }
    }
    
    func updateCar(_ car: Car, atAddress: UInt64) {
        heapFile?.update(car, atAddress: atAddress)
    }
    
    func writeMetaData() {
        _fileHandle?.seek(toFileOffset: 0)
        _fileHandle?.write(Data(metaDataToBytes()))
    }
    
    func readMetaData() {
        
        let length = getMetaSize()
        do {
            try fileHandle.seek(toOffset: 0)
        } catch {
            print(error)
        }
        let data: [UInt8] = [UInt8]((_fileHandle?.readData(ofLength: length))!)
        metaDataFromBytes(bytes: data)
    }
}
