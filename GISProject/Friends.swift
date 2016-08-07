//
//  Friends.swift
//  GISProject
//
//  Created by XINGYU on 12/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import Foundation

class Friends{
    
    var baseDamage : Int
    var isOnline : Bool
    var monstersKilled : Int
    var Name : String
    var ThumbnailImgUrl : String
    var Level: Int
    var lat : Double
    var lng : Double
    var myKey : String
    
    init(bDamage:Int,
         online:Bool,
         monstKilled: Int,
         name: String,
         thumbnailImgUrl:String,
         level:Int,
         latitude : Double,
         longtitude: Double,
         myKey:String)
    {
        self.baseDamage = bDamage
         self.isOnline = online
        self.monstersKilled = monstKilled
        self.Name = name
        self.ThumbnailImgUrl = thumbnailImgUrl
        self.Level = level
        self.lat = latitude
        self.lng = longtitude
        self.myKey = myKey
        
    }
}
 