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
import SCLAlertView
import CoreData

protocol BattleProtocol {
	func reloadMap()
}

class BattleViewController: UIViewController {
	
	@IBOutlet var blurView: MLWLiveBlurView!
    @IBOutlet var amountOfCardAvailable: UILabel!
    @IBOutlet var userCardAvailable: UILabel!
	@IBOutlet var monsterImgView: UIImageView!
    @IBOutlet var monsterNameLabel: UILabel!
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
	var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
		// set up blur view
		self.blurView.blurProgress = 1.0
		
		// set up monster image
		let image = UIImage.init(named: self.imageString!)
		
		UIGraphicsBeginImageContextWithOptions(CGSize.init(width: self.monsterImgView.frame.width, height: self.monsterImgView.frame.height), false, 0.0);
		image!.drawInRect(CGRectMake(0, 0, self.monsterImgView.frame.width, self.monsterImgView.frame.height))
		let newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		self.monsterImgView.image = newImage
		
		// set up battle entity
		self.battle!.selectedAnnotation = self.selectedAnnotation
		
        // UI stuff
        self.amountOfCardAvailable.text = String((self.battle?.amountOfCardsAvailable?.integerValue)!)
		self.monsterHealthLabel.text = "\(String(self.battle!.getMonsterHealth()))/\(String(self.battle!.getInitialMonsterHealth()))"
        
