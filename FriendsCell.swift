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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.name.textColor = UIColor.brownColor()
        self.name.font = UIFont(name: "PoetsenOne-Regular", size: 16)
        self.level.titleLabel?.font = UIFont(name: "PoetsenOne-Regular", size: 14)
        self.profileImage.layer.borderColor = UIColor(red: 234/255, green: 175/255, blue: 56/255, alpha: 1.0).CGColor
        self.profileImage.layer.borderWidth = 4
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.shadowColor = UIColor(red: 233/255, green: 222/255, blue: 36/255, alpha: 1.0).CGColor
        self.profileImage.layer.cornerRadius = 8
        self.profileImage.layer.shadowOpacity = 0.7
        self.profileImage.layer.shadowOffset = CGSizeMake(0, 0)
        self.profileImage.layer.shadowRadius = 15.0
        self.profileImage.layer.masksToBounds = false
        var path: UIBezierPath = UIBezierPath(rect:  self.profileImage.bounds)
        self.profileImage.layer.shadowPath = path.CGPath
        self.profileImage.layer.shouldRasterize = true
        
    }
    
    
    /*
     override func awakeFromNib() {
     super.awakeFromNib()
     }
     
     override func setSelected(selected: Bool, animated: Bool) {
     super.setSelected(selected, animated: animated)
     }
     
     // Here you can customize the appearance of your cell
     override func layoutSubviews() {
     super.layoutSubviews()
     // Customize imageView like you need
     self.imageView?.frame = CGRectMake(0,0,80,80)
     self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
     // Costomize other elements
     self.textLabel?.frame = CGRectMake(60, 0, self.frame.width - 45, 20)
     self.detailTextLabel?.frame = CGRectMake(60, 20, self.frame.width - 45, 15)
     }
     */
}
