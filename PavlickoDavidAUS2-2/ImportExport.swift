//
//  ImportExport.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 16/11/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

final class ImportExport<T: Record> {
    
    fileprivate var filename: String
    fileprivate var pathURL: String
    fileprivate var _fileManager: FileManager = FileManager.default
    fileprivate var _fileHandle: FileHandle?
    fileprivate var _scanner: Scanner?
    
    init(_ record: T) {
        self.filename = record.filename()
        self.pathURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + filename + ".bin"
        print(pathURL)
        
        if !fileManager.fileExists(atPath: pathURL) {
            _fileManager.createFile(atPath: pathURL, contents: nil, attributes: nil)
        }
        _fileHandle = FileHandle(forUpdatingAtPath: pathURL)
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
}

extension ImportExport {
    
    func write(line: String) {
        let output = line
        _fileHandle?.write(output.data(using: String.Encoding.utf8)!)
    }
    
    func prepareForImport() {
        let binFile = try! String(contentsOfFile: self.pathURL, encoding: String.Encoding.utf8)
        self._scanner = Scanner(string: binFile)
    }
    
    func read(newLine: @escaping ([String]?) -> ()) {
        while let str: String = scanner.scanUpToString(" ") {
            let components = str.components(separatedBy: " ")
            newLine(components)
        }
    }
    
    public func insert(block: Block<T>, address: UInt64) {
        _fileHandle?.seek(toFileOffset: address)
        _fileHandle?.write(Data(block.toBytes()))
    }
    
    public func getBlock(address: UInt64, record: T) -> Block<T> {
        let length = record.getSize()
        do {
            try fileHandle.seek(toOffset: address * UInt64(length))
        } catch {
            print(error)
        }
        let data: [UInt8] = [UInt8]((_fileHandle?.readData(ofLength: length))!)
        return Block(bytes: data, size: 1, address: address, record: record)
    }
}
