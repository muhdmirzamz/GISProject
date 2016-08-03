//
//  FriendsCell.swift
//  GISProject
//
//  Created by XINGYU on 12/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class FriendsCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
 
    @IBOutlet weak var msgLabel: UIImageView!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var friendsCurrentLocatuon: UILabel!
    
    
    // customize the appearance of table cell
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //friend avatar styling
        self.name.textColor = UIColor.blackColor()
        
        var img : UIImage! =  UIImage(named: "loading.png")
        self.profileImage.image = JSQMessagesAvatarImageFactory.circularAvatarImage(img, withDiameter: 80)
        
        //hide msg label
        self.msgLabel.hidden = true
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
