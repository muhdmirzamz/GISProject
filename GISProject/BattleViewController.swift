//
//  BattleViewController2.swift
//  GISProject
//
//  Created by iOS on 11/7/16.
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
    @IBOutlet var userCardSwitch: UISwitch!
    @IBOutlet var calculatedDamageLabel: UILabel!
    @IBOutlet var attackButton: UIButton!
    
    // to change the annotation location after killing monster
    var selectedAnnotation: Location?
    
    var pickerView: UIPickerView?
    
    var delegate: BattleProtocol?
    var battle: Battle?
	var timer: NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// initialise battle entity
		self.battle = Battle()
		
		// pass selected annotation to battle entity
		self.battle!.selectedAnnotation = self.selectedAnnotation
		
		// set initial monster health
		self.monsterHealthLabel.text = "\(String(self.battle!.getMonsterHealth()))/1"
		
		// set up picker view
		self.pickerView = UIPickerView()
		self.pickerView?.delegate = self
		self.pickerView?.dataSource = self
		
		// set picker view to the textfield input view
		self.textfield.inputView = self.pickerView
		
		// set the amount of cards to use in textfield
		self.textfield.text = String(self.battle!.getAmountOfCardsToUse())
		
		// set up user card switch
		self.userCardSwitch.on = true
		self.userCardSwitch.enabled = true
		
		// attach a selector to user card switch to listen for value change
		self.userCardSwitch.addTarget(self, action: "userCardSwitchDidChange", forControlEvents: .ValueChanged)
		
		self.calculatedDamageLabel.text = "\(String(self.battle!.calculateDamage()))"
		
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
		let calculatedDamage = self.battle?.calculateDamage()
		
		if calculatedDamage == 0 {
			let alert = UIAlertController.init(title: "Whoops", message: "You can't even m8", preferredStyle: .Alert)
			let okAction = UIAlertAction.init(title: "OK", style: .Default, handler: { (action) -> Void in
				self.dismissViewControllerAnimated(true, completion: nil)
			})
			alert.addAction(okAction)
			
			self.presentViewController(alert, animated: true, completion: nil)
		}
		
		self.calculatedDamageLabel.text = String(calculatedDamage!)
	}
	
	func pickerViewDown() {
		self.textfield.resignFirstResponder()
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.battle!.getAmountOfCards()
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let tmpCardsArray = self.battle!.cardsArr
		return String(tmpCardsArray![row])
	}
	
	func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 50
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		print("tapped")
		let tmpCardsArray = self.battle!.cardsArr
		self.textfield.text = String(tmpCardsArray![row])
		self.textfield.resignFirstResponder()

		self.battle?.amountOfCardsToUse = NSNumber.init(integer: Int.init(String(tmpCardsArray![row]))!)
		
		let calculatedDamage = self.battle?.calculateDamage()
		self.calculatedDamageLabel.text = String(calculatedDamage!)
	}
	
	@IBAction func attack() {
		// disable attack button so user cannot press
		// there is a delay between transitions and it is possible to press button if not disabled
		self.attackButton.enabled = false
		
		// set expected monster health to avoid health bar glitch
		self.battle?.expectedMonsterHealth = Float((self.battle?.monsterHealth)!) - Float((self.battle?.calculatedDamage?.integerValue)!)
		
		// set timer to decrease monster health
		self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "decreaseMonsterHealth", userInfo: nil, repeats: true)

		self.battle?.updateCards()
		self.battle?.updateLocation()

		// set a local notification for user card if it is used
//		if self.userCardSwitch.on {
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

	}
	
//	func checkUserCardSwitch() {
//		let scheduledLocalNotifCount = UIApplication.sharedApplication().scheduledLocalNotifications!.count
//		print(scheduledLocalNotifCount)
//		
//		// user has used card
//		if scheduledLocalNotifCount > 0 {
//			self.userCardSwitch.on = false
//			self.userCardSwitch.enabled = false
//		} else {
//			self.userCardSwitch.on = true
//			
//			if self.amountOfCardsToUse! == 0 || self.textfield.text == "0" {
//				self.userCardSwitch.enabled = false
//			} else {
//				self.userCardSwitch.enabled = true
//			}
//		}
//	}
	
	
	func decreaseMonsterHealth() {
		if self.battle?.getMonsterHealth() > 0 {
			if self.battle?.getMonsterHealth() > self.battle?.getExpectedMonsterHealth() {
				self.battle?.monsterHealth = (self.battle?.monsterHealth)! - 1
				self.monsterHealthLabel.text = "\(String(Int((self.battle?.monsterHealth)!)))/1"
				self.monsterHealthBar.progress = Float((self.battle?.getMonsterHealth())!) / 100
			} else {
				self.timer?.invalidate()
				
				self.timer = NSTimer()
				timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "handleNavController", userInfo: nil, repeats: false)
			}// prevent health bar from having the glitch of going negative
		} else {
			self.battle?.updatePlayer()
			
			self.timer?.invalidate()
			
			self.timer = NSTimer()
			timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "handleNavController", userInfo: nil, repeats: false)
		}
	}
	
	func handleNavController() {
		self.navigationController?.popToRootViewControllerAnimated(true)
		self.delegate?.backtoMap()
	}
}
