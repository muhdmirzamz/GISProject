//
//  FriendsDataManager.swift
//  GISProject
//
//  Created by XINGYU on 12/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase

class FriendsDataManager: NSObject {
    
    //load friends from Firebase and converts it into [Friends] array
    
    static func loadFriends(onComplete: ([Friends]) -> Void)
    {
        
        //create an empty friends list array
        
        var friendsList : [Friends] = []
        
        let ref = FIRDatabase.database().reference().child("FriendsList/")
        
        
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
    
    
     
    
    

}
