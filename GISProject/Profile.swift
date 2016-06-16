//
//  Profile.swift
//  GISProject
//
//  Created by iOS on 16/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import Foundation

class Profile {
    var level : Int
    var monstersKilled : Int
    var uid : String
    var name : String
    
    init(level: Int, monstersKilled : Int, uid : String, name : String)
    {
        self.level = level
        self.monstersKilled = monstersKilled
        self.uid = uid
        self.name = name
    }
    
}