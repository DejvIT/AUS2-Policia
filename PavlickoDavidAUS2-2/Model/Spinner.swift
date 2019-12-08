//
//  Spinner.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 08/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class Spinner {
    
    class func customBackground(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = AppDelegate.shared.friRed.withAlphaComponent(0.1)
        
        UIView.animate(withDuration: 5, animations: { () -> Void in
            spinnerView.backgroundColor = AppDelegate.shared.friBlue
        })
        
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func normalGray(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        
        let ai = UIActivityIndicatorView.init(style: .medium)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func normalBig(onView : UIView, color: UIColor) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.color = color
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

