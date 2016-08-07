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
	
    var initialMonsterHealth: Float?
    var monsterHealth: Float?
    var amountOfCardsToUse: NSNumber?
	var amountOfCardsAvailable: NSNumber?
	var uidArr: NSMutableArray?
	
	var baseDamage: NSNumber?
    var expectedMonsterHealth: Float?

    var nameuid: String?
    var monsKilled: NSNumber?
    var monsType: String?
    var time: String?
    var nameJournal: String?
    
	var selectedAnnotation: Location?
    
	init() {
        self.initialMonsterHealth = 2 // this is the base
		self.monsterHealth = 2
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
    func getInitialMonsterHealth() -> Int {
        return Int(self.initialMonsterHealth!)
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
            print("Update player")
		})
	}
	
	func updateCards() {
		// generate a random number using amount of cards to use as the limit
		// set 0 to it to indicate that card has been used
		let userID = (FIRAuth.auth()?.currentUser?.uid)!
		let ref = FIRDatabase.database().reference().child("/Friend")

		for i in 0 ..< (self.amountOfCardsToUse?.integerValue)! {
			let uid = self.uidArr![i] as! String
			ref.child("/\(userID)/\(uid)").setValue(0)

            print("Setting card to 0")
		}
        
        print("Update cards")
	}
    
    func updateMonster() {
        let random = Int(arc4random()) % 5
        var monsterImg: UIImage?
        print("Random monster id: \(random)")
        
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
        
        print("Update monster")
    }
	
    func updatePreviousLocation() {
        let str = (self.selectedAnnotation?.imageString)!
        let monsterType = str.substringWithRange(Range<String.Index>(start: str.startIndex, end: str.endIndex.advancedBy(-8)))
        
        let ref = FIRDatabase.database().reference().child("/PreviousLocation")
        ref.child("/\(monsterType)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            print("Previous location count: \(snapshot.childrenCount)")
			
			let index: Int
			
            if snapshot.childrenCount < 10 {
                index = Int(snapshot.childrenCount) + 1
            } else {
                index = (Int(arc4random()) % 9) + 1
            }
			
			ref.child("/\(monsterType)/\(index)/latitude").setValue((self.selectedAnnotation?.coordinate.latitude)!)
			ref.child("/\(monsterType)/\(index)/longitude").setValue((self.selectedAnnotation?.coordinate.longitude)!)
        })
        
        print("Update previous location")
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
        print("Update location")
	}
    
    func updateActivity() {
        let userID = (FIRAuth.auth()?.currentUser?.uid)!
        //Retrieve name and uid
        let ref = FIRDatabase.database().reference().child("/Account")
        ref.child("/\(userID)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            self.monsKilled = snapshot.value!["Monsters killed"] as? NSNumber
            self.nameuid = snapshot.value!["Name"] as! String
            print(self.nameuid!)
            print((self.monsKilled?.integerValue)!)
			
			// Update activity table
			let activityNum = Int(arc4random_uniform(10) + 1)
			let ref2 = FIRDatabase.database().reference().child("/Activity/\(activityNum)")
			let updatedKilled = (self.monsKilled?.integerValue)! + 1
			ref2.child("activity").setValue("has killed \(updatedKilled) monsters")
			ref2.child("uid").setValue(userID)
			ref2.child("name").setValue(self.nameuid)
        })
        print("Update activity")
    }
    
    func updateJournal(){
        let userID = (FIRAuth.auth()?.currentUser?.uid)!
        let ref4 = FIRDatabase.database().reference().child("/Account")
        ref4.child("/\(userID)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            self.nameJournal = snapshot.value!["Name"] as! String
            
            let str = (self.selectedAnnotation?.imageString)!
            let monsterType = str.substringWithRange(Range<String.Index>(start: str.startIndex, end: str.endIndex.advancedBy(-8)))
            
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([ .Hour, .Minute, .Second], fromDate: date)
            let hour = components.hour
            let minutes = components.minute
            //Used for retrieving of date from firebase
            //var date = NSDate(timeIntervalSince1970: interval)
            let ref3 = FIRDatabase.database().reference().child("Journal/\(userID)")
            ref3.child("MonsterType").setValue("killed a \(monsterType) monster")
            ref3.child("Hour").setValue(hour)
            ref3.child("Minutes").setValue(minutes)
            ref3.child("Name").setValue(self.nameJournal)
            print("Update journal")
        })
        
    }
	
}
