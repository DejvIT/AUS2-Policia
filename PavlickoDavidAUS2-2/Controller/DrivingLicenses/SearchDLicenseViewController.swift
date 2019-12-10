//
//  SearchDLicenseViewController.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 08/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class SearchDLicenseViewController: UIViewController {
    
    let policeApp = PoliceApp.shared
    
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var notFoundLabel: UILabel!
    
    @IBOutlet weak var licenseView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var validLabel: UILabel!
    @IBOutlet weak var offensesLabel: UILabel!
    
    @IBOutlet weak var showUpdateButton: UIButton!
    @IBOutlet weak var updateView: UIView!
    @IBOutlet weak var updateNameField: UITextField!
    @IBOutlet weak var updateSurnameField: UITextField!
    @IBOutlet weak var updateOffensesField: UITextField!
    @IBOutlet weak var updateDatePicker: UIDatePicker!
    @IBOutlet weak var updateButton: UIButton!
    
    var drivingLicense: DrivingLicense?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        updateDatePicker.backgroundColor = UIColor.white
        notFoundLabel.isHidden = true
        licenseView.isHidden = true
        showUpdateButton.isHidden = true
        updateView.isHidden = true
        
    }

    @IBAction func onSearch(_ sender: UIButton) {
        
        if (idField.text != "" && policeApp.bTreeDrivingLicense != nil) {
            
            drivingLicense = policeApp.bTreeDrivingLicense?.search(DrivingLicense(id: UInt64(idField.text!)!, name: "", surname: "", expiration: AppDate(), validLicense: false, offenses: 0))
            
            if (drivingLicense == nil) {
                notFoundLabel.isHidden = false
                licenseView.isHidden = true
                showUpdateButton.isHidden = true
                updateView.isHidden = true
            } else {

                nameLabel.text = "Meno: \(drivingLicense!.name) \(drivingLicense!.surname)"
                idLabel.text = "ID: \(drivingLicense!.id)"
                validLabel.text = "Dátum platnosti: \(drivingLicense!.expiration.toString())"
                
                if (drivingLicense!.expiration.isValid()) {
                    validLabel.textColor = UIColor.green
                } else {
                    validLabel.textColor = UIColor.red
                }
                
                offensesLabel.text = "Počet priestupkov: \(drivingLicense!.trafficOffenses)"
                
                //UpdateForm
                updateNameField.text = drivingLicense!.name
                updateSurnameField.text = drivingLicense!.surname
                updateOffensesField.text = "\(drivingLicense!.trafficOffenses)"
                //EndofUpdate
                
                licenseView.isHidden = false
                notFoundLabel.isHidden = true
                showUpdateButton.isHidden = false
                updateView.isHidden = true
            }
            
            idField.text = ""
        }
    }
    
    @IBAction func onShowUpdate(_ sender: UIButton) {
        updateView.isHidden = false
    }
    
    @IBAction func onUpdate(_ sender: UIButton) {
        
        if (updateNameField.text != "" && updateSurnameField.text != "" && updateOffensesField.text != "" && drivingLicense != nil) {
            
            drivingLicense!.setName(updateNameField.text!)
            drivingLicense!.setSurname(updateSurnameField.text!)
            drivingLicense!.setTrafficOffenses(UInt8(updateOffensesField.text!)!)
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day,.month,.year], from: self.updateDatePicker.date)
            var expDay = UInt8(1)
            var expMonth = UInt8(1)
            var expYear = UInt16(1970)
            if let day = components.day, let month = components.month, let year = components.year {
                expDay = UInt8(day)
                expMonth = UInt8(month)
                expYear = UInt16(year)
            }
            
            drivingLicense!.setExpiration(AppDate(expDay, expMonth, expYear))
            policeApp.updateDrivingLicense(drivingLicense!)
            
            updateNameField.text = ""
            updateSurnameField.text = ""
            updateOffensesField.text = ""
        }
    }
    
}
