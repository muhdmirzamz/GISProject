//
//  FriendsCell.swift
//  GISProject
//
//  Created by XINGYU on 12/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var level: UIButton!
    @IBOutlet weak var friendsCurrentLocatuon: UILabel!
    
    
    // customize the appearance of table cell
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //friend avatar styling
        self.name.textColor = UIColor.blackColor()
        
    }
    
    //customize cell background images
    func cellDisplay(){
        //translucent effect
        self.backgroundColor = UIColor.whiteColor()
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //display cusomized cell appearance
        cellDisplay()
    }
    
}
