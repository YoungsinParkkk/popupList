//
//  ChannelPopupTableViewCell.swift
//  vineent_social
//
//  Created by infovine on 2021/01/06.
//  Copyright © 2021 Infovine. All rights reserved.
//

import UIKit

class ChannelPopupTableViewCell: UITableViewCell {
    
    @IBOutlet var oval: UIImageView!
    @IBOutlet var starIcon: UIImageView!
    @IBOutlet var statName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
