//
//  BattleViewController2.swift
//  GISProject
//
//  Created by iOS on 11/7/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase
import Bluuur

protocol BattleProtocol {
	func reloadMap()
}

class BattleViewController: UIViewController {
	
	@IBOutlet var blurView: MLWLiveBlurView!
	@IBOutlet var monsterImgView: UIImageView!
    @IBOutlet var monsterHealthBar: UIProgressView!
    @IBOutlet var monsterHealthLabel: UILabel!
	
	var alert: UIAlertController?
	
	var imageString: String?
	
    // to change the annotation location after killing monster
    var selectedAnnotation: Location?
    
    var delegate: BattleProtocol?
    var battle: Battle?
	var timer: NSTimer?
	
	let userID = (FIRAuth.auth()?.currentUser?.uid)!

    override func viewDidLoad() {
        super.viewDidLoad()

		// set up blur view
		self.blurView.blurProgress = 0.3
		
		// set up monster image
		let image = UIImage.init(named: self.imageString!)
		
		UIGraphicsBeginImageContextWithOptions(CGSize.init(width: self.monsterImgView.frame.width, height: self.monsterImgView.frame.height), false, 0.0);
		image!.drawInRect(CGRectMake(0, 0, self.monsterImgView.frame.width, self.monsterImgView.frame.height))
		let newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		self.monsterImgView.image = newImage
		
		// set up battle entity
		self.battle!.selectedAnnotation = self.selectedAnnotation
		
		// set initial monster health
		self.monsterHealthLabel.text = "\(String(self.battle!.getMonsterHealth()))/1"
		
		let userID = (FIRAuth.auth()?.currentUser?.uid)!
		let ref = FIRDatabase.database().reference().child("/Account")
		ref.child("/\(userID)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
			self.battle?.baseDamage = snapshot.value!["Base Damage"] as? NSNumber
		})
		
		// card tap gestures
		let cardAttack = UITapGestureRecognizer.init(target: self, action: "useExtraCards")
		cardAttack.numberOfTapsRequired = 2
		cardAttack.numberOfTouchesRequired = 1
		self.view.addGestureRecognizer(cardAttack)
		
		let cardAttack2 = UILongPressGestureRecognizer.init(target: self, action: "useOwnCard")
		self.view.addGestureRecognizer(cardAttack2)
    }
	
	func useExtraCards() {
		self.alert = UIAlertController.init(title: "How many do you want to use?", message: "", preferredStyle: .Alert)
		self.alert?.addTextFieldWithConfigurationHandler({ (textfield) in
			textfield.keyboardType = .NumberPad
		})
		let okAction = UIAlertAction.init(title: "Ok", style: .Default) { (alert) in
			// get the text
			let text = self.alert?.textFields![0].text
			self.battle?.amountOfCardsToUse = NSNumber.init(integer: Int.init(text!)!)
			print((self.battle?.amountOfCardsToUse!.integerValue)!)
			print((self.battle?.uidArr?.count)!)
			
			// uid arr count is also used as amount of cards available
			if (self.battle?.amountOfCardsToUse?.integerValue)! > (self.battle?.amountOfCardsAvailable?.integerValue)! {
				print("Dont have enough")
			
				let alert = UIAlertController.init(title: "Hold up", message: "You do not have enough cards!", preferredStyle: .Alert)
				let okAction = UIAlertAction.init(title: "Ok", style: .Default, handler: nil)
				alert.addAction(okAction)
				
				self.presentViewController(alert, animated: true, completion: nil)
			} else {
				// calculate expected damage
				self.battle?.expectedMonsterHealth = Float((self.battle?.monsterHealth)!) - Float((self.battle?.amountOfCardsToUse!.integerValue)!)
	
				self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "decreaseMonsterHealth", userInfo: nil, repeats: true)
			}
			
		}
		let cancelAction = UIAlertAction.init(title: "Cancel", style: .Default, handler: nil)
		
		alert!.addAction(okAction)
		alert!.addAction(cancelAction)
		
		self.presentViewController(alert!, animated: true, completion: nil)
	}
	
	func useOwnCard() {
		// reset amount of cards to use because it will cause a bug when updating cards
		self.battle?.amountOfCardsToUse = 0
	
		self.alert = UIAlertController.init(title: "Use your own card", message: "Are you sure?", preferredStyle: .Alert)
		let yesAction = UIAlertAction.init(title: "Yes", style: .Default) { (alert) in
			// implement user card check
		
			// calculate expected damage
			self.battle?.expectedMonsterHealth = Float((self.battle?.monsterHealth)!) - Float((self.battle?.baseDamage?.integerValue)!)

			self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "decreaseMonsterHealth", userInfo: nil, repeats: true)
			
		}
		let noAction = UIAlertAction.init(title: "No", style: .Default, handler: nil)

		alert!.addAction(yesAction)
		alert!.addAction(noAction)

		self.presentViewController(alert!, animated: true, completion: nil)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	

