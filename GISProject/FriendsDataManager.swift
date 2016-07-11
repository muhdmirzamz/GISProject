//
//  FriendsDataManager.swift
//  GISProject
//
//  Created by XINGYU on 12/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import FirebaseDatabase


class FriendsDataManager: NSObject {
    
    //load friends from Firebase and converts it into [Friends] array
          
    static func loadFriends(onComplete: ([Friends]) -> Void)
    {
        
        //create an empty friends list array
        
        var friendsList : [Friends] = []
        
        //let ref = FIRDatabase.database().reference().child("FriendsModule/myFriend/Chats/FriendsList/")
        let ref = FIRDatabase.database().reference().child("FriendsModule/friendList/")
       
        
        ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            
            for record in snapshot.children {
                
                print(record)
                print(record.value!!["Name"] as! String)
               
                //let levelString = record.value!!["Level"] as! String
                //let levelDouble = Double(levelString)
                
                friendsList.append(Friends(name: record.value!!["Name"] as! String,
                    level: record.value!!["Level"] as! Double,
                    thumbnailImgUrl: record.value!!["ThumbnailImgUrl"] as! String))
                
                
            }
            
            
            onComplete(friendsList)
            
        })
        
    }
    
    
    // Downloads the image using the specified URL and
    // shows it on the imageView. If your imageView is
    // within a TableViewCell, passing in
    // TableViewCell object too.
    static func loadAndDisplayImage(cell: UITableViewCell!, imageView: UIImageView, url: String)
    {
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            
            // Load the image from the given URL
            //
            let nurl = NSURL(string: url)
            var imageBinary : NSData?
            if nurl != nil
            {
                imageBinary = NSData(contentsOfURL: nurl!)
            }
            
            
            dispatch_async(dispatch_get_main_queue()) {
                
                // After retrieving the image data, we convert
                // it to an UIImage object. This is an update
                // to the User Interface.
                //
                var img : UIImage?
                if imageBinary != nil
                {
                    img = UIImage(data: imageBinary!)
                }
                
                imageView.image = img
               // imageView.image = JSQMessagesAvatarImageFactory.circularAvatarImage(img!, withDiameter: 78)
                
                // Tells the cell, if available, to re-layout itself.
                // This is an update to the User Interface.
                if cell != nil
                {
                    cell.setNeedsLayout()
                }
                
            }
        }
        
        
    }
    
    
     
    
    

}
