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
import SCLAlertView

class FriendsTableViewController: UITableViewController,UISearchResultsUpdating{
    
    //declare an array of friends obj
    var friends:[Friends] = []
    
    //hold the key of friends
    var friendsKey:[String] = []
    
    //refresh control
    var refreshDataControl : UIRefreshControl!
    
    //search controller
    //telling the search controller that you want use the same view that you’re searching to display the results.
    let searchController = UISearchController(searchResultsController: nil)
    
    //filtered friends via search bar
    var filteredFriends = [Friends]()
    
    //chatroom friends
    var chatRoomFriend : Friends!
    
    
    
    
    @IBAction func restore(sender: AnyObject) {
        
        var restore : [String] = [ "4TXHLACuf4NfEhvpwPaj35gf2Dg2" ,
                                   "6qqMMHIyoMNOKUuBOtf2EwjKmRE2" ,
                                   "J8udCnp29tNFjBWpQ3wHfIZ7Wn33" ,
                                   "LDDPeGnJTeRP5qWSUfsgJEx1qsT2" ,
                                   "OJs4sevBRwdIUNiagECFcqdAoys2" ,
                                   "Rm4yWdlrRRftsfkvY7juQNPtAMh1" ,
                                   "ZUYqAg6MbPVCa9DLZ3NiE9zMb942" ,
                                   "hrOsNfsWbjf07zk8kZZMyz89pul1" ,
                                   "isuKxRNebrgXwb5fKEVIXpW10Ws1" ,
                                   "mQ28Lxcmr6YlbmqiVW06MsOwd4z1" ,
                                   "rrGjmUqIlUgsnUv08d0mi96tQRJ3"]
        
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        
        //ref to friends in firebase
        let ref = FIRDatabase.database().reference().child("Friend/")
        
        for i in 0...restore.count - 1 {
              ref.childByAppendingPath(KEY_UID).updateChildValues(["\(restore[i])":1])
        }
        print("restore friends")
    }
    
    var sendRoomKey : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //searchController.searchBar.barTintColor = UIColor(red: 29/255, green: 233/255, blue: 182/255, alpha: 1)
        
        //search bar icon
        searchController.searchBar.setImage(UIImage(named: "search_icon"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        searchController.searchBar.setSearchFieldBackgroundImage(nil, forState: UIControlState.Normal)
        
        //start to load data
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0)
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 28/255, green: 211/255, blue: 235/255, alpha: 1)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 28/255, green: 211/255, blue: 235/255, alpha: 1)]
        
        

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
         loadFriends()
        
        //start oberserving
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        
        //ref to friends in firebase
        let ref = FIRDatabase.database().reference().child("Friend/\(uid)")
        
        let refOnline = FIRDatabase.database().reference().child("Account/\(uid)")
        
        
        
        
         ref.observeEventType(FIRDataEventType.ChildChanged, withBlock: { (snapshot) in
            print("there are changes")
        
           // self.friends.removeAll();
            self.loadFriends()
            
        })
        
        ref.observeEventType(.ChildRemoved, withBlock: { (snapshot) -> Void in
            self.loadFriends()
             print("there are removed")
        })
        
        ref.observeEventType(FIRDataEventType.ChildAdded, withBlock: { (snapshot) in
            print("there are changes")
            
          
             self.loadFriends()
            
        })
        
        
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
        self.loadFriends()
        
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
        
        if(friend.isOnline == true){
            cell.friendsCurrentLocatuon.text = "Online"
            
        }else{
             cell.friendsCurrentLocatuon.text = "Off"
        }
        
        
        
        //load and update friends avatimages asynchronous from helper class
        //FriendsDataManager.loadAndDisplayImage(nil, imageView: cell.profileImage, url: friend.ThumbnailImgUrl)
        
        return cell
        
    }
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
     // Override to support editing the table view.
    //enable slide to delete option
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
    
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont.systemFontOfSize(30, weight: UIFontWeightLight),
            kTitleHeight: 40,
            kButtonFont: UIFont.systemFontOfSize(18, weight: UIFontWeightLight),
            showCloseButton: false
        )
         
        //pop up alert
        let alertView = SCLAlertView(appearance : appearance)
        alertView.addButton("Delete") {
            
            print("deleting friends from firebase...")
            
            //current user
            let uid = (FIRAuth.auth()?.currentUser?.uid)!
            
            //look for items in filtered friends array
            //delete the items in firebase and uitableview
            if self.searchController.active && self.searchController.searchBar.text != "" {
                
                var friendsTemp : String = self.filteredFriends[indexPath.row].myKey
                 self.filteredFriends.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.tableView.setEditing(false, animated: true)
                
                //remove friends using their unique key
                let deleteFriend = FIRDatabase.database().reference().child("Friend/\(uid)/\(friendsTemp)")
                
                //delete reocrd from firebase
                deleteFriend.removeValue();
                
                self.loadFriends()
                 print("record in friend[]: \(self.friends.count)")
                 print("record in filteredfriend[]: \(self.filteredFriends.count)")
               
            }else{
                
                var friendsTemp : String = self.friends[indexPath.row].myKey
                
                self.friends.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.tableView.setEditing(false, animated: true)
                
                //remove friends using their unique key
                let deleteFriend = FIRDatabase.database().reference().child("Friend/\(uid)/\(friendsTemp)")
                
                //delete reocrd from firebase
                deleteFriend.removeValue();
                print("record in friend[]: \(self.friends.count)")
                 print("record in filteredfriend[]: \(self.filteredFriends.count)")
            }
       
            //dismiss view
            alertView.hideView()
         
        }
        alertView.addButton("Cancel") {
            print("cancel option")
            alertView.hideView()
        }
      
        alertView.showError("Are You Sure?", subTitle: "\n Remove \(indexPath.row) \n \(self.friends[indexPath.row].myKey))")
       
        
        
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
    
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //hide the bottombar for friends deck view
        //go to deck view controller
        if(segue.identifier == "ShowFriendsDeck") {
            let detailViewController = segue.destinationViewController as! FriendsDeckCollectionViewController
            detailViewController.hidesBottomBarWhenPushed = true
        }
        
        //go to chat room view controller
        if(segue.identifier == "ShowChatRoom") {
            
            let filteredfriend : Friends
            let detailViewController = segue.destinationViewController as! FriendsChatViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let uid = (FIRAuth.auth()?.currentUser?.uid)!
            
            if(myIndexPath != nil) {
                
                
                if searchController.active && searchController.searchBar.text != ""
                {
                    filteredfriend = filteredFriends[myIndexPath!.row]
                    
                    detailViewController.friend = filteredfriend
                    detailViewController.senderId = uid
                    detailViewController.senderDisplayName = uid
                    detailViewController.friendsKey = filteredfriend.myKey
                    detailViewController.senderKey = uid
                    
                    print("entering \(filteredfriend.Name)-->")
                    
                } else {
                    
                    filteredfriend = friends[myIndexPath!.row]
                    
                    detailViewController.friend = filteredfriend
                    detailViewController.senderKey = uid
                    detailViewController.senderId = uid
                    detailViewController.senderDisplayName = uid
                    detailViewController.friendsKey = filteredfriend.myKey
                    
                       print("entering \(filteredfriend.Name)-->")
                }
            }
            detailViewController.hidesBottomBarWhenPushed = true
        }
        
    }
}