        let str = (self.selectedAnnotation?.imageString)!
        let monsterType = str.substringWithRange(Range<String.Index>(start: str.startIndex, end: str.endIndex.advancedBy(-8)))
        var ref = FIRDatabase.database().reference().child("/Monster")
        ref.child("/\(monsterType)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            self.monsterNameLabel.text = snapshot.value!["name"] as? String 
        })
		
		if self.isUserCardAvailable() {
			self.userCardAvailable.text = "Available"
		} else {
			self.userCardAvailable.text = "Not available"
		}
		
        // get the base damage
		let userID = (FIRAuth.auth()?.currentUser?.uid)!
		ref = FIRDatabase.database().reference().child("/Account")
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
			
			// validate the input
			if text == "" || text == "0" {
				self.alert = UIAlertController.init(title: "Hold up", message: "Invalid input", preferredStyle: .Alert)
				let okAction = UIAlertAction.init(title: "Ok", style: .Default, handler: nil)
				self.alert?.addAction(okAction)
				self.presentViewController(self.alert!, animated: true, completion: nil)
			} else {
				self.battle?.amountOfCardsToUse = NSNumber.init(integer: Int.init(text!)!)
//				print((self.battle?.amountOfCardsToUse!.integerValue)!)
//				print((self.battle?.uidArr?.count)!)
				
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
		}
		let cancelAction = UIAlertAction.init(title: "Cancel", style: .Default, handler: nil)
		
		alert!.addAction(cancelAction)
		alert!.addAction(okAction)
		
		self.presentViewController(alert!, animated: true, completion: nil)
	}
	
	func useOwnCard() {
		// reset amount of cards to use because it will cause a bug when updating cards
		self.battle?.amountOfCardsToUse = 0
		
		// this does not use the self-provided method because I need the NSManagedObject to display the date
		var userCanUseCard = true
		var object: NSManagedObject?
		
		let entity = NSEntityDescription.entityForName("Date", inManagedObjectContext: self.appDelegate.managedObjectContext)
		let sortDescriptor = NSSortDescriptor.init(key: "uid", ascending: true)
		let fetchReq = NSFetchRequest()
		fetchReq.entity = entity
		fetchReq.sortDescriptors = [sortDescriptor]
		
		let fetchResController = NSFetchedResultsController.init(fetchRequest: fetchReq, managedObjectContext: self.appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		
		do {
			try fetchResController.performFetch()
			
			for i in fetchResController.fetchedObjects! {
				object = i as? NSManagedObject
				
				// if there is already an entry, then user has used up card
				if (FIRAuth.auth()?.currentUser?.uid)! == (object!.valueForKey("uid"))! as! String {
					userCanUseCard = false
				}
			}
		} catch {
			print("Unable to fetch")
		}
		
        if userCanUseCard == false {
            var fireDate = object!.valueForKey("date") as? NSDate
            let dateFormatter = NSDateFormatter()
            //dateFormatter.dateFormat = "HH:mm dd-MM-yyyy"
			dateFormatter.dateFormat = "HH:mm"
			
			var timePeriod = ""
			let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour, .Minute], fromDate:fireDate!)
			if components.hour <= 11 && components.minute <= 59 {
				timePeriod = "am"
			} else {
				timePeriod = "pm"
				
				components.hour = components.hour - 12
				fireDate = NSCalendar.currentCalendar().dateFromComponents(components)
			}
            
            self.alert = UIAlertController.init(title: "Hold up", message: "You need to wait until \(dateFormatter.stringFromDate(fireDate!))\(timePeriod)", preferredStyle: .Alert)
            let okAction = UIAlertAction.init(title: "Ok", style: .Default, handler: nil)
            self.alert!.addAction(okAction)
            
            self.presentViewController(self.alert!, animated: true, completion: nil)
        } else {
            self.alert = UIAlertController.init(title: "Use your own card", message: "Are you sure?", preferredStyle: .Alert)
            let yesAction = UIAlertAction.init(title: "Yes", style: .Default) { (alert) in
                // calculate expected damage
                self.battle?.expectedMonsterHealth = Float((self.battle?.monsterHealth)!) - Float((self.battle?.baseDamage?.integerValue)!)
                
                // set the date
                let date = NSDate()
                let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour, .Minute], fromDate:date)
				components.minute += 2
                
                let fireDate = NSCalendar.currentCalendar().dateFromComponents(components)
				print(fireDate)
				
				// save the date
				let entity = NSEntityDescription.entityForName("Date", inManagedObjectContext: self.appDelegate.managedObjectContext)
				let object = NSManagedObject.init(entity: entity!, insertIntoManagedObjectContext: self.appDelegate.managedObjectContext)
				object.setValue((FIRAuth.auth()?.currentUser?.uid)!, forKey: "uid")
				object.setValue(fireDate, forKey: "date")
				
				do {
					try self.appDelegate.managedObjectContext.save()
				} catch {
					print("Unable to save the date")
				}
				
				// start timer
                self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "decreaseMonsterHealth", userInfo: nil, repeats: true)
            }
            let noAction = UIAlertAction.init(title: "No", style: .Default, handler: nil)
			
			alert!.addAction(noAction)
            alert!.addAction(yesAction)
            
            self.presentViewController(alert!, animated: true, completion: nil)
        }
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func decreaseMonsterHealth() {
		// the health loop - to decrease health
		if self.battle?.getMonsterHealth() > 0 {
			if self.battle?.getMonsterHealth() > self.battle?.getExpectedMonsterHealth() {
				self.battle?.monsterHealth = (self.battle?.monsterHealth)! - 1
				self.monsterHealthLabel.text = "\(String(Int((self.battle?.monsterHealth)!)))/\(String(self.battle!.getInitialMonsterHealth()))"
				self.monsterHealthBar.progress = Float((self.battle?.getMonsterHealth())!) / Float((self.battle?.getInitialMonsterHealth())!)
			} else {
				// stop timer to avoid health bar glitch
				self.timer?.invalidate()
				
                // update all the cards
				self.battle?.updateCards()
				
				// update the number of extra cards
				let ref = FIRDatabase.database().reference().child("/Friend")
				ref.child("/\(self.userID)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                    // remember to reset uid array
                    // this causes a bug with cards
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
                    
                    // set label
                    self.amountOfCardAvailable.text = String((self.battle?.amountOfCardsAvailable?.integerValue)!)
					
					if self.isUserCardAvailable() == false &&
						(self.battle?.amountOfCardsAvailable?.integerValue)! == 0 {
						self.userCardAvailable.text = "Not available"
						
						// go back to map
						self.alert = UIAlertController.init(title: "Hold up", message: "You do not have enough cards to continue", preferredStyle: .Alert)
						let okAction = UIAlertAction.init(title: "Ok", style: .Default) { (alert) in
							// dismiss view controller
							self.delegate?.reloadMap()
							self.dismissViewControllerAnimated(true, completion: nil)
						}
						self.alert!.addAction(okAction)
						
						self.presentViewController(self.alert!, animated: true, completion: nil)
					} else if self.isUserCardAvailable() == true {
						self.userCardAvailable.text = "Available"
					}
				})
			}
		} else {
			self.timer?.invalidate()
			
			// go back to map
			self.alert = UIAlertController.init(title: "Alright", message: "Going back to the map", preferredStyle: .Alert)
			let okAction = UIAlertAction.init(title: "Ok", style: .Default) { (alert) in
                // update all the things
				self.battle?.updatePlayer()
				self.battle?.updateCards()                
				self.battle?.updateMonster()
                self.battle?.updatePreviousLocation()
				self.battle?.updateLocation()
                
                self.battle?.updateActivity()
                self.battle?.updateJournal()
                
                // update the number of extra cards
                let ref2 = FIRDatabase.database().reference().child("/Friend")
                ref2.child("/\(self.userID)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                    self.battle?.uidArr?.removeAllObjects()
                    
                    for i in snapshot.children {
                        let key = i.key!!
                        let value = snapshot.value!["\(key)"] as? NSNumber
                        
                        if value?.integerValue == 1 {
                            self.battle!.uidArr?.addObject(key)
                        }
                    }
                    
                    self.battle!.amountOfCardsAvailable = NSNumber(integer: Int((self.battle!.uidArr?.count)!))
                    print("Amount of cards available: \((self.battle!.amountOfCardsAvailable?.integerValue)!)")
                    
                    // set label
                    self.amountOfCardAvailable.text = String((self.battle?.amountOfCardsAvailable?.integerValue)!)
                    
                    // dismiss view controller
                    self.delegate?.reloadMap()
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
			}
			alert!.addAction(okAction)
			
			self.presentViewController(alert!, animated: true, completion: nil)
		}
	}
	
	func isUserCardAvailable() -> Bool {
		var available = true
	
		let entity = NSEntityDescription.entityForName("Date", inManagedObjectContext: self.appDelegate.managedObjectContext)
		let sortDescriptor = NSSortDescriptor.init(key: "uid", ascending: true)
		let fetchReq = NSFetchRequest()
		fetchReq.entity = entity
		fetchReq.sortDescriptors = [sortDescriptor]
		
		let fetchResController = NSFetchedResultsController.init(fetchRequest: fetchReq, managedObjectContext: self.appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		
		do {
			try fetchResController.performFetch()
			
			for i in fetchResController.fetchedObjects! {
				let object = i as? NSManagedObject
				
				if (FIRAuth.auth()?.currentUser?.uid)! == (object?.valueForKey("uid"))! as! String {
					available = false
					
					break
				}
			}
		} catch {
			print("Unable to fetch")
		}
		
		return available
	}
	
	@IBAction func dismissBattle() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}
