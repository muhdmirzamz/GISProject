//
//  Battle.swift
//  GISProject
//
//  Created by iOS on 11/7/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class Battle: NSObject {
    
    var monsterHealth: Float?
    var amountOfCards: NSNumber?
    var amountOfCardsToUse: NSNumber?
    var cardsArr: NSMutableArray?
    var uidArr: NSMutableArray?
    
    var expectedMonsterHealth: Float?
    var timer: NSTimer?
    
    override init() {
        self.monsterHealth = 1
        self.amountOfCardsToUse = 0
        
        self.cardsArr = NSMutableArray()
        self.cardsArr?.addObject(0)
        
        self.uidArr = NSMutableArray()
    }
    
    func getMonsterHealth() -> Int {
        return Int(self.monsterHealth!)
    }
    
    func getAmountOfCardsToUse() -> Int {
        return (self.amountOfCardsToUse?.integerValue)!
    }
    
    func checkUserCardSwitch() {
        let scheduledLocalNotifCount = UIApplication.sharedApplication().scheduledLocalNotifications!.count
        print(scheduledLocalNotifCount)
        
        // user has used card
        if scheduledLocalNotifCount > 0 {
            self.userCardSwitch.on = false
            self.userCardSwitch.enabled = false
        } else {
            self.userCardSwitch.on = true
            
            if self.amountOfCardsToUse! == 0 || self.textfield.text == "0" {
                self.userCardSwitch.enabled = false
            } else {
                self.userCardSwitch.enabled = true
            }
        }
    }
}
