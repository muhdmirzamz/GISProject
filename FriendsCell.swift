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
   
    @IBOutlet weak var chat: UIButton!
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            /*
            var frame = newFrame
            frame.origin.x += 20
            super.frame = frame
            */
             var frame = newFrame
            frame.origin.x += 10
            frame.size.width -= 2 * 10
            
            super.frame = frame
        }
    }
    
     // customize the appearance of table cell
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        //friend avatar styling
        self.name.textColor = UIColor(red: 4/255, green: 221/255, blue: 143/255, alpha: 1.0)
        self.name.font = UIFont(name: "PoetsenOne-Regular", size: 16)
        
        //friend level font style
        self.level.titleLabel?.font = UIFont(name: "PoetsenOne-Regular", size: 14)
        
        self.profileImage.layer.borderColor = UIColor(red: 234/255, green: 175/255, blue: 56/255, alpha: 1.0).CGColor
        self.profileImage.layer.borderWidth = 4
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.shadowColor = UIColor(red: 233/255, green: 222/255, blue: 36/255, alpha: 1.0).CGColor
        self.profileImage.layer.cornerRadius = 0
        self.profileImage.layer.shadowOpacity = 0.7
        self.profileImage.layer.shadowOffset = CGSizeMake(0, 0)
        self.profileImage.layer.shadowRadius = 15.0
        self.profileImage.layer.masksToBounds = false
        
        //take the bounds of the image and cast shadow correctly
        let path: UIBezierPath = UIBezierPath(rect:  self.profileImage.bounds)
        self.profileImage.layer.shadowPath = path.CGPath
        self.profileImage.layer.shouldRasterize = true
        
        //textcolor for friend location label
        self.friendsCurrentLocatuon.textColor = UIColor(red: 81/255, green: 162/255, blue: 205/255, alpha: 1.0)
        
        
         
    }
    
    //customize cell background images
    func cellDisplay(){
        
        //translucent effect
        self.backgroundColor = UIColor(white: 1, alpha: 0.3)
        //background for cell border
        //self.backgroundView = UIImageView(image: UIImage(named: "cell_blue_border")?.resizableImageWithCapInsets(UIEdgeInsetsMake(10, 50, 10, 50), resizingMode: UIImageResizingMode.Stretch))
        
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
         
      
        
    }
    
    
     override func awakeFromNib() {
     super.awakeFromNib()
        
        //display cusomized cell appearance
        cellDisplay()
     }
    
    
    
    
     /*
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
