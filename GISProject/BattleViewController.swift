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
		self.monsterHealth = 100
		self.monsterHealthLabel.text = "\(String(Int(self.monsterHealth!)))/100"
		
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
		
		// check to see if user's card switch should be switched on
		self.checkUserCardSwitch()
		
		// attach a selector to user card switch to listen for value change
		self.userCardSwitch.addTarget(self, action: "userCardSwitchDidChange", forControlEvents: .ValueChanged)
		
		// get base damage, this becomaes initial calculated damage
		// get amount of cards
		let ref = FIRDatabase.database().reference().child("/Account")
		let userID = (FIRAuth.auth()?.currentUser?.uid)!
		ref.child("/\(userID)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
			self.baseDamage = snapshot.value!["Base damage"] as? NSNumber
			self.calculatedDamageLabel.text = String((self.baseDamage?.integerValue)!)

			self.amountOfCards = snapshot.value!["Cards"] as? NSNumber
			
			for i in 1 ... (self.amountOfCards?.integerValue)! {
				self.cardsArr?.addObject(i)
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
		
		if (self.amountOfCardsToUse?.integerValue)! > 0 {
			let userID = (FIRAuth.auth()?.currentUser?.uid)!
			let ref = FIRDatabase.database().reference().child("/Account")
			
			ref.child("/\(userID)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
				let prevAmountOfCards = snapshot.value!["Cards"] as? NSNumber
				print((prevAmountOfCards?.integerValue)!)
				let currAmountOfCards = (prevAmountOfCards?.integerValue)! - (self.amountOfCardsToUse?.integerValue)!
				print(currAmountOfCards)
				let cards = NSNumber.init(integer: currAmountOfCards)
				ref.child("/\(userID)/Cards").setValue(cards)
			})
		}
		
		if self.monsterHealth == 0 {
			let userID = (FIRAuth.auth()?.currentUser?.uid)!
			let ref = FIRDatabase.database().reference().child("/Account")
			
			var currMonstersKilled: NSNumber?
			
			ref.child("/\(userID)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
				let prevMonstersKilled = snapshot.value!["Monsters killed"] as? NSNumber
				currMonstersKilled = Int((prevMonstersKilled?.intValue)!) - 1
				ref.child("/\(userID)/Monsters killed").setValue(currMonstersKilled)
			})
		}

		var random = Double(arc4random()) % 0.007357
		let latitudeRange = 1.376527 + random
		random = Double(arc4random()) % 0.007328
		let longitudeRange = 103.843563 + random
		
		let ref = FIRDatabase.database().reference().child("/Location")
		let key = (self.selectedAnnotation?.key)!
		ref.child("/\(key)/latitude").setValue(latitudeRange)
		ref.child("/\(key)/longitude").setValue(longitudeRange)
	}
	
	func decreaseMonsterHealth() {
		if self.monsterHealth > 0 {
			if self.monsterHealth > self.expectedMonsterHealth {
				self.monsterHealth = self.monsterHealth! - 1
				self.monsterHealthLabel.text = "\(String(Int(self.monsterHealth!)))/100"
				self.monsterHealthBar.progress = self.monsterHealth! / 100
			} else {
				self.timer?.invalidate()
				
				self.timer = NSTimer()
				timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "handleNavController", userInfo: nil, repeats: false)
			}// prevent health bar from having the glitch of going negative
		} else {
			self.timer?.invalidate()
			
			self.timer = NSTimer()
			timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "handleNavController", userInfo: nil, repeats: false)
		}
	}
	
	func calculateDamage(useOwnCard: Bool) {
		var calculatedDamage: Int?
		let baseDamage = (self.baseDamage?.integerValue)!
		let amountOfCardsToUse = (self.amountOfCardsToUse?.integerValue)!
		
		if useOwnCard {
			calculatedDamage = baseDamage + amountOfCardsToUse
		}
		
		self.calculatedDamageLabel.text = String(calculatedDamage!)
	}
	
	func checkUserCardSwitch() {
		if self.amountOfCardsToUse! == 0 || self.textfield.text == "0" {
			self.userCardSwitch.on = true
			self.userCardSwitch.enabled = false
		} else {
			self.userCardSwitch.on = true
			self.userCardSwitch.enabled = true
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
