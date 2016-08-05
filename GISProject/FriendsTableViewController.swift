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
import JSQMessagesViewController

class FriendsTableViewController: UITableViewController,UISearchResultsUpdating,UISearchControllerDelegate{
    
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
    
    //count for total number of messages
    var totalMsgCount : Int = 0
    
    //counter for end row editing
    var endRowEditing : Int = 0
    
    //this function is used for testing purposes
    @IBAction func restore(sender: AnyObject) {
        /*
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
         
         */
        var restore : [String] = [ "4TXHLACuf4NfEhvpwPaj35gf2Dg2" ,
                                   "6qqMMHIyoMNOKUuBOtf2EwjKmRE2" ,
                                   "J8udCnp29tNFjBWpQ3wHfIZ7Wn33" ,
                                   ]
        
        
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        
        //ref to friends in firebase
        let ref = FIRDatabase.database().reference().child("Friend/")
        
        for i in 0...restore.count - 1 {
            ref.childByAppendingPath(KEY_UID).updateChildValues(["\(restore[i])":1])
        }
        print("restore friends")
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //refresh control
        refreshDataControl = UIRefreshControl()
        refreshDataControl.addTarget(self, action: "refreshControlAction", forControlEvents: .ValueChanged)
        //refreshDataControl.backgroundColor = UIColor.purpleColor()
        //refreshDataControl.tintColor = UIColor.whiteColor()
        tableView.addSubview(refreshDataControl)
        
        
        //allow class to be inform when search bar text changes
        searchController.searchResultsUpdater = self
        
     searchController.delegate = self
        
        //use current view to show the search result,don't dim the view
        searchController.dimsBackgroundDuringPresentation = false
        
        //search bar does not remain on the screen if user navigate to another screen
        definesPresentationContext = true
        
        //add search bar directly below head view
        tableView.tableHeaderView = searchController.searchBar
        
        //set navigation bar appearance
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0)
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 28/255, green: 211/255, blue: 235/255, alpha: 1)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 28/255, green: 211/255, blue: 235/255, alpha: 1)]
        
    }
    
    //update after searching
    func didDismissSearchController(searchController: UISearchController){
         print("ended dimiss")
        self.tableView.reloadData()
    }
    
   
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadFriends()
        
        //start oberserving
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        
        //ref to friends in firebase
        let ref = FIRDatabase.database().reference().child("Friend/\(uid)")
        
        //ref to users
        let refOnline = FIRDatabase.database().reference().child("/Account/")
        
       
       
        
        ref.observeEventType(FIRDataEventType.ChildChanged, withBlock: { (snapshot) in
            print("there are changes")
            //reload friends where there are modifications
            self.loadFriends()
            
        })
        
        ref.observeEventType(.ChildRemoved, withBlock: { (snapshot) -> Void in
            print("there are removed")
            //reload friends where there are records deleted
            self.loadFriends()
            
        })
        
        ref.observeEventType(FIRDataEventType.ChildAdded, withBlock: { (snapshot) in
            print("there are childAdded")
            //self.sendFriendsRequestNotification(snapshot.key)
            
            //reload friends where there are new record added
            self.loadFriends()
        })
        
        //listen to login and logout
        refOnline.observeEventType(FIRDataEventType.ChildChanged, withBlock: { (snapshot) in
            print("online offline changes")
       
            
            //validate for 0 friends
            if(self.friends.count != 0){
                //whenenver there are changes in accounts
                //start looking into your friends array
                for index in 0...self.friends.count - 1 {
                    
                    if(self.friends[index].myKey == snapshot.key){
                        print("only your friends status changed: \(snapshot.key)")
                        
                        //only refresh the table if changes are your friends
                        self.loadFriends()
                    }
                }
                
            }else{
                print("no friends in the arraylist")
            }
        })
        
       
        
        
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            print("Swipe Left")
          
        }
        
        if (sender.direction == .Right) {
            print("Swipe Right")
          
        }
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
        
        //view latest date
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d,h:mm a"
        var convertedDate = dateFormatter.stringFromDate(currentDate)
        
        //set the converted date to the view
        self.refreshDataControl.attributedTitle = NSAttributedString(string: "Last update: \(convertedDate)")
        
        //reload the friends list
        self.loadFriends()
        
        //end of refreshing
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
        return 1
    }
    
    /*
    //this function used to triggered empty friendslist messages
    //msg : you have no friends yet
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String {
        
        var message: String = ""
        
        var numberOfRowsInSection: Int = self.tableView(self.tableView, numberOfRowsInSection: section)
        if numberOfRowsInSection == 0 {
            message = ""
            
            /*
             // Display a message when the table is empty
             var messageLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
             messageLabel.text = "No data is currently available. Please pull down to refresh."
             messageLabel.textColor = UIColor.blackColor()
             messageLabel.numberOfLines = 0
             messageLabel.textAlignment = .Center
             messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
             messageLabel.sizeToFit()
             messageLabel.tag = 900
             self.tableView.backgroundView = messageLabel
             self.tableView.separatorStyle = .None
             */
            
            //start define the uiview according to the width and height of the uitableview
            var testView: UIView = UIView(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
            //tag an id to the view so that can be reference easily
            testView.tag = 900
            
            //set message properties
            var label = UILabel(frame: CGRectMake(0, 0, 200, 21))
            label.textColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0)
            label.center = CGPointMake(testView.bounds.size.width/2, testView.bounds.size.height/2)
            label.font = UIFont(name: "Palatino-Italic", size: 20)
            label.text = "You have no friends yet."
            
            //add text to the custom view
            testView.addSubview(label)
            
            //add custom view to current view
            self.view.addSubview(testView)
            self.tableView.separatorStyle = .None
            
            
        }else{
            
            //if table cell is not empty,start removing subview
            if let viewWithTag = self.view.viewWithTag(900) {
                viewWithTag.removeFromSuperview()
                //add single line to the view
                self.tableView.separatorStyle = .SingleLine
            }else{
                print("Friends List not empty!")
            }
            
        }
        
        return message
    }
    */
    
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
            var passkey: String = friend.myKey
         
            /*
            //check for valid msg label
             displayMsgLabel = FriendsDataManager.displayMsgLabel(passkey)
            print("return back: \(displayMsgLabel)")
            
            if(displayMsgLabel == true){
                cell.msgLabel.hidden = true
            }
             */
            
            
            var inMyFriendsList :Bool = false
        
        
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                
                let uid = (FIRAuth.auth()?.currentUser?.uid)!
                
                //ref to friends in firebase
                let ref = FIRDatabase.database().reference().child("Friend/\(passkey)")
                
                var image: UIImage?
                
                let decodedData = NSData(base64EncodedString: (friend.ThumbnailImgUrl), options: NSDataBase64DecodingOptions(rawValue: 0))
                
                image = UIImage(data: decodedData!)
                
                
                
                ref.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
                 
                    //start ref to members
                    let refMembers = FIRDatabase.database().reference().child("FriendsModule/members/")
                    
                    let uid = (FIRAuth.auth()?.currentUser?.uid)!
                    
                    
                    //look into members
                    refMembers.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
                      
                        for record in snapshot.children {
                            
                            var user1Temp : Bool = false
                            var user2Temp : Bool = false
                            
                            var user1 = record.value!!["\(uid)"] as? Bool
                            
                            if(user1 != nil){
                                user1Temp = true
                            }else{
                                print("user 1 not found")
                            }
                            
                            var user2 = record.value!!["\(friend.myKey)"] as? Bool
                            
                            if(user2 != nil){
                                user2Temp = true
                            }else{
                                print("user 2 not found")
                            }
                   
                            
                            //if both chat members exist in the chat room record
                            if(user1 == true && user2 == true){
                                print("-------- got chat room-------")
                                print(record.key!)
                                //chatKey = record.key!
                                print("-------- got chat room-------")
                                
                        let refMessages = FIRDatabase.database().reference().child("FriendsModule/messages/\(record.key!)")
                                
                                //look for number of messages
                                refMessages.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
                                     var count = snapshot.childrenCount
                                    
                                    print("How many msg??: \(count)")
                                   
                                    cell.msgCountLabel.hidden = false
                                    
                                    let msgCount = String(count)
                                    
                                    //set msg count label
                                    cell.msgCountLabel.text = msgCount
                                    
                                    //convert to Int
                                    //self.totalMsgCount = self.totalMsgCount + (Int(msgCount)!)/(Int(msgCount)!)
                                    
                                   // print("total count: \(self.totalMsgCount)")
                                    
                                    
                                })
                                
                                
                              
                            }else{
                                
                                //here can improve on the user experience, add no chat yet message
                                print("no chat yet")
                            }
                            
                        }
                        
                    })
                    //end of look for chatroom
                    
                    
                    
                    
                    
                    //closure
                    dispatch_async(dispatch_get_main_queue()) {
                      
                        inMyFriendsList = snapshot.hasChild("\(uid)")
                        
                        //show valid chat label
                        if(inMyFriendsList == false){
                            print("caught you: \(snapshot.key)")
                            cell.msgLabel.hidden = false
                        }
                        
                        //show online label
                        if(friend.isOnline == true){
                            cell.onlineLabel.hidden = false
                            
                        }
                        
                        //by using the re-used cell, or newly created one
                        //we update the FriendsCell images and text accordingly
                        let levelInt = friend.Level
                        let levelString = String(levelInt)
                        
                        
                        //updating the text labels
                        cell.name.text = friend.Name
                        cell.level.text = "Lvl: \(levelString)"
                        
                        //load and update friends avatimages asynchronous from helper class
                       // FriendsDataManager.loadAndDisplayImage(nil, imageView: cell.profileImage, url: friend.ThumbnailImgUrl)
                     
                        
                        if(friend.ThumbnailImgUrl == "profileImage"){
                            var img : UIImage! =  UIImage(named: "loading.png")
                           cell.profileImage.image = JSQMessagesAvatarImageFactory.circularAvatarImage(img, withDiameter: 80)
                        }else{
                             
                            cell.profileImage.image = JSQMessagesAvatarImageFactory.circularAvatarImage(image, withDiameter: 80)
                        }
                        
                        
                      
                    }
                    
                    
                })
                
                
                
                
            }//end of dispath
      
        
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        print("begining editing...: \(indexPath.row)")
        self.endRowEditing = 1
        
    }
    
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        if(self.endRowEditing == 1){
             print("reset editing...: \(indexPath.row)")
           self.endRowEditing = 0
            
            //refresh table
            self.tableView.reloadData()
        }
        
        
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
            print("editing????? \(self.editing)")
            
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
                
            }//end of alertview
            alertView.addButton("Cancel") {
                print("cancel option")
                
                
                 self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.tableView.reloadData()
                alertView.hideView()
                
            }
            
            alertView.showError("Are You Sure?", subTitle: "\n Remove \(indexPath.row) \n \(self.friends[indexPath.row].myKey))")
            
            
        }//end of.delete style
        
         print("editing?????--> \(self.editing)")
        
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
            let detailViewController = segue.destinationViewController as! FriendsDeckHomeViewController
            detailViewController.hidesBottomBarWhenPushed = true
        }
        
        //go to chat room view controller
        if(segue.identifier == "ShowChatRoom") {
            
            let filteredfriend : Friends
            let detailViewController = segue.destinationViewController as! FriendsChatViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let uid = (FIRAuth.auth()?.currentUser?.uid)!
            
            if(myIndexPath != nil) {
                
                //check the value for search result or normal result
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
            //hide the tab bar when pushed to the next view controller
            detailViewController.hidesBottomBarWhenPushed = true
        }
        
    }
}


