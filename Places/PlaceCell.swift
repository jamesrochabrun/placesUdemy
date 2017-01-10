//
//  CustomCell.swift
//  places
//
//  Created by James Rochabrun on 11/30/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {
    
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var thirdLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarView.clipsToBounds = true
        self.avatarView.layer.cornerRadius = self.avatarView.frame.size.height/2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
