//
//  SettingViewController.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 08/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    let policeApp = PoliceApp.shared
    
    @IBOutlet weak var heapFileButton: UIButton!
    @IBOutlet weak var bTreeCarIDButton: UIButton!
    @IBOutlet weak var bTreeCarVINButton: UIButton!
    @IBOutlet weak var bTreeDLicenseButton: UIButton!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var testingButton: UIButton!
    @IBOutlet weak var importButton: UIButton!
    
    @IBOutlet weak var heapFileNameField: UITextField!
    @IBOutlet weak var heapFileSizeField: UITextField!
    @IBOutlet weak var heapFileSetButton: UIButton!
    
    @IBOutlet weak var bTreeCIDFileNameField: UITextField!
    @IBOutlet weak var bTreeCIDSizeField: UITextField!
    @IBOutlet weak var bTreeCIDSetButton: UIButton!
    
    @IBOutlet weak var bTreeCVINFileNameField: UITextField!
    @IBOutlet weak var bTreeCVINSizeField: UITextField!
    @IBOutlet weak var bTreeCVINSetButton: UIButton!
    
    @IBOutlet weak var bTreeDLFileNameField: UITextField!
    @IBOutlet weak var bTreeDLSizeField: UITextField!
    @IBOutlet weak var bTreeDLSetButton: UIButton!
    
    @IBOutlet weak var countCarsField: UITextField!
    @IBOutlet weak var countDLsField: UITextField!
    @IBOutlet weak var generateDataButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sizeToFit()
    }

    @IBAction func onHeapFileSet(_ sender: UIButton) {
        
        if (heapFileNameField.text != "" && heapFileSizeField.text != "") {
            
            let filename = heapFileNameField.text!
            let blockSize = UInt16(heapFileSizeField.text!)!
            
            let loadingSpinner = Spinner.customBackground(onView: self.view)
            DispatchQueue.global(qos: .background).async {

                self.policeApp.setHeapFile(filename, blockSize)
                
                DispatchQueue.main.async {
                    Spinner.removeSpinner(spinner: loadingSpinner)
                }
            }

            heapFileNameField.text = ""
            heapFileSizeField.text = ""
        }
    }
    
    @IBAction func onBTreeCIDSet(_ sender: UIButton) {
        
        if (bTreeCIDFileNameField.text != "" && bTreeCIDSizeField.text != "") {
            
            let filename = bTreeCIDFileNameField.text!
            let blockSize = UInt64(bTreeCIDSizeField.text!)!
            
            let loadingSpinner = Spinner.customBackground(onView: self.view)
            DispatchQueue.global(qos: .background).async {

                self.policeApp.setBTreeID(filename, blockSize)
                
                DispatchQueue.main.async {
                    Spinner.removeSpinner(spinner: loadingSpinner)
                }
            }

            bTreeCIDFileNameField.text = ""
            bTreeCIDSizeField.text = ""
        }
    }
    
    @IBAction func onBTreeCVINSet(_ sender: UIButton) {
        
        if (bTreeCVINFileNameField.text != "" && bTreeCVINSizeField.text != "") {
            
            let filename = bTreeCVINFileNameField.text!
            let blockSize = UInt64(bTreeCVINSizeField.text!)!
            
            let loadingSpinner = Spinner.customBackground(onView: self.view)
            DispatchQueue.global(qos: .background).async {

                self.policeApp.setBTreeVIN(filename, blockSize)
                
                DispatchQueue.main.async {
                    Spinner.removeSpinner(spinner: loadingSpinner)
                }
            }

            bTreeCVINFileNameField.text = ""
            bTreeCVINSizeField.text = ""
        }
    }
    
    @IBAction func onBTreeDLSet(_ sender: UIButton) {
        
        if (bTreeDLFileNameField.text != "" && bTreeDLSizeField.text != "") {
            
            let filename = bTreeDLFileNameField.text!
            let blockSize = UInt64(bTreeDLSizeField.text!)!
            
            let loadingSpinner = Spinner.customBackground(onView: self.view)
            DispatchQueue.global(qos: .background).async {

                self.policeApp.setBTreeDrivingLicense(filename, blockSize)
                
                DispatchQueue.main.async {
                    Spinner.removeSpinner(spinner: loadingSpinner)
                }
            }

            bTreeDLFileNameField.text = ""
            bTreeDLSizeField.text = ""
        }
    }
    
    @IBAction func onGenerateTap(_ sender: UIButton) {
        
        if (countCarsField.text != "" || countDLsField.text != "") {
            
            let countCars = Int(countCarsField.text ?? "0") ?? 0
            let countDLs = Int(countDLsField.text ?? "0") ?? 0
            
            let loadingSpinner = Spinner.customBackground(onView: self.view)
            DispatchQueue.global(qos: .background).async {

                self.policeApp.generateData(countCars, countDLs)
                
                DispatchQueue.main.async {
                    Spinner.removeSpinner(spinner: loadingSpinner)
                }
            }

            countCarsField.text = ""
            countDLsField.text = ""
        }
    }
}
