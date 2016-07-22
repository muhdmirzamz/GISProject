//
//  FriendsTableViewController.swift
//  GISProject
//
//  Created by XINGYU on 11/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FriendsTableViewController: UITableViewController,UISearchResultsUpdating{
    
    //declare an array of friends obj
    var friends:[Friends] = []
    
    //refresh control
    var refreshDataControl : UIRefreshControl!
    
    //search controller
    //telling the search controller that you want use the same view that you’re searching to display the results.
    let searchController = UISearchController(searchResultsController: nil)
    
    //filtered friends via search bar
    var filteredFriends = [Friends]()
    
    //chatroom friends
    var chatRoomFriend : Friends!
    
     //let refMembers = FIRDatabase.database().reference().child("FriendsModule/members/")
    
    var sendRoomKey : String!
    
    var friendsSnapShot = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.barTintColor = UIColor(red: 29/255, green: 233/255, blue: 182/255, alpha: 1)
        // self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        // UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        //self.navigationBar.tintColor =  UIColor(red: 38/255, green: 232/255, blue: 167/255, alpha: 1)
        //background image
        
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "friendTable_bg_light")?.resizableImageWithCapInsets(UIEdgeInsetsMake(10, 10, 10, 10), resizingMode: UIImageResizingMode.Stretch))
        
        
        //refresh control
        refreshDataControl = UIRefreshControl()
        
        refreshDataControl.addTarget(self, action: "refreshControlAction", forControlEvents: .ValueChanged)
        refreshDataControl.backgroundColor = UIColor.purpleColor()
        refreshDataControl.tintColor = UIColor.whiteColor()
        tableView.addSubview(refreshDataControl)
        
        
        //allow class to be inform when search bar text changes
        searchController.searchResultsUpdater = self
        
        //use current view to show the search result,don't dim the view
        searchController.dimsBackgroundDuringPresentation = false
        
        //search bar does not remain on the screen if user navigate to another screen
        definesPresentationContext = true
        
        //add search bar directly below head view
        tableView.tableHeaderView = searchController.searchBar
        //tableView.tableHeaderView?.backgroundColor = UIColor.blackColor()
        
        
        //search bar background image
        //searchController.searchBar.setBackgroundImage(UIImage(named: "cell_blue")?.resizableImageWithCapInsets(UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5), resizingMode: UIImageResizingMode.Stretch), forBarPosition: .Any, barMetrics: .Default)
        
        //searchController.searchBar.backgroundColor = UIColor.blueColor()
        //searchController.searchBar.backgroundImage = UIImage()
        
        
        //searchController.searchBar.barTintColor = UIColor(red: 29/255, green: 233/255, blue: 182/255, alpha: 1)
        
        //search bar icon
        searchController.searchBar.setImage(UIImage(named: "search_icon"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        searchController.searchBar.setSearchFieldBackgroundImage(nil, forState: UIControlState.Normal)
        
        
        
        //start to load data
       
        //loadFriendsKeySnapShot()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadFriends()
        
    }
    func loadFriendsKeySnapShot(){
        
        FriendsDataManager.loadFriendsRoomKey ({ (friendsListFromFirebase) -> Void in
            // This is a closure.
            //
            // This block of codes is executed when the
            // async loading from Firebase is complete.
            // What it is to reassigned the new list loaded
            // from Firebase.
            //
            self.friendsSnapShot = friendsListFromFirebase
            // Once done, call on the Table View to reload
            // all its contents
         
            
            
        })
       // self.loadFriends()
        /*
        for i in 0...self.friendsSnapShot.count {
            print("-->\(self.friendsSnapShot[i])")
        }
        */
    }
    
    
    
    //UISearchBar Delegate
    //respond to the search bar
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filterContentForSearchText(self.searchController.searchBar.text!)
    }
    
    //filtered out the friends based on searchTxt in irregularless of case sensitivity
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredFriends = friends.filter { friend in
            return friend.Name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        //reload tableview to display the search result
        tableView.reloadData()
    }
    
    //pull to refresh contents
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
            self.tableView.reloadData()
        })
       
        
        
    }
    /*
    func loadChatRoom(getKey: Friends)
    {
        
        
        FriendsDataManager.loadChatRoom ({ (getkey) -> Void in
            // This is a closure.
            //
            // This block of codes is executed when the
            // async loading from Firebase is complete.
            // What it is to reassigned the new list loaded
            // from Firebase.
            //
            self.sendRoomKey = getKey
            
            print("gotten key: \(self.sendRoomKey)")
            // Once done, call on the Table View to reload
            // all its contents
            // self.tableView.reloadData()
        })
        
        
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    // This function is one of the functions that a delegate for
    // It tells the UITable how many items in the list to display
    //for a given component  (vertical section)
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        refreshDataControl.endRefreshing()
        return 1
    }
    
    //returns the number of items in the tableview
    //display all friends and search friends accordingly
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return search result count
        if searchController.active && searchController.searchBar.text != "" {
            return filteredFriends.count
        }
        
        //return all friends from firebase
        return friends.count
    }
    
    //table cell head spacing
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cellSpacingHeight: CGFloat = 0
        return cellSpacingHeight
    }
    
    //headerview spacing clear colour effect
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    // Set the spacing between sections
    
    
    
    // given the row/item number of the tableview and display the data of the table cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //first we query the table view to see if there are
        //any FriendsCell that are no longer visible
        //and can be reused for a new table cell that need to be display
        var cell : FriendsCell! = tableView.dequeueReusableCellWithIdentifier("FriendsCell") as! FriendsCell
        
        //if we don't find it, then we create a new FriendsCell by loading the nib
        //"FriendsCell" from the main bundle
        if(cell == nil){
            
            cell = NSBundle.mainBundle().loadNibNamed("FriendsCell", owner: nil, options: nil)[0] as? FriendsCell
        }
        
        //declare an friends instance to make use of the objects easily
        var friend : Friends!
        
        
        
        //check for any search inputs and use the corrent friends array data
        if searchController.active && searchController.searchBar.text != "" {
            friend = filteredFriends[indexPath.row]
            
        } else {
            
            friend = friends[indexPath.row]
        }
        
        //by using the re-used cell, or newly created one
        //we update the FriendsCell images and text accordingly
        let levelDouble = friend.Level
        let levelString = String(levelDouble)
        
        //updating the text labels
        cell.name.text = friend.Name
        cell.level.setTitle("Lvl:\(levelString)", forState: UIControlState.Normal)
        
        
        //load and update friends avatimages asynchronous from helper class
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
    
    /*
    func lookForKey(getKey:Friends){
        
        refMembers.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            
            
            
            for record in snapshot.children {
                 print("-------------------------")
               print(record)
                  print(record.value!!["Sad"] as! Bool)
                 print(record.value!!["\(getKey.Name)"] as! Bool)
                 print("-------------------------")
                
                var user1 = record.value!!["Sad"] as! Bool
                var user2 = record.value!!["\(getKey.Name)"] as! Bool
                
                if(user1 == true && user2 == true){
                    print("-------- got it-------")
                    print(record.key!)
                    self.sendRoomKey = record.key!
                     print("-------- got it-------")
                }
            
            
                
            }
            
            
            
            
        })
        
        
    }
    */
    
    
    
    /*
    func prepareLookForKey(){
        
        refMembers.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            
            
            
            for record in snapshot.children {
                
                var user1 = record.value!!["Sad"] as! Bool
                
                
                for i in 0...self.friends.count {
                    
                    record.va
                    
                    
                    var user2 = record.value!!["\(self.friends[i].Name)"] as! Bool
                    
                    
                    if(user1 == true && user2 == true){
                        print("-------- got it-------")
                        print(record.key!)
                        self.sendRoomKey = record.key!
                        print("-------- got it-------")
                    }
                    
                    
                }
                
                
            }
            
            
            
            
        })
        
        
    }
    */
    
    
    
 
    
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //hide the bottombar for friends deck view
        if(segue.identifier == "ShowFriendsDeck") {
            
            let detailViewController = segue.destinationViewController as! FriendsDeckCollectionViewController
            detailViewController.hidesBottomBarWhenPushed = true
            
        }
        
        /*
         //by tapping on the chat icon, hide the bottom bar and display the chat room view accordingly
         if(segue.identifier == "ShowChatRoom") {
         
         
         let chatViewController = segue.destinationViewController as! FriendsChatViewController
         chatViewController.friend = friend
         chatViewController.senderId = "Alex"
         chatViewController.senderDisplayName = friend.Name
         print("00--> \(friend.Name)")
         
         }
         */
        
        if(segue.identifier == "ShowChatRoom") {
          
            let filteredfriend : Friends
            
            let detailViewController = segue.destinationViewController as! FriendsChatViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            // let friend = friends[myIndexPath!.row]
            
            
           
            
            
            if(myIndexPath != nil) {
                // Set the movieItem field with the movie // object selected by the user.
                
                if searchController.active && searchController.searchBar.text != ""
                {
                    
                    filteredfriend = filteredFriends[myIndexPath!.row]
                    detailViewController.friend = filteredfriend
                    
                    detailViewController.friend = filteredfriend
                    detailViewController.senderId = "Friend0"
                    detailViewController.senderDisplayName = filteredfriend.Name
                    detailViewController.friendsKey = filteredfriend.myKey
                   detailViewController.senderKey = "Friend0"
                    print(filteredfriend.myKey)
                      //lookForKey(filteredfriend)
                    //loadChatRoom(filteredfriend)
                   // detailViewController.chatRoomId = sendRoomKey
                } else {
                    filteredfriend = friends[myIndexPath!.row]
                    detailViewController.friend = filteredfriend
                    detailViewController.friend = filteredfriend
                    detailViewController.senderKey = "Friend0"
                    detailViewController.senderId = "Friend0"
                    detailViewController.senderDisplayName = filteredfriend.Name
                     detailViewController.friendsKey = filteredfriend.myKey
                    print(filteredfriend.myKey)
                }
                
                
            }
            
            
            detailViewController.hidesBottomBarWhenPushed = true
        }
        
        /*
         
         if(segue.identifier == "ShowFriendsDetails") {
         let detailViewController = segue.destinationViewController as! FriendsDetailViewController
         let myIndexPath = self.tableView.indexPathForSelectedRow
         
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
         */
    }
}


