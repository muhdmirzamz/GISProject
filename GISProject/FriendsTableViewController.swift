//
//  FriendsTableViewController.swift
//  GISProject
//
//  Created by XINGYU on 11/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase



class FriendsTableViewController: UITableViewController {
    
    var friends:[Friends] = []
    
    
    // Attach a closure to read the data at our posts reference
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
       
         loadFriends()
                
    }
    
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
             self.tableView.reloadData()
        })
        
        
    }
    
    
    // This function loads images from
    // the internet and displays it in an UIImageView
    // control
    //
    func loadAndDisplayImage(imageView: UIImageView, url: String) {
        // The following lines download data from the
        // internet. This data should represent an
        // image in the JPG, GIF, PNG or any acceptable
        // graphics format.
        //
        var nurl = NSURL(string: url)
        var imageBinary : NSData?
        if nurl != nil {
            imageBinary = NSData(contentsOfURL: nurl!) }
        // After retrieving the data, we convert
        // it to an UIImage object. //
        var img : UIImage?
        if imageBinary != nil {
            img = UIImage(data: imageBinary!) }
        // These codes set the downloaded image
        // to the UIImageView control. //
        imageView.image = img
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : FriendsCell! = tableView.dequeueReusableCellWithIdentifier("FriendsCell") as! FriendsCell
        
        
        if(cell == nil){
            
            cell = NSBundle.mainBundle().loadNibNamed("FriendsCell", owner: nil, options: nil)[0] as? FriendsCell
        }

        let friend = friends[indexPath.row]
        
        
        // cell.textLabel?.text="\(p.movieName) (\(p.runtime) mins)"
        
        let levelDouble = friend.Level
        let levelString = String(levelDouble)
        
        cell.name.text = friend.Name
        cell.level.text = "Lvl:\(levelString)"
      
        
        
        //load images
       //loadAndDisplayImage(cell.imageView!, url: friend.ThumbnailImgUrl)
        Helpers.loadAndDisplayImage(cell, imageView: cell.imageView!, url: friend.ThumbnailImgUrl)

        return cell
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "ShowFriendsDetails") {
            let detailViewController = segue.destinationViewController as! FriendsDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            if(myIndexPath != nil) {
                // Set the movieItem field with the movie // object selected by the user.
                //
                let friend = friends[myIndexPath!.row]
                detailViewController.friend = friend
                detailViewController.hidesBottomBarWhenPushed = true
            }
        }
    }
 

}
