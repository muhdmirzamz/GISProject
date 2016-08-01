//
//  LastSeenLog.swift
//  GISProject
//
//  Created by Jun Hui Foong on 1/8/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class LastSeenLog: NSObject {
    var monsterType : String?
    var time : String?
    var name : String?
    
    init(monsterType : String?, time: String?, name: String?) {
        self.monsterType = monsterType
        self.time = time
        self.name = name
        super.init()
    }
}
