//
//  showDLicenseViewController.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 08/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class ShowDLicenseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var policeApp = PoliceApp.shared
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        policeApp.readDrivingLicenses()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return policeApp.drivingLicensesCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.15 * table.bounds.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "licenseCell") as? DLicenseTableViewCell else {
            return UITableViewCell()
        }
        
        let licenseAtRow = policeApp.drivingLicenses![indexPath.row]
        
        cell.nameLabel.text = "Meno: \(licenseAtRow.name) \(licenseAtRow.surname)"
        cell.idLabel.text = "ID: \(licenseAtRow.id)"
        cell.validLabel.text = "Dátum platnosti: \(licenseAtRow.expiration.toString())"
        cell.offensesLabel.text = "Počet priestupkov: \(licenseAtRow.trafficOffenses)"
        
        if (licenseAtRow.expiration.isValid()) {
            cell.validLabel.textColor = UIColor.green
        } else {
            cell.validLabel.textColor = UIColor.red
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        
        cell.selectedBackgroundView = backgroundView
        return cell
    }
}