//			let date = NSDate()
//			let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour, .Minute], fromDate:date)
//			
//			// skip to the next day if current time is after 9:00:
//			if (components.hour >= 9) {
//				components.day += 1;
//			}
//			
//			components.hour = 9;
//			components.minute = 0;
//			
//			let fireDate = NSCalendar.currentCalendar().dateFromComponents(components)
//			
//			print("Notification will fire at: \(fireDate)")
//			
//			let localNotif = UILocalNotification()
//			localNotif.fireDate = fireDate
//			localNotif.alertBody = "You can use your card again"
//			localNotif.alertAction = "Ready for battle"
//			localNotif.timeZone = NSTimeZone.localTimeZone()
//			localNotif.repeatInterval = .Day
//			localNotif.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
//			UIApplication.sharedApplication().scheduleLocalNotification(localNotif)
//			NSNotificationCenter.defaultCenter().postNotificationName("battle", object: self)
//		}
//		let scheduledLocalNotifCount = UIApplication.sharedApplication().scheduledLocalNotifications!.count

	
	
	func decreaseMonsterHealth() {
		// the health loop - to decrease health
		if self.battle?.getMonsterHealth() > 0 {
			if self.battle?.getMonsterHealth() > self.battle?.getExpectedMonsterHealth() {
				self.battle?.monsterHealth = (self.battle?.monsterHealth)! - 1
				self.monsterHealthLabel.text = "\(String(Int((self.battle?.monsterHealth)!)))/1"
				self.monsterHealthBar.progress = Float((self.battle?.getMonsterHealth())!) / 100
			} else {
				// stop timer to avoid health bar glitch
				self.timer?.invalidate()
				
				self.battle?.updateCards()
				
				// update the number of cards
				let ref = FIRDatabase.database().reference().child("/Friend")
				ref.child("/\(self.userID)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
					self.battle?.uidArr?.removeAllObjects()
				
					for i in snapshot.children {
						let key = i.key!!
						let value = snapshot.value!["\(key)"] as? NSNumber
						
						if value?.integerValue == 1 {
							self.battle!.uidArr?.addObject(key)
						}
					}
					
					self.battle!.amountOfCardsAvailable = NSNumber(integer: Int((self.battle!.uidArr?.count)!))
					print((self.battle!.amountOfCardsAvailable?.integerValue)!)
				})
			}
		} else {
			self.timer?.invalidate()
			
			// go back to map
			self.alert = UIAlertController.init(title: "Alright", message: "Going back to the map", preferredStyle: .Alert)
			let okAction = UIAlertAction.init(title: "Ok", style: .Default) { (alert) in
				self.battle?.updatePlayer()
				self.battle?.updateCards()
				self.battle?.updateMonster()
				self.battle?.updateLocation()
			
				self.backToMap()
			}
			alert!.addAction(okAction)
			
			self.presentViewController(alert!, animated: true, completion: nil)
		}
	}
	
	@IBAction func dismissBattle() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func backToMap() {
		self.delegate?.reloadMap()
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}
