//
//  DLicenseTableViewCell.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 08/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class DLicenseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var licenseView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var validLabel: UILabel!
    @IBOutlet weak var offensesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
