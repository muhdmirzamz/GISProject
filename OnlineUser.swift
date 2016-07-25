//
//  OnlineUser.swift
//  GISProject
//
//  Created by XINGYU on 25/7/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import Foundation
import Firebase

let onlineUserRef = FIRDatabase.database().reference().child("/Account/")

var NEW_USER = false
var KEY_UID = ""
var HANDLE = ""

var users = [String:String]()

// FIREBASE ERROR CODES
let CODE_INVALID_EMAIL = -5
let CODE_BLANK_PASSWORD = -6
let CODE_ACCOUNT_NONEXIST = -8

// FIREBASE Keys
let KEY_ISONLINE = "isOnline"