//
//  ActivityLogViewController.swift
//  GISProject
//
//  Created by Jun Hui Foong on 17/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class ActivityLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var activityLog : [ActivityLog] = []

    @IBOutlet weak var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityLog.append(ActivityLog(
            name: "Fanzy",
            action: "Killed",
            value: "5",
            actionTime: "2 Mins Ago"))
        
        activityLog.append(ActivityLog(
            name: "Leccute",
            action: "Killed",
            value: "1",
            actionTime: "8 Mins Ago"))
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityLog.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("UITableViewCell")
        
        if (cell == nil) {
            cell = UITableViewCell(
            style: UITableViewCellStyle.Default,
            reuseIdentifier: "UITableViewCell")
        }
        
        let p = activityLog[indexPath.row]
        cell.textLabel?.text = "\(p.userName) - \(p.userAction) [\(p.userValue)] MONSTERS ~ \(p.userActionTime)"
        
        return cell
    }
}
