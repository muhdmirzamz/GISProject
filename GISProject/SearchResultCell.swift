//
//  SearchResultCell.swift
//  GISProject
//
//  Created by XINGYU on 20/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    var downloadTask: NSURLSessionDownloadTask?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //do something to the cell before it is added to tablebiew
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255,blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureForSearchResult(friendCell: Friends) {
         
        nameLabel.text = friendCell.Name
        
        let levelDouble = friendCell.Level
        let levelString = String(levelDouble)
        
        artistNameLabel.text = "Lvl:\(levelString)"
        
        //load display images
        artworkImageView.image = UIImage(named: "Placeholder")
        if let url = NSURL(string: friendCell.ThumbnailImgUrl) {
            downloadTask = artworkImageView.loadImageWithURL(url)
        }
       // FriendsDataManager.loadAndDisplayImage(cell, imageView: cell.imageView!, url: friend.ThumbnailImgUrl)
       
        
    }
    
 

}
