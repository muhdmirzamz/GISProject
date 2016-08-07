//
//  FriendsDeckHomeViewController.swift
//  GISProject
//
//  Created by XINGYU on 5/8/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class FriendsDeckHomeViewController: UIViewController {
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var currentUserProfileImageButton: UIButton!
    @IBOutlet weak var currentUserFullNameButton: UIButton!
    
    var selected : Bool = true
    var initialPoint : CGPoint!
    var count : Int = 0
    var selectedItem : Int = 0
    
    //declare an array of friends obj
    var friends:[Friends] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadFriends()
        
    }
    //load friends from firebase
    func loadFriends()
    {
        FriendsDataManager.loadFriends ({ (friendsListFromFirebase) -> Void in
            // This is a closure.
            //
            // This block of codes is executed when the
            // async loading from Firebase is complete.
            // What it is to reassigned the new list loaded
            // from Firebase.
            //
            self.friends = friendsListFromFirebase
            // Once done, call on the Table View to reload
            // all its contents
            
            self.collectionView.reloadData()
            self.navigationItem.title = String("Cards (\(self.friends.count))")
        })
    }
    
    private struct Storyboard {
        static let CellIdentifier = "Deck Cell"
    }
    
    
}
extension FriendsDeckHomeViewController : UICollectionViewDataSource
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return friends.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath) as! FriendsDeckCollectionViewCell
        
        cell.interestTitleLabel.text = self.friends[indexPath.item].Name
        
        //if the card is valid, dont display lock label
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        
        //ref to friends in firebase
        let ref = FIRDatabase.database().reference().child("Friend/\(uid)/\(self.friends[indexPath.item].myKey)")
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            
            var image: UIImage?
            
            let decodedData = NSData(base64EncodedString: (self.friends[indexPath.item].ThumbnailImgUrl), options: NSDataBase64DecodingOptions(rawValue: 0))
            
            image = UIImage(data: decodedData!)
            
            ref.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    if(self.friends[indexPath.item].ThumbnailImgUrl == "profileImage"){
                        var img : UIImage! =  UIImage(named: "loading.png")
                        cell.profileImage.image = JSQMessagesAvatarImageFactory.circularAvatarImage(img, withDiameter: 90)
                        cell.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
                        cell.profileImage.layer.masksToBounds = true
                        
                    }else{
                        cell.profileImage.image = JSQMessagesAvatarImageFactory.circularAvatarImage(image, withDiameter: 90)
                    }
                    
                    cell.level.text = String("        Lvl: \(self.friends[indexPath.item].Level)")
                    cell.kills.text = String("Monster Killed : \(self.friends[indexPath.item].monstersKilled)")
                    
                    //a little bug here
                    //once zoomed in it will disappear
                    if(snapshot.value as! Int == 0){
                        //cell.lockLabel.hidden = false
                    }
                })
            })
        }
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("tapped-->\(indexPath.row)")
        
        var cell: FriendsDeckCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! FriendsDeckCollectionViewCell
        
        //var frame1: CGRect = collectionView.convertRect(cell.frame, toView: nil)
        var frame: CGRect = CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)
        frame.origin = cell.convertPoint(cell.frame.origin, toView: self.view!)
        
        
        var visibleRect: CGRect = CGRectMake(collectionView.contentOffset.x, collectionView.contentOffset.y, collectionView.contentOffset.x + collectionView.bounds.size.width, collectionView.contentOffset.y + collectionView.bounds.size.height)
        
        var centerPoint: CGPoint = CGPointMake(visibleRect.size.width / 2, visibleRect.size.height / 2)
        //0 : add
        //1 : dont add
        if(count == 0){
            count++
            //selected item
            selectedItem = indexPath.row
        }
        //true to zoom in
        if(selectedItem == indexPath.row){
            
            if(selected == true){
                
                print("true--> : \(cell.center)")
                initialPoint = cell.center
                collectionView.bringSubviewToFront(cell)
                
                cell.contentView.bringSubviewToFront(collectionView)
                
                //center point for visible screen
                var t: CGAffineTransform = CGAffineTransformMakeScale(1.6, 1.6)
                var center: CGPoint = CGPointMake(self.collectionView.center.x + self.collectionView.contentOffset.x,
                                                  self.collectionView.center.y + self.collectionView.contentOffset.y);
                
                UIView.animateWithDuration(1.0) { () -> Void in
                    cell.transform = t
                    cell.center = center
                    
                }
                //set to false
                selected = false
                print("zoom in \(selected)")
            }else{
                print("zoom out \(selected)")
                print("initital point : \(cell.center)")
                collectionView.bringSubviewToFront(cell)
                
                cell.contentView.bringSubviewToFront(collectionView)
                
                var t: CGAffineTransform = CGAffineTransformMakeScale(1, 1)
                var center: CGPoint = initialPoint
                
                UIView.animateWithDuration(0.5) { () -> Void in
                    cell.transform = t
                    cell.center = center
                }
                
                //set to false
                selected = true
                count = 0
            }
        }else{
            print("not the same item")
        }
        
        
    }
}
