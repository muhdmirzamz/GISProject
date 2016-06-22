//
//  SignupViewController.swift
//  Loba
//
//  Created by Jun Hui Foong on 26/5/16.
//  Copyright © 2016 NANYANG POLYTECHNIC. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var UsernameLabel: UITextField!
    @IBOutlet weak var EmailLabel: UITextField!
    @IBOutlet weak var PasswordLabel: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapFunc2 = UITapGestureRecognizer.init(target: self, action: "hideKeyboard")
        self.view.addGestureRecognizer(tapFunc2)
        self.ref = FIRDatabase.database().reference()
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    func didFinishLaunchingWithOptions(){
//        FIRApp.configure()
//    }
	

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    @IBAction func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func CreateAccount(sender: AnyObject) {
        hideKeyboard()
        activityIndicator.startAnimating()
        
        FIRAuth.auth()?.createUserWithEmail(EmailLabel.text!, password: PasswordLabel.text!, completion: {
            user, error in
            
            if error != nil {
                    self.activityIndicator.stopAnimating()
                    let errorFailed = UIAlertController(title: "Account Creation Failed", message: "Please ensure information given is correct and all fields are filled up!", preferredStyle: .Alert)
                    errorFailed.addAction(UIAlertAction(title: "Retry Creation", style: .Default, handler: nil))
                    self.presentViewController(errorFailed, animated: true, completion: nil)
                print("Account not created")
            } else {
                
                FIRAuth.auth()?.signInWithEmail(self.EmailLabel.text!, password: self.PasswordLabel.text!, completion: {
                    user, error in
                    
                    if error != nil {
                        print("Login Error")
                    } else {
						let uid = (FIRAuth.auth()?.currentUser?.uid)!
					
						let base : NSNumber = 1
						let level : NSNumber = 1
						let monst : NSNumber = 0
						let cards : NSNumber = 0
						let pict : NSNumber = 6
						print("HELLOW")
					
						self.ref.child("/Account/\(uid)/Name").setValue(self.UsernameLabel.text!)
						self.ref.child("/Account/\(uid)/Base Damage").setValue(base)
						self.ref.child("/Account/\(uid)/Level").setValue(level)
						self.ref.child("/Account/\(uid)/Monsters killed").setValue(monst)
						self.ref.child("/Account/\(uid)/Picture").setValue(pict)
					
						self.activityIndicator.stopAnimating()
						try! FIRAuth.auth()!.signOut()
						let errorSuccess = UIAlertController(title: "Account Successfully Created", message: "Enter your information you signed up with to enter the world of LOBA", preferredStyle: .Alert)
						errorSuccess.addAction(UIAlertAction(title: "Enter LOBA!", style: .Default, handler: nil))
						self.presentViewController(errorSuccess, animated: true, completion: nil)
						self.EmailLabel.text! = ""
						self.UsernameLabel.text! = ""
						self.PasswordLabel.text! = ""
						print("Account creation OK!")
					
						
						
						
					
//                        FIRAuth.auth()?.addAuthStateDidChangeListener {
//                            auth, user in
//							
//                            if let user = user {
//                                if let user = FIRAuth.auth()?.currentUser {
//                                    let uid = user.uid
//                                    print(uid)
//                                    
//                                    //Creation of account
//                                    let base : NSNumber = 1
//                                    let level : NSNumber = 1
//                                    let monst : NSNumber = 0
//                                    let cards : NSNumber = 0
//                                    let pict : NSNumber = 6
//                                    print("HELLOW")
//                                    
////                                    let key = self.ref.child("Account/\(uid)").key
////                                    let Account = ["Name": self.UsernameLabel.text! as NSString, "Base damage" : base, "Level" : level, "Monsters killed": monst, "Cards" : cards, "Picture" : pict]
////                                    let childUpdates = ["/Account/\(key)": Account]
////                                    self.ref.updateChildValues(childUpdates)
//									self.ref.child("/Account/\(uid)/Name").setValue(self.UsernameLabel.text!)
//									self.ref.child("/Account/\(uid)/Base Damage").setValue(base)
//									self.ref.child("/Account/\(uid)/Level").setValue(level)
//									self.ref.child("/Account/\(uid)/Monsters killed").setValue(monst)
//									self.ref.child("/Account/\(uid)/Picture").setValue(pict)
//									
////          DatabaseManager.registerAccount(uid, name: self.UsernameLabel.text!, monstersKilled: 0, level: 1)
//                                        self.activityIndicator.stopAnimating()
//                                        try! FIRAuth.auth()!.signOut()
//                                        let errorSuccess = UIAlertController(title: "Account Successfully Created", message: "Enter your information you signed up with to enter the world of LOBA", preferredStyle: .Alert)
//                                        errorSuccess.addAction(UIAlertAction(title: "Enter LOBA!", style: .Default, handler: nil))
//                                        self.presentViewController(errorSuccess, animated: true, completion: nil)
//                                    self.EmailLabel.text! = ""
//                                    self.UsernameLabel.text! = ""
//                                    self.PasswordLabel.text! = ""
//                                    print("Account creation OK!")
//                                }
//                            } else {
//                                
//                            }
//                        }
                    }
                })
            }
        })
        
    }
}
