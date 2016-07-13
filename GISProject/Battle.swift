//
//  Battle.swift
//  GISProject
//
//  Created by iOS on 11/7/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase

class Battle {
	
    var monsterHealth: Float?
    var amountOfCards: NSNumber?
    var amountOfCardsToUse: NSNumber?
    var cardsArr: NSMutableArray?
	var uidArr: NSMutableArray?
	
    var userCardSwitchOn: Bool
    var userCardSwitchEnabled: Bool
	
	var baseDamage: NSNumber?
	var calculatedDamage: NSNumber?
    var expectedMonsterHealth: Float?
	
	var selectedAnnotation: Location?
    
//    var ref = FIRDatabase.database().reference()
    let userID = (FIRAuth.auth()?.currentUser?.uid)!
    
	init() {
        self.monsterHealth = 1
		self.expectedMonsterHealth = 0
        self.amountOfCardsToUse = 0
        
        self.cardsArr = NSMutableArray()
        self.cardsArr?.addObject(0)
        
        self.userCardSwitchEnabled = true
        self.userCardSwitchOn = true
        
        self.uidArr = NSMutableArray()
		
		self.baseDamage = 0
		self.calculatedDamage = 0
        
		// get amount of valid cards
		// get uid -> to set card value to 0 after use
		let ref = FIRDatabase.database().reference().child("/Friend")
		ref.child("/\(userID)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
			var counter = 1
			
			for i in snapshot.children {
				print(i.key!!)
				
				let key = i.key!!
				let value = snapshot.value!["\(key)"] as? NSNumber
				
				if value?.integerValue == 1 {
					counter = counter + 1

					self.uidArr?.addObject(key)
					self.cardsArr?.addObject(counter)
				}
			}
		})
    }
    
    func getMonsterHealth() -> Int {
        return Int(self.monsterHealth!)
    }

	func getExpectedMonsterHealth() -> Int {
		return Int(self.expectedMonsterHealth!)
	}
	
	// total amount of cards user wants
    func getAmountOfCardsToUse() -> Int {
        return (self.amountOfCardsToUse?.integerValue)!
    }
	
	// total amount of cards that is available
	func getAmountOfCards() -> Int {
		return (self.cardsArr?.count)!
	}
	
    func getBaseDamage() -> Int {
        return (self.baseDamage?.integerValue)!
	}
    
    func calculateDamage(isSwitchedOn: Bool) -> Int {
//		let scheduledLocalNotifCount = UIApplication.sharedApplication().scheduledLocalNotifications!.count
        
        if isSwitchedOn {
            self.calculatedDamage = (self.baseDamage?.integerValue)! + (self.amountOfCardsToUse?.integerValue)!
        } else {
            self.calculatedDamage = (self.amountOfCardsToUse?.integerValue)!
        }
        
        return self.calculatedDamage!.integerValue
	}
	
	func updatePlayer() {
		let userID = (FIRAuth.auth()?.currentUser?.uid)!
		let ref = FIRDatabase.database().reference().child("/Account")
		
		var currMonstersKilled: NSNumber?
		
		ref.child("/\(userID)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
			let prevMonstersKilled = snapshot.value!["Monsters killed"] as? NSNumber
			currMonstersKilled = (prevMonstersKilled?.integerValue)! + 1
			ref.child("/\(userID)/Monsters killed").setValue(currMonstersKilled)
		})
	}
	
	func updateCards() {
		// generate a random number using amount of cards to use as the limit
		// set 0 to it to indicate that card has been used
		if (self.amountOfCardsToUse?.integerValue)! > 0 {
			let userID = (FIRAuth.auth()?.currentUser?.uid)!
			let ref = FIRDatabase.database().reference().child("/Friend")
			
			for i in 0 ..< (self.amountOfCardsToUse?.integerValue)! {
				let randomIndex = Int(arc4random()) % (self.amountOfCardsToUse?.integerValue)!
				let randomUid = self.uidArr![randomIndex] as! String
				ref.child("/\(userID)/\(randomUid)").setValue(0)
			}
		}
	}
    
    func updateMonster() {
        let random = Int(arc4random()) % 5
        var monsterImg: UIImage?
        print(random)
        
        var imageString = ""
        
        if random == 0 {
            imageString = "electric_monster"
        } else if random == 1 {
            imageString = "fire_monster"
        } else if random == 2 {
            imageString = "ghost_monster"
        } else if random == 3 {
            imageString = "grass_monster"
        } else if random == 4 {
            imageString = "water_monster"
        }
        
        monsterImg = UIImage.init(named: imageString)
        
        let ref = FIRDatabase.database().reference().child("/Location")
        let key = (self.selectedAnnotation?.key)!
        ref.child("/\(key)/image string").setValue(imageString)
    }
	
	func updateLocation() {
		// generate another random location
		var random = Double(arc4random()) % 0.004983
		let latitudeRange = 1.377431 + random
		random = Double(arc4random()) % 0.002122
		let longitudeRange = 103.848156 + random
		
		// update location
		let ref = FIRDatabase.database().reference().child("/Location")
		let key = (self.selectedAnnotation?.key)!
		ref.child("/\(key)/latitude").setValue(latitudeRange)
		ref.child("/\(key)/longitude").setValue(longitudeRange)
	}
}
