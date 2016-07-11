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
    
    var expectedMonsterHealth: Float?
    var timer: NSTimer?
    
    override init() {
        self.monsterHealth = 1
        self.amountOfCardsToUse = 0
    }
    
    func getMonsterHealth() -> Int {
        return Int(self.monsterHealth!)
    }
    
    func getAmountOfCardsToUse() -> Int {
        return (self.amountOfCardsToUse?.integerValue)!
    }
}
