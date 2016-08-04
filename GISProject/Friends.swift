//
//  Friends.swift
//  GISProject
//
//  Created by XINGYU on 12/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import Foundation

class Friends{
    
    var Name : String
    var Level: Int
    var ThumbnailImgUrl : String
    var myKey : String
    var isOnline : Bool
  
    
    
    
    init(name: String,level:Int,thumbnailImgUrl:String,myKey:String,online:Bool)
    {
        self.Name = name
        self.Level = level
        self.ThumbnailImgUrl = thumbnailImgUrl
        self.myKey = myKey
        self.isOnline = online
    }
}
 