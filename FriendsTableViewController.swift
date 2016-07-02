//
//  FriendsTableViewController.swift
//  GISProject
//
//  Created by XINGYU on 11/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase



class FriendsTableViewController: UITableViewController,UISearchResultsUpdating{
    
    var friends:[Friends] = []
    
    var refreshDataControl : UIRefreshControl!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredFriends = [Friends]()
    
    
    // Attach a closure to read the data at our posts reference
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //refresh control
        refreshDataControl = UIRefreshControl()
        refreshDataControl.addTarget(self, action: #selector(FriendsTableViewController.refreshControlAction), forControlEvents: .ValueChanged)
       refreshDataControl.backgroundColor = UIColor.purpleColor()
       refreshDataControl.tintColor = UIColor.whiteColor()
        tableView.addSubview(refreshDataControl)
        
        
        //search bar
        searchController.searchResultsUpdater = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
       
        //start to load data
         loadFriends()
                
    }
    
    
    //UISearchBar Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filterContentForSearchText(self.searchController.searchBar.text!)
    }
    
    //filtered out the friends based on searchTxt
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredFriends = friends.filter { friend in
            return friend.Name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    
    func refreshControlAction()
    {
        print("refresh")
        
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d,h:mm a"
        var convertedDate = dateFormatter.stringFromDate(currentDate)
        
        
        
        self.refreshDataControl.attributedTitle = NSAttributedString(string: "Last update: \(convertedDate)")
        loadFriends()
        
         refreshDataControl.endRefreshing()
        print("refresh ended")
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
    
     
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
         refreshDataControl.endRefreshing()
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.active && searchController.searchBar.text != "" {
            return filteredFriends.count
        }
        
        
        return friends.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : FriendsCell! = tableView.dequeueReusableCellWithIdentifier("FriendsCell") as! FriendsCell
       
        let friend : Friends
        
        if(cell == nil){
            
            cell = NSBundle.mainBundle().loadNibNamed("FriendsCell", owner: nil, options: nil)[0] as? FriendsCell
        }

        
        if searchController.active && searchController.searchBar.text != "" {
            friend = filteredFriends[indexPath.row]
        } else {
            friend = friends[indexPath.row]
        }
      //  let friend = friends[indexPath.row]
        
        
        
        
        let levelDouble = friend.Level
        let levelString = String(levelDouble)
        
        
       cell.name.text = friend.Name
       cell.level.text = "Lvl:\(levelString)"
      
        
        
        //load images
       FriendsDataManager.loadAndDisplayImage(nil, imageView: cell.profileImage, url: friend.ThumbnailImgUrl)
        
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
        
        if(segue.identifier == "ShowFriendsDeck") {
            let detailViewController = segue.destinationViewController as! PhotoStreamViewController
            detailViewController.hidesBottomBarWhenPushed = true
            
        }
        
        
        if(segue.identifier == "ShowFriendsDetails") {
            let detailViewController = segue.destinationViewController as! FriendsDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
           // let friend = friends[myIndexPath!.row]
           
            let filteredfriend : Friends
            
            if(myIndexPath != nil) {
                // Set the movieItem field with the movie // object selected by the user.
                
                if searchController.active && searchController.searchBar.text != ""
                {
                    
                    filteredfriend = filteredFriends[myIndexPath!.row]
                    detailViewController.friend = filteredfriend
                } else {
                  filteredfriend = friends[myIndexPath!.row]
                  detailViewController.friend = filteredfriend
                }
                
                
            }
            
            
                detailViewController.hidesBottomBarWhenPushed = true
            }
        }
    }
 


