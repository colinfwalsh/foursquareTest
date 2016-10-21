//
//  VenueTableViewCell.swift
//  foursquareTest
//
//  Created by Colin Walsh on 10/19/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import UIKit

class VenueTableViewCell: UITableViewCell {
    @IBOutlet var venueCategoryLabel: UILabel!
    @IBOutlet var venueIcon: UIImageView!
    @IBOutlet var venueTitle: UILabel!
    @IBOutlet var leftDetailBackground: UIView!
    @IBOutlet var venueDistanceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
