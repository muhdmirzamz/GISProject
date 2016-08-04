//
//  HomeViewController.swift
//  Interests
//
//  Created by Duc Tran on 6/13/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController
{
    // MARK: - IBOutlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var currentUserProfileImageButton: UIButton!
    @IBOutlet weak var currentUserFullNameButton: UIButton!
    
    var selected : Bool = true
    var initialPoint : CGPoint!
    var count : Int = 0
    
    // MARK: - UICollectionViewDataSource
    private var interests : [Interest] = []
    
    //declare an array of friends obj
    var friends:[Friends] = []
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    
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
        static let CellIdentifier = "Interest Cell"
    }
    
    func animateZoomforCell(zoomCell: InterestCollectionViewCell) {
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: {() -> Void in
            zoomCell.transform = CGAffineTransformMakeScale(1.6, 1.6)
            
            }, completion: {(finished: Bool) -> Void in
        })
    }
    
    
}

extension HomeViewController : UICollectionViewDataSource
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath) as! InterestCollectionViewCell
        
        cell.interestTitleLabel.text = self.friends[indexPath.item].Name
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        print("tapped-->\(indexPath.row)")
        
        
        var cell: InterestCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! InterestCollectionViewCell
        
        //self.animateZoomforCell(cell)
        let realCenter = collectionView.convertPoint(cell.center, toView: collectionView.superview)
        
        //0 : add
        //1 : dont add
        if(count == 0){
         //initialPoint = CGPoint(x: realCenter.x, y: realCenter.y)
             count++
        }
        
        
        
        
        
        print("initital point : \(initialPoint)")
        
        //true to zoom in
        
        if(selected == true){
            print("true--> : \(cell.center)")
            initialPoint = cell.center
            collectionView.bringSubviewToFront(cell)
            //collectionView.transform = CGAffineTransformMake(1, 3, 3, 1, 3, 3)
            
            cell.contentView.bringSubviewToFront(collectionView)
            
            var t: CGAffineTransform = CGAffineTransformMakeScale(1.6, 1.6)
            var center: CGPoint = self.collectionView.center
            
            UIView.animateWithDuration(1.0) { () -> Void in
                
                cell.transform = t
                cell.center = center
                
                // cell.transform = CGAffineTransformMakeScale(1.6, 1.6)
            }
            
            //set to false
            selected = false
            //print("zoomed point : \(realCenter)")
             print("zoom in \(selected)")
        }else{
            print("zoom out \(selected)")
             print("initital point : \(cell.center)")
            collectionView.bringSubviewToFront(cell)
            //collectionView.transform = CGAffineTransformMake(1, 3, 3, 1, 3, 3)
            
            cell.contentView.bringSubviewToFront(collectionView)
            
            var t: CGAffineTransform = CGAffineTransformMakeScale(1, 1)
            var center: CGPoint = initialPoint
            
            UIView.animateWithDuration(1.0) { () -> Void in
                
                cell.transform = t
                cell.center = center
                
                // cell.transform = CGAffineTransformMakeScale(1.6, 1.6)
            }
            
            //set to false
            selected = true
            
            
        }
        
        

        
        
    }
}

 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    














