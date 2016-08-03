//
//  FriendsDataManager.swift
//  GISProject
//
//  Created by XINGYU on 12/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase


class FriendsDataManager: NSObject {
    
    
    
    /*
     //load friends from Firebase and converts it into [Friends] array
     static func loadFriends(onComplete: ([Friends]) -> Void)
     {
     let uid = (FIRAuth.auth()?.currentUser?.uid)!
     
     //create an empty friends list array
     var friendsList : [Friends] = []
     
     //ref to friends in firebase
     let ref = FIRDatabase.database().reference().child("Friend/\(uid)")
     
     var username : String!
     var level : Double!
     var myKey: String!
     
     ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
     
     
     for record in snapshot.children {
     
     
     let lookForFriends = FIRDatabase.database().reference().child("Account/\(record.key!)")
     
     
     lookForFriends.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
     // Get user value
     username = snapshot.value!["Name"] as! String
     level = snapshot.value!["Level"] as! Double
     //let imageUrl = snapshot.value!["Picture"] as! Double
     myKey = snapshot.key
     
     //print(username)
     
     friendsList.append(Friends(name: username,
     level: level,
     thumbnailImgUrl: "",
     myKey : myKey))
     
     onComplete(friendsList)
     
     // ...
     }) { (error) in
     print(error.localizedDescription)
     }
     }
     
     
     })
     
     }
     */
    
    
    //load friends from Firebase and converts it into [Friends] array
    static func loadFriends(onComplete: ([Friends]) -> Void)
    {
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            
            let uid = (FIRAuth.auth()?.currentUser?.uid)!
            
            //create an empty friends list array
            var friendsList : [Friends] = []
            
            //ref to friends in firebase
            let ref = FIRDatabase.database().reference().child("Friend/\(uid)")
            
            var username : String!
            var level : Int!
            var myKey: String!
            var online :Bool!
            
            ref.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
                
                
                for record in snapshot.children {
                    
                    
                    let lookForFriends = FIRDatabase.database().reference().child("Account/\(record.key!)")
                    
                    
                    lookForFriends.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        
                        // Get user value
                        username = snapshot.value!["Name"] as! String
                        level = snapshot.value!["Level"] as! Int
                        online = snapshot.value!["KEY_ISONLINE"] as! Bool
                        //let imageUrl = snapshot.value!["Picture"] as! Double
                        myKey = snapshot.key
                        
                        
                        if(online == true){
                            print(snapshot.value!["Name"] as! String)
                        }
                        
                        //add to arraylist
                        friendsList.append(Friends(name: username,
                            level: level,
                            thumbnailImgUrl: "",
                            myKey : myKey,
                            online: online))
                        
                        //closure
                        dispatch_async(dispatch_get_main_queue()) {
                            onComplete(friendsList)
                            
                        }
                        // ...
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
                
                
            })
        }
    }
    
    
    
    static func loadFriendsRoomKey(onComplete: ([String]) -> Void)
    {
        
        //create an empty friends list array
        
        var friendsList : [String] = []
        
        let ref = FIRDatabase.database().reference().child("FriendsModule/friendList/")
        
        
        ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            
            for record in snapshot.children {
                
                friendsList.append(record.key!!)
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
