//
//  ShowCarViewController.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 09/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class ShowCarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var policeApp = PoliceApp.shared
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        policeApp.readCars()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return policeApp.carsCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.2 * table.bounds.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "carCell") as? CarTableViewCell else {
            return UITableViewCell()
        }
        
        let carAtRow = policeApp.cars![indexPath.row]
        
        cell.idLabel.text = "EČV: \(carAtRow.id)"
        cell.vinLabel.text = "VIN: \(carAtRow.vin)"
        cell.axlesLabel.text = "Počet náprav: \(carAtRow.axlesCount)"
        cell.weightLabel.text = "Hmotnosť vozidla: \(carAtRow.weight) kg"
        cell.ecDateLabel.text = "Koniec emisnej kontroly: \(carAtRow.dateEndEC.toString())"
        cell.tcDateLabel.text = "Koniec technickej kontroly: \(carAtRow.dateEndTC.toString())"
        

        if (carAtRow.dateEndEC.isValid()) {
            cell.ecDateLabel.textColor = UIColor.green
        } else {
            cell.ecDateLabel.textColor = UIColor.red
        }
        
        if (carAtRow.dateEndTC.isValid()) {
            cell.tcDateLabel.textColor = UIColor.green
        } else {
            cell.tcDateLabel.textColor = UIColor.red
        }
        
        if (carAtRow.inSearch) {
            cell.carImage.backgroundColor = UIColor.red
            cell.carImage.tintColor = UIColor.black
        } else {
            cell.carImage.backgroundColor = UIColor.clear
            cell.carImage.tintColor = UIColor.blue
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        
        cell.selectedBackgroundView = backgroundView
        return cell
    }
}
