//
//  PlaceDetailCell.swift
//  places
//
//  Created by James Rochabrun on 12/1/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit

class PlaceDetailCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
