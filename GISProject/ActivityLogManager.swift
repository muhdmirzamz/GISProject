//
//  ActivityLogManager.swift
//  GISProject
//
//  Created by Irfan Iskandar on 28/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase

class ActivityLogManager: NSObject {
    
    static func loadActivityLogs(onComplete: ([ActivityLog]) -> Void){
        
        var activityLogs : [ActivityLog] = []
        
        let ref = FIRDatabase.database().reference().child("Activity/")
        
        ref.observeEventType(FIRDataEventType.Value, withBlock: {(snapshot) in
            for record in snapshot.children {
                
                print(record)
                
                activityLogs.append(ActivityLog(activity: record.value!!["activity"] as! String, uid: record.value!!["uid"] as! String, name: record.value!!["name"] as! String))
            }
            
            onComplete(activityLogs)
            
            })
    }

}
