//
//  ActivityLog.swift
//  GISProject
//
//  Created by Jun Hui Foong on 17/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//
import UIKit

class ActivityLog: NSObject {
    var userName : String!
    var userAction : String!
    var userValue : String!
    var userActionTime : String!
    
    init(name : String, action : String, value : String, actionTime : String) {
        self.userName = name
        self.userAction = action
        self.userValue = value
        self.userActionTime = actionTime
        super.init()
    }
}
