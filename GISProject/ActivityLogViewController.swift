//
//  ActivityLogViewController.swift
//  GISProject
//
//  Created by Irfan Iskandar on 28/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase

class ActivityLogViewController: UIViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//    
//    var uid : String = ""
//    var uidInt : Int = 0
//    var name : String = ""
//    var activityLogs: [ActivityLog] = []
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //Load data from firebase
//        loadFriends()
//        // Do any additional setup after loading the view.
//    }
//    
//    func loadFriends(){
//        
//        ActivityLogManager.loadActivityLogs ({ (ActivityLogsFromFirebase) -> Void in
//            
//            self.activityLogs = ActivityLogsFromFirebase
//            
//            self.tableView.reloadData()
//        })
//        
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.activityLogs.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        //var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
//        var cell : ActivityLogCell! = tableView.dequeueReusableCellWithIdentifier("ActivityLogCell") as? ActivityLogCell
//        if (cell == nil){
//            cell = NSBundle.mainBundle().loadNibNamed("ActivityLogCell", owner: nil, options: nil)[0] as? ActivityLogCell
//        }
//        let Activity = activityLogs[indexPath.row]
//        
//            
//        //Old Working Version with no conversion
//        //
//        cell.uidLabel.text = Activity.name
//        cell.activityLabel.text = Activity.activity
//        
//        var activity = Activity.activity
//        
//        if (activity!.rangeOfString("monsters") != nil){
//        cell.activityImage.image = UIImage(named: "ActivityMonster")
//            }
//        if (activity!.rangeOfString("leveled") != nil){
//            cell.activityImage.image = UIImage(named: "ActivityLevel")
//        }
//        return cell!
//    }
//    
//    @IBAction func dismiss(){
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
	
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

