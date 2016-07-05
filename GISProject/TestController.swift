//
//  TestController.swift
//  GISProject
//
//  Created by iOS on 5/7/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import ISTimeline
import Firebase

class TestController: UIViewController {
    var activityLogs: [ActivityLog] = []
    var i = 0
    var boolActivity = true

    override func viewDidLoad() {
        
        let timeline = ISTimeline(frame: CGRectMake(50, 75, 355, 621))
        timeline.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0)
        timeline.bubbleColor = .init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        timeline.titleColor = .blackColor()
        timeline.descriptionColor = .darkTextColor()
        timeline.pointDiameter = 7.0
        timeline.lineWidth = 2.0
        timeline.bubbleRadius = 0.5
        
        self.view.addSubview(timeline)
    
        let ref = FIRDatabase.database().reference().child("/Activity")
        
        ref.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            for record in snapshot.children {
                let key = record.key!!
                
                let uid = record.value!!["uid"] as! String
                let activity = record.value!!["activity"] as! String
                let name = record.value!!["name"] as! String
                
                print("Test UID: \(uid)")
                print("Test activity: \(activity)")
                print("Name: \(name)")

                let point = ISPoint(title: name)
                point.description = activity
                timeline.points.append(point)
                let Activity = ActivityLog.init(key: key, activity: activity, uid: uid, name: name)
                
                self.activityLogs.append(Activity)
            }
        })
        
    }
    
    @IBAction func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

