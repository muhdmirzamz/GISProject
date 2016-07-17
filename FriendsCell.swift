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
    
    
    /*
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
     frame.origin.x += 5
     frame.size.width -= 2 * 5
     
     super.frame = frame
     }
     }
     */
    // customize the appearance of table cell
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        //friend avatar styling
        self.name.textColor = UIColor.blackColor()
        
        
        //friend level font style
        
        
        
        
        
        
        
        
        
    }
    
    //customize cell background images
    func cellDisplay(){
        
        //translucent effect
        //self.backgroundColor = UIColor(white: 1, alpha: 0.8)
        self.backgroundColor = UIColor.whiteColor()
        
        /*
         self.layer.borderWidth = 1
         self.layer.cornerRadius = 8
         self.clipsToBounds = true
         
         */
        
        
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
