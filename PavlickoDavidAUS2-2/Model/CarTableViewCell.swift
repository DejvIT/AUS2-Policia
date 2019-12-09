//
//  CarTableViewCell.swift
//  PavlickoDavidAUS2-2
//
//  Created by MaestroDavo on 08/12/2019.
//  Copyright © 2019 David Pavlicko. All rights reserved.
//

import UIKit

class CarTableViewCell: UITableViewCell {

    @IBOutlet weak var carView: UIView!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var vinLabel: UILabel!
    @IBOutlet weak var axlesLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var ecDateLabel: UILabel!
    @IBOutlet weak var tcDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
