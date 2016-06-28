//
//  ActivityLog.swift
//  GISProject
//
//  Created by Jun Hui Foong on 17/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//
import UIKit

class ActivityLog: NSObject {
    var activity : String!
    var uid : String!
    var name : String!

    init(activity: String, uid : String, name: String) {
        self.activity = activity
        self.uid = uid
        self.name = name
        super.init()
    }
}
