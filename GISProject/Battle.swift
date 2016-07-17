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
    var amountOfCardsToUse: NSNumber?
	var amountOfCardsAvailable: NSNumber?
	var uidArr: NSMutableArray?
	
	var baseDamage: NSNumber?
    var expectedMonsterHealth: Float?
	
	var selectedAnnotation: Location?
    
//    var ref = FIRDatabase.database().reference()
    let userID = (FIRAuth.auth()?.currentUser?.uid)!
    
	init() {
        self.monsterHealth = 5
		self.expectedMonsterHealth = 0
        self.amountOfCardsToUse = 0
		self.amountOfCardsAvailable = 0
		
		// this variable ties very closely with amount of cards available
        self.uidArr = NSMutableArray()
		
		self.baseDamage = 0
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
	
    func getBaseDamage() -> Int {
        return (self.baseDamage?.integerValue)!
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
		let userID = (FIRAuth.auth()?.currentUser?.uid)!
		let ref = FIRDatabase.database().reference().child("/Friend")
		
		for i in 0 ..< (self.amountOfCardsToUse?.integerValue)! {
			let randomIndex = Int(arc4random()) % (self.amountOfCardsToUse?.integerValue)!
			let randomUid = self.uidArr![randomIndex] as! String
			ref.child("/\(userID)/\(randomUid)").setValue(0)
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
