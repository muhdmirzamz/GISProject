//
//  BattleViewController.swift
//  GISProject
//
//  Created by Muhd Mirza on 24/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase

protocol BattleProtocol {
	func backtoMap()
}

class BattleViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	
	@IBOutlet var monsterHealthBar: UIProgressView!
	@IBOutlet var monsterHealthLabel: UILabel!
	@IBOutlet var textfield: UITextField!
	@IBOutlet var calculatedDamageLabel: UILabel!
	@IBOutlet var userCardSwitch: UISwitch!
	@IBOutlet var attackButton: UIButton!

	var selectedAnnotation: LocationModel?

	var pickerView: UIPickerView?
	var cardsArr: NSMutableArray?
	var uidArr: NSMutableArray?
	var baseDamage: NSNumber?
	var amountOfCards: NSNumber?
	var amountOfCardsToUse: NSNumber?
	
	// for attack timer animation
	var monsterHealth: Float?
	var expectedMonsterHealth: Float?
	var timer: NSTimer?
	
	var delegate: BattleProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // set initial monster health to 100
		self.monsterHealth = 1
		self.monsterHealthLabel.text = "\(String(Int(self.monsterHealth!)))/1"
		
		// initialize picker view
		self.pickerView = UIPickerView()
		self.pickerView?.delegate = self
		self.pickerView?.dataSource = self
		
		// set initial amount of cards to use and set to textfield
		self.amountOfCardsToUse = 0
		self.textfield.inputView = self.pickerView
		self.textfield.text = String(self.amountOfCardsToUse!)
		
		// user can have the option of using 0 extra cards
		self.cardsArr = NSMutableArray()
		self.cardsArr?.addObject(0)
		
		self.uidArr = NSMutableArray()
		
		// check to see if user's card switch should be switched on
		self.checkUserCardSwitch()
		
		// attach a selector to user card switch to listen for value change
		self.userCardSwitch.addTarget(self, action: "userCardSwitchDidChange", forControlEvents: .ValueChanged)
		
		// get base damage, this becomaes initial calculated damage
		// get amount of cards
		var ref = FIRDatabase.database().reference().child("/Account")
		let userID = (FIRAuth.auth()?.currentUser?.uid)!
		ref.child("/\(userID)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
			self.baseDamage = snapshot.value!["Base Damage"] as? NSNumber
            self.calculateDamage(self.userCardSwitch.on)

			self.amountOfCards = snapshot.value!["Cards"] as? NSNumber
			
            if (self.amountOfCards?.integerValue)! > 0 {
                for i in 1 ... (self.amountOfCards?.integerValue)! {
                    self.cardsArr?.addObject(i)
                }
            }
		})
		
		ref = FIRDatabase.database().reference().child("/Friend")
		ref.child("/\(userID)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
			var counter = 1
		
			for i in snapshot.children {
				print(i.key!!)
				
				let key = i.key!!
				let value = snapshot.value!["\(key)"] as? NSNumber
				
				if value?.integerValue == 1 {
					print("Adding..")
					self.uidArr?.addObject(key)
					self.cardsArr?.addObject(counter)
					
					counter = counter + 1
				}
			}
		})
		
		// an addition to aid user to dismiss picker view
		let tapDown = UITapGestureRecognizer.init(target: self, action: "pickerViewDown")
		tapDown.numberOfTapsRequired = 1
		tapDown.numberOfTouchesRequired = 1
		self.view.addGestureRecognizer(tapDown)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func userCardSwitchDidChange() {
		self.calculateDamage(self.userCardSwitch.on)
	}
	
	func pickerViewDown() {
		self.textfield.resignFirstResponder()
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return (self.cardsArr?.count)!
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return String(self.cardsArr![row])
	}
	
	func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 50
	}

	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		print("tapped")
		self.textfield.text = String(self.cardsArr![row])
		self.textfield.resignFirstResponder()
		
		self.amountOfCardsToUse = NSNumber.init(integer: Int.init(String(self.cardsArr![row]))!)
		self.calculateDamage(self.userCardSwitch.on)
		
		self.checkUserCardSwitch()
	}

	@IBAction func attack() {
		self.attackButton.enabled = false
	
		self.expectedMonsterHealth = self.monsterHealth! - Float(self.calculatedDamageLabel.text!)!
	
		self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "decreaseMonsterHealth", userInfo: nil, repeats: true)
		
        if self.userCardSwitch.on {
            let date = NSDate()
            let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour, .Minute], fromDate:date)
            
            // skip to the next day if current time is after 9:00:
            if (components.hour >= 9) {
                components.day += 1;
            }
            
            components.hour = 9;
            components.minute = 0;
            
            let fireDate = NSCalendar.currentCalendar().dateFromComponents(components)
            
            print("Notification will fire at: \(fireDate)")
            
            let localNotif = UILocalNotification()
            localNotif.fireDate = fireDate
            localNotif.alertBody = "You can use your card again"
            localNotif.alertAction = "Ready for battle"
            localNotif.timeZone = NSTimeZone.localTimeZone()
            localNotif.repeatInterval = .Day
            localNotif.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            UIApplication.sharedApplication().scheduleLocalNotification(localNotif)
            NSNotificationCenter.defaultCenter().postNotificationName("battle", object: self)
        }
        
		if (self.amountOfCardsToUse?.integerValue)! > 0 {
			let userID = (FIRAuth.auth()?.currentUser?.uid)!
			let ref = FIRDatabase.database().reference().child("/Friend")
			
			for i in 0 ..< (self.amountOfCardsToUse?.integerValue)! {
				let randomIndex = Int(arc4random()) % (self.amountOfCardsToUse?.integerValue)!
				let randomUid = self.uidArr![randomIndex] as! String
				ref.child("/\(userID)/\(randomUid)").setValue(0)
			}
		}
        
		var random = Double(arc4random()) % 0.004983
		let latitudeRange = 1.377431 + random
		random = Double(arc4random()) % 0.002122
		let longitudeRange = 103.848156 + random
		
		let ref = FIRDatabase.database().reference().child("/Location")
		let key = (self.selectedAnnotation?.key)!
		ref.child("/\(key)/latitude").setValue(latitudeRange)
		ref.child("/\(key)/longitude").setValue(longitudeRange)
	}
	
	func decreaseMonsterHealth() {
		if self.monsterHealth > 0 {
			if self.monsterHealth > self.expectedMonsterHealth {
				self.monsterHealth = self.monsterHealth! - 1
				self.monsterHealthLabel.text = "\(String(Int(self.monsterHealth!)))/1"
				self.monsterHealthBar.progress = self.monsterHealth! / 100
			} else {
				self.timer?.invalidate()
				
				self.timer = NSTimer()
				timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "handleNavController", userInfo: nil, repeats: false)
			}// prevent health bar from having the glitch of going negative
		} else {
			let userID = (FIRAuth.auth()?.currentUser?.uid)!
			let ref = FIRDatabase.database().reference().child("/Account")
			
			var currMonstersKilled: NSNumber?
			
			ref.child("/\(userID)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
				let prevMonstersKilled = snapshot.value!["Monsters killed"] as? NSNumber
				currMonstersKilled = (prevMonstersKilled?.integerValue)! + 1
				ref.child("/\(userID)/Monsters killed").setValue(currMonstersKilled)
			})
		
			self.timer?.invalidate()
			
			self.timer = NSTimer()
			timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "handleNavController", userInfo: nil, repeats: false)
		}
	}
	
	func calculateDamage(useOwnCard: Bool) {
		var calculatedDamage: Int?
		let amountOfCardsToUse = (self.amountOfCardsToUse?.integerValue)!
        let scheduledLocalNotifCount = UIApplication.sharedApplication().scheduledLocalNotifications!.count
        
        if scheduledLocalNotifCount == 0 {
            self.baseDamage = (self.baseDamage?.integerValue)!
        } else {
            self.baseDamage = 0
        }
		
		if useOwnCard {
			calculatedDamage = (self.baseDamage?.integerValue)! + amountOfCardsToUse
        } else {
            calculatedDamage = amountOfCardsToUse
        }
		
        if calculatedDamage == 0 {
            self.calculatedDamageLabel.text = String(calculatedDamage!)
            
            let alert = UIAlertController.init(title: "Whoops", message: "You can't even m8", preferredStyle: .Alert)
            let okAction = UIAlertAction.init(title: "OK", style: .Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.calculatedDamageLabel.text = String(calculatedDamage!)
        }
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

	func handleNavController() {
		self.navigationController?.popToRootViewControllerAnimated(true)
		self.delegate?.backtoMap()
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
