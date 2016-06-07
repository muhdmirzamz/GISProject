//
//  DatabaseManager.swift
//  Loba
//
//  Created by Jun Hui Foong on 2/6/16.
//  Copyright © 2016 NANYANG POLYTECHNIC. All rights reserved.
//

import UIKit
import Alamofire

class DatabaseManager: NSObject {

    class func registerAccount (uid : String, name : String, level : Int) -> Bool {
        let result : Bool = true

        Alamofire.request(.POST, "http://188.166.184.129/registerAccount.php", parameters: ["uid": uid, "name": name, "level": level]).responseJSON {
            response in
            print("@@@@@@@@@@ DEBUG START (DatabaseManager.swift) @@@@@@@@@@")
            print(response.request!)
            print("response-")
            print(response.response!)
            print("Data-")
            print(response.data!)
            print("Result-")
            print(response.result)
            
        }
        
        
        return result;
    }
}
