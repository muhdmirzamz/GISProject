//
//  ActivityLogCell.swift
//  GISProject
//
//  Created by iOS on 28/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class ActivityLogCell: UITableViewCell {
    
    
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
