//
//  FriendsDetailViewController.swift
//  GISProject
//
//  Created by XINGYU on 12/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase

class FriendsDetailViewController: UIViewController {
    
    var friend : Friends!
    let sender : String = ""
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var lifeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationItem.title = friend.Name
        //Helpers.loadAndDisplayImage(nil, imageView: profileImg, url: friend.ThumbnailImgUrl)
        //load images
        FriendsDataManager.loadAndDisplayImage(nil, imageView: profileImg, url: friend.ThumbnailImgUrl)
        
        //  let backgroundImage = UIImage(named: "friendDetail_bg")?.resizableImageWithCapInsets(UIEdgeInsetsMake(10, 10, 10, 10), resizingMode: UIImageResizingMode.Stretch)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "friendDetail_bg")?.drawInRect(self.view.bounds)
        
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
        //self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        
        //user states
        //lifeImage.image = UIImage(named: "Life")
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // MARK: Properties
        
        
        
        if(segue.identifier == "ShowChatRoom") {
            let chatViewController = segue.destinationViewController as! FriendsChatViewController
            chatViewController.friend = friend
            chatViewController.senderId = "2342342"
            chatViewController.senderDisplayName = friend.Name
            
        }
    }
    
    
    
    
}
