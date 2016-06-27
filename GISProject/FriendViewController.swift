//
//  FriendTableViewController.swift
//  GISProject
//
//  Created by XINGYU on 20/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchResults = [SearchResult]()
    var hasSearched = false
    var friendList:[Friends] = []

    //a constant, avoid changes in identifier names
    struct TableViewCellIdentifiers {
        
        //declare as static withour instance
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        //register & load custom nibs to the tableview
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.registerNib(cellNib,forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        tableView.rowHeight = 80
        
        //register % load an empty nibs
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.registerNib(cellNib,forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        
        
        //start to load data
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
            self.friendList = friendsListFromFirebase
            // Once done, call on the Table View to reload
            // all its contents
            self.tableView.reloadData()
        })
        
        
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "ShowFriendsDetails") {
           
            let detailViewController = segue.destinationViewController as! FriendsDetailViewController
            
            let indexPath = sender as! NSIndexPath
            let myIndexPath = friendList[indexPath.row]
            
            
                // Set the movieItem field with the movie 
                // object selected by the user.
            
                  //  filteredfriend = friendList[myIndexPath!.row]
                   detailViewController.friend = myIndexPath
                
                
          
            
            print(myIndexPath)
            detailViewController.hidesBottomBarWhenPushed = true
        }
    }

    
    
}

//extensions to organize your source code
//what happens after when you click seach button
extension FriendViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        //dimiss the keyboard
      searchBar.resignFirstResponder()
        
        searchResults = [SearchResult]()
        hasSearched = true
        
        if searchBar.text! != "justin bieber" {
            for i in 0...2 {
                let searchResult = SearchResult()
                searchResult.name = String(format: "Fake Result %d for", i)
                searchResult.artistName = searchBar.text!
                searchResults.append(searchResult)
            }
        }
        
        tableView.reloadData()
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
}

extension FriendViewController: UITableViewDataSource {
  
    func tableView(tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        
        
        if searchResults.count == 0 {
           
            //return an empty nib wihthout img
            return tableView.dequeueReusableCellWithIdentifier(
                TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath)
            
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.searchResultCell, forIndexPath: indexPath) as! SearchResultCell
            let friend = friendList[indexPath.row]
          //  cell.nameLabel.text = friend.Name
          
           // let levelDouble = friend.Level
          //  let levelString = String(levelDouble)
            
           // cell.artistNameLabel.text = "Lvl:\(levelString)"
            
            //load display images
           //FriendsDataManager.loadAndDisplayImage(cell, imageView: cell.imageView!, url: friend.ThumbnailImgUrl)
             cell.configureForSearchResult(friend)
            return cell
        }
        
    }
}

extension FriendViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("ShowFriendsDetails", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
}


 