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
            
            var baseDamage : Int! = 0
            var online :Bool!
            var monstersKilled : Int!
            var username : String!
            var ThumbnailImgUrl : String = "kk"
            var level : Int!
            var lat : Double!
            var lng : Double!
            var myKey: String!
            
            
            ref.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
                
                
                for record in snapshot.children {
                    
                    
                    let lookForFriends = FIRDatabase.database().reference().child("Account/\(record.key!)")
                    
                    
                    lookForFriends.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        
                        // Get user value
                        baseDamage = snapshot.value!["Base Damage"] as! Int
                        online = snapshot.value!["KEY_ISONLINE"] as! Bool
                        monstersKilled = snapshot.value!["Monsters killed"] as! Int
                        username = snapshot.value!["Name"] as! String
                        ThumbnailImgUrl = snapshot.value!["profileImage"] as! String
                        level = snapshot.value!["Level"] as! Int
                        lat = snapshot.value!["lat"] as! Double
                        lng = snapshot.value!["lng"] as! Double
                        
                        //let imageUrl = snapshot.value!["Picture"] as! Double
                        myKey = snapshot.key
                        
                        
                        if(online == true){
                            // print(snapshot.value!["Name"] as! String)
                        }
                        
                        //add to arraylist
                        friendsList.append(Friends(bDamage: baseDamage,
                            online: online,
                            monstKilled: monstersKilled,
                            name: username,
                            thumbnailImgUrl: ThumbnailImgUrl,
                            level: level,
                            latitude: lat,
                            longtitude: lng,
                            myKey: myKey)
                        )
                        
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
    
    static func displayMsgLabel(displayLabel: String) -> Bool
    {
        
        var inMyFriendsList :Bool = false
        print("---------aaaa----------")
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            
            let uid = (FIRAuth.auth()?.currentUser?.uid)!
            
            //ref to friends in firebase
            let ref = FIRDatabase.database().reference().child("Friend/\(displayLabel)")
            
            ref.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
                
                //closure
                dispatch_async(dispatch_get_main_queue()) {
                    print("-------------------")
                    print(snapshot.hasChild("\(uid)"))
                    inMyFriendsList = snapshot.hasChild("\(uid)")
                    print("-------------------")
                    if(inMyFriendsList == true){
                        print("caught you: \(snapshot.key)")
                    }
                }
                
            })
            
        }//end of dispath
         
        return inMyFriendsList
        
    }//end of function
    
    
}








