//
//  CreateDLicenseViewController.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 08/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class CreateDLicenseViewController: UIViewController {
    
    let policeApp = PoliceApp.shared
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var expirationDatePicker: UIDatePicker!
    @IBOutlet weak var offensesField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        expirationDatePicker.backgroundColor = UIColor.white
    }

    @IBAction func onCreate(_ sender: UIButton) {
        
        if (nameField.text != "" && surnameField.text != "" && idField.text != "" && offensesField.text != "" && policeApp.bTreeDrivingLicense != nil) {
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day,.month,.year], from: self.expirationDatePicker.date)
            var expDay = UInt8(1)
            var expMonth = UInt8(1)
            var expYear = UInt16(1970)
            if let day = components.day, let month = components.month, let year = components.year {
                expDay = UInt8(day)
                expMonth = UInt8(month)
                expYear = UInt16(year)
            }
            
            let expDate = AppDate(expDay, expMonth, expYear)
            let valid = expDate.isValid()
            
            _ = policeApp.bTreeDrivingLicense?.insert(DrivingLicense(id: UInt64(idField.text!)!, name: nameField.text!, surname: surnameField.text!, expiration: expDate, validLicense: valid, offenses: Int(offensesField.text!)!))
            
            nameField.text = ""
            surnameField.text = ""
            idField.text = ""
            offensesField.text = ""
        }
    }
}
