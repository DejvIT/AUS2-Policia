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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {

        notFoundLabel.isHidden = true
        carView.isHidden = true
    }

    @IBAction func onIdSearch(_ sender: UIButton) {
        
        if (idField.text != "" && policeApp.heapFile != nil && policeApp.bTreeID != nil && policeApp.bTreeVIN != nil) {
            
            let car = policeApp.bTreeID?.search(CarID(nil, idField.text!))
            
            if (car == nil) {
                notFoundLabel.isHidden = false
                carView.isHidden = true
            } else {
                let heapCar = policeApp.heapFile?.getRecord(Car(), car!.heapAddress)
                
                carIdLabel.text = "\(heapCar!.id)"
                carVinLabel.text = "\(heapCar!.vin)"
                carAxlesLabel.text = "\(heapCar!.axlesCount)"
                carWeightLabel.text = "\(heapCar!.weight) kg"
                carECDateLabel.text = "\(heapCar!.dateEndEC.toString())"
                carTCDateLabel.text = "\(heapCar!.dateEndTC.toString())"
                
                if (heapCar!.dateEndEC.isValid()) {
                    carECDateLabel.textColor = UIColor.green
                } else {
                    carECDateLabel.textColor = UIColor.red
                }
                
                if (heapCar!.dateEndTC.isValid()) {
                    carTCDateLabel.textColor = UIColor.green
                } else {
                    carTCDateLabel.textColor = UIColor.red
                }
                
                if (heapCar!.inSearch) {
                    carImage.backgroundColor = UIColor.red
                    carImage.tintColor = UIColor.black
                } else {
                    carImage.backgroundColor = UIColor.clear
                    carImage.tintColor = UIColor.blue
                }
                
                carView.isHidden = false
                notFoundLabel.isHidden = true
            }
            
            idField.text = ""
            vinField.text = ""
        }
    }
    
    @IBAction func onVinSearch(_ sender: UIButton) {
        
        if (vinField.text != "" && policeApp.heapFile != nil && policeApp.bTreeID != nil && policeApp.bTreeVIN != nil) {
            
            let car = policeApp.bTreeVIN?.search(CarVIN(nil, vinField.text!))
            
            if (car == nil) {
                notFoundLabel.isHidden = false
                carView.isHidden = true
            } else {
                let heapCar = policeApp.heapFile?.getRecord(Car(), car!.heapAddress)
                
                carIdLabel.text = "EČV: \(heapCar!.id)"
                carVinLabel.text = "VIN: \(heapCar!.vin)"
                carAxlesLabel.text = "Počet náprav: \(heapCar!.axlesCount)"
                carWeightLabel.text = "Hmotnosť vozidla: \(heapCar!.weight) kg"
                carECDateLabel.text = "Koniec emisnej kontroly: \(heapCar!.dateEndEC.toString())"
                carTCDateLabel.text = "Koniec technickej kontroly: \(heapCar!.dateEndTC.toString())"
                
                if (heapCar!.dateEndEC.isValid()) {
                    carECDateLabel.textColor = UIColor.green
                } else {
                    carECDateLabel.textColor = UIColor.red
                }
                
                if (heapCar!.dateEndTC.isValid()) {
                    carTCDateLabel.textColor = UIColor.green
                } else {
                    carTCDateLabel.textColor = UIColor.red
                }
                
                if (heapCar!.inSearch) {
                    carImage.backgroundColor = UIColor.red
                    carImage.tintColor = UIColor.black
                } else {
                    carImage.backgroundColor = UIColor.clear
                    carImage.tintColor = UIColor.blue
                }
                
                carView.isHidden = false
                notFoundLabel.isHidden = true
            }
            
            idField.text = ""
            vinField.text = ""
        }
    }
}
