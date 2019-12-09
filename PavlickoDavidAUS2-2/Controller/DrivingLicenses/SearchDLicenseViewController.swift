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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        notFoundLabel.isHidden = true
        licenseView.isHidden = true
    }

    @IBAction func onSearch(_ sender: UIButton) {
        
        if (idField.text != "" && policeApp.bTreeDrivingLicense != nil) {
            
            let drivingLicense = policeApp.bTreeDrivingLicense?.search(DrivingLicense(id: UInt64(idField.text!)!, name: "", surname: "", expiration: AppDate(), validLicense: false, offenses: 0))
            
            if (drivingLicense == nil) {
                notFoundLabel.isHidden = false
                licenseView.isHidden = true
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
                
                licenseView.isHidden = false
                notFoundLabel.isHidden = true
            }
            
            idField.text = ""
        }
    }
}
