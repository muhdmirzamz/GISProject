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
    
    static func loadActivityLogs(number : Int)(onComplete: ([ActivityLog]) -> Void){
        
        var activityLogs : [ActivityLog] = []
        
        let ref = FIRDatabase.database().reference().child("Activity/")
        
        ref.observeSingleEventOfType(FIRDataEventType.Value, withBlock: {(snapshot) in
            for record in snapshot.children {
                let key = record.key!!
                
                let
                
//                activityLogs.append(ActivityLog(activity: record.value!!["activity"] as! String, uid: record.value!!["uid"] as! String, name: record.value!!["name"] as! String))
//            }
//            
//            onComplete(activityLogs)
//            
//            })
    }
        })
    }
    
    static func checkActivityArray(number : Int)(onComplete: (Bool) -> Void) throws {
        var ActivityPresent = false
        
        let ref = FIRDatabase.database().reference().child("Activity")
        
        ref.child("/\(number)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            
            let name = snapshot.value!["name"] as! String
            if name == "" {
                print("No Record Found Exiting Method")
            }
            else {
            ActivityPresent = true
            }
        })
    }
    

}
