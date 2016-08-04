//
//  FriendsDeckCollectionViewCell.swift
//  GISProject
//
//  Created by XINGYU on 5/8/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class FriendsDeckCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var interestTitleLabel: UILabel!
    @IBOutlet weak var lockLabel: UIImageView!
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        self.lockLabel.hidden = true
    }
}
