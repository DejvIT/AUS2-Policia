//
//  CreateCarViewController.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 09/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class CreateCarViewController: UIViewController {
    
    let policeApp = PoliceApp.shared
    
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var vinField: UITextField!
    @IBOutlet weak var axelsField: UITextField!
    @IBOutlet weak var inSearchSwitch: UISwitch!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var ecDatePicker: UIDatePicker!
    @IBOutlet weak var tcDatePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ecDatePicker.backgroundColor = UIColor.white
        tcDatePicker.backgroundColor = UIColor.white
    }

    @IBAction func onAdd(_ sender: UIButton) {
        
        if (idField.text != "" && vinField.text != "" && axelsField.text != "" && weightField.text != "" && policeApp.heapFile != nil && policeApp.bTreeID != nil && policeApp.bTreeVIN != nil) {
            
            let calendar = Calendar.current
            var components = calendar.dateComponents([.day,.month,.year], from: self.ecDatePicker.date)
            var ecDate: AppDate?
            if let day = components.day, let month = components.month, let year = components.year {
                ecDate = AppDate(UInt8(day), UInt8(month), UInt16(year))
            }
            
            components = calendar.dateComponents([.day,.month,.year], from: self.tcDatePicker.date)
            var tcDate: AppDate?
            if let day = components.day, let month = components.month, let year = components.year {
                tcDate = AppDate(UInt8(day), UInt8(month), UInt16(year))
            }
            
            _ = policeApp.insertCar(Car(id: idField.text!, vin: vinField.text!, axles: UInt8(axelsField.text!)!, weight: UInt16(weightField.text!)!, inSearch: inSearchSwitch.isOn ? true : false, endEC: ecDate!, endTC: tcDate!))
            
            idField.text = ""
            vinField.text = ""
            axelsField.text = ""
            weightField.text = ""
        }
    }
}
