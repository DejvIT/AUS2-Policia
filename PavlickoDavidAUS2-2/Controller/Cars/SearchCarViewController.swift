//
//  SearchCarViewController.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 09/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class SearchCarViewController: UIViewController {
    
    let policeApp = PoliceApp.shared
    
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var vinField: UITextField!
    @IBOutlet weak var idSearchButton: UIButton!
    @IBOutlet weak var vinSearchButton: UIButton!
    
    @IBOutlet weak var notFoundLabel: UILabel!
    
    @IBOutlet weak var carView: UIView!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carIdLabel: UILabel!
    @IBOutlet weak var carVinLabel: UILabel!
    @IBOutlet weak var carAxlesLabel: UILabel!
    @IBOutlet weak var carWeightLabel: UILabel!
    @IBOutlet weak var carECDateLabel: UILabel!
    @IBOutlet weak var carTCDateLabel: UILabel!
    
    @IBOutlet weak var showUpdateButton: UIButton!
    
    @IBOutlet weak var updateView: UIView!
    @IBOutlet weak var updateAxlesField: UITextField!
    @IBOutlet weak var updateWeightField: UITextField!
    @IBOutlet weak var updateSearchSwich: UISwitch!
    @IBOutlet weak var updateECDatePicker: UIDatePicker!
    @IBOutlet weak var updateTCDatePicker: UIDatePicker!
    
    var car: Car?
    var carAddress: UInt64?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        updateECDatePicker.backgroundColor = UIColor.white
        updateTCDatePicker.backgroundColor = UIColor.white
        notFoundLabel.isHidden = true
        carView.isHidden = true
        showUpdateButton.isHidden = true
        updateView.isHidden = true
    }

    @IBAction func onIdSearch(_ sender: UIButton) {
        
        if (idField.text != "" && policeApp.heapFile != nil && policeApp.bTreeID != nil && policeApp.bTreeVIN != nil) {
            
            let carID = policeApp.bTreeID?.search(CarID(nil, idField.text!))
            
            if (carID == nil) {
                notFoundLabel.isHidden = false
                carView.isHidden = true
                showUpdateButton.isHidden = true
                updateView.isHidden = true
            } else {
                car = policeApp.heapFile?.getRecord(Car(), carID!.heapAddress)
                carAddress = carID!.heapAddress
                
                carIdLabel.text = "EČV: \(car!.id)"
                carVinLabel.text = "VIN: \(car!.vin)"
                carAxlesLabel.text = "Počet náprav: \(car!.axlesCount)"
                carWeightLabel.text = "Hmotnosť vozidla: \(car!.weight) kg"
                carECDateLabel.text = "Koniec EK: \(car!.dateEndEC.toString())"
                carTCDateLabel.text = "Koniec TK: \(car!.dateEndTC.toString())"
                
                if (car!.dateEndEC.isValid()) {
                    carECDateLabel.textColor = UIColor.green
                } else {
                    carECDateLabel.textColor = UIColor.red
                }
                
                if (car!.dateEndTC.isValid()) {
                    carTCDateLabel.textColor = UIColor.green
                } else {
                    carTCDateLabel.textColor = UIColor.red
                }
                
                if (car!.inSearch) {
                    carImage.backgroundColor = UIColor.red
                    carImage.tintColor = UIColor.black
                } else {
                    carImage.backgroundColor = UIColor.clear
                    carImage.tintColor = UIColor.blue
                }
                
                //UpdateForm
                updateAxlesField.text = "\(car!.axlesCount)"
                updateWeightField.text = "\(car!.weight)"
                updateSearchSwich.setOn(car!.inSearch, animated: true)
                //EndofUpdate
                
                carView.isHidden = false
                notFoundLabel.isHidden = true
                showUpdateButton.isHidden = false
                updateView.isHidden = true
            }
            
            idField.text = ""
            vinField.text = ""
        }
    }
    
    @IBAction func onVinSearch(_ sender: UIButton) {
        
        if (vinField.text != "" && policeApp.heapFile != nil && policeApp.bTreeID != nil && policeApp.bTreeVIN != nil) {
            
            let carVIN = policeApp.bTreeVIN?.search(CarVIN(nil, vinField.text!))
            
            if (carVIN == nil) {
                notFoundLabel.isHidden = false
                carView.isHidden = true
                showUpdateButton.isHidden = true
                updateView.isHidden = true
            } else {
                car = policeApp.heapFile?.getRecord(Car(), carVIN!.heapAddress)
                carAddress = carVIN!.heapAddress
                
                carIdLabel.text = "EČV: \(car!.id)"
                carVinLabel.text = "VIN: \(car!.vin)"
                carAxlesLabel.text = "Počet náprav: \(car!.axlesCount)"
                carWeightLabel.text = "Hmotnosť vozidla: \(car!.weight) kg"
                carECDateLabel.text = "Koniec EK: \(car!.dateEndEC.toString())"
                carTCDateLabel.text = "Koniec TK: \(car!.dateEndTC.toString())"
                
                if (car!.dateEndEC.isValid()) {
                    carECDateLabel.textColor = UIColor.green
                } else {
                    carECDateLabel.textColor = UIColor.red
                }
                
                if (car!.dateEndTC.isValid()) {
                    carTCDateLabel.textColor = UIColor.green
                } else {
                    carTCDateLabel.textColor = UIColor.red
                }
                
                if (car!.inSearch) {
                    carImage.backgroundColor = UIColor.red
                    carImage.tintColor = UIColor.black
                } else {
                    carImage.backgroundColor = UIColor.clear
                    carImage.tintColor = UIColor.blue
                }
                
                //UpdateForm
                updateAxlesField.text = "\(car!.axlesCount)"
                updateWeightField.text = "\(car!.weight)"
                updateSearchSwich.setOn(car!.inSearch, animated: true)
                //EndofUpdate
                
                carView.isHidden = false
                notFoundLabel.isHidden = true
                showUpdateButton.isHidden = false
                updateView.isHidden = true
            }
            
            idField.text = ""
            vinField.text = ""
        }
    }
    
    @IBAction func onShowUpdate(_ sender: UIButton) {
        updateView.isHidden = false
    }
    
    @IBAction func onUpdate(_ sender: UIButton) {
        
        if (updateAxlesField.text != "" && updateWeightField.text != "" && car != nil && carAddress != nil) {
            
            car!.setWeight(UInt16(updateWeightField.text!)!)
            car!.setAxlesCount(UInt8(updateAxlesField.text!)!)
            
            if (updateSearchSwich.isOn) {
                car!.setInSearch(true)
            } else {
                car!.setInSearch(false)
            }
            
            let calendar = Calendar.current
            var components = calendar.dateComponents([.day,.month,.year], from: self.updateECDatePicker.date)
            var expDay = UInt8(1)
            var expMonth = UInt8(1)
            var expYear = UInt16(1970)
            if let day = components.day, let month = components.month, let year = components.year {
                expDay = UInt8(day)
                expMonth = UInt8(month)
                expYear = UInt16(year)
            }
            
            car!.setdateEndEC(AppDate(expDay, expMonth, expYear))
            
            components = calendar.dateComponents([.day,.month,.year], from: self.updateTCDatePicker.date)
            if let day = components.day, let month = components.month, let year = components.year {
                expDay = UInt8(day)
                expMonth = UInt8(month)
                expYear = UInt16(year)
            }
            
            car!.setdateEndTC(AppDate(expDay, expMonth, expYear))
            
            policeApp.updateCar(car!, atAddress: carAddress!)
            
            updateAxlesField.text = ""
            updateWeightField.text = ""
        }
    }
}
