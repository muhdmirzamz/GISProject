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
    var Level: Double
    var ThumbnailImgUrl : String
    var myKey : String
    
    
    
    init(name: String,level:Double,thumbnailImgUrl:String,myKey:String)
    {
        self.Name = name
        self.Level = level
        self.ThumbnailImgUrl = thumbnailImgUrl
        self.myKey = myKey
    }
}
 