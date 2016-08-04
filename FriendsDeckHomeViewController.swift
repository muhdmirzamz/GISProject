//
//  FriendsDeckHomeViewController.swift
//  GISProject
//
//  Created by XINGYU on 5/8/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        
        
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        print("tapped-->\(indexPath.row)")
        
        var cell: FriendsDeckCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! FriendsDeckCollectionViewCell
        
        
        let realCenter = collectionView.convertPoint(cell.center, toView: collectionView.superview)
        
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
                
                var t: CGAffineTransform = CGAffineTransformMakeScale(1.6, 1.6)
                var center: CGPoint = self.collectionView.center
                
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
                //collectionView.transform = CGAffineTransformMake(1, 3, 3, 1, 3, 3)
                
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
