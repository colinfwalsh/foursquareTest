//
//  VenueDetailContentTableViewCell.swift
//  foursquareTest
//
//  Created by Colin Walsh on 10/21/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import UIKit

class VenueDetailContentTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var supplementaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
