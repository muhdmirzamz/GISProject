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
    
    func didFinishLaunchingWithOptions(){
        FIRApp.configure()
    }
    

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
                print("Account not created")
            } else {
                
                FIRAuth.auth()?.signInWithEmail(self.EmailLabel.text!, password: self.PasswordLabel.text!, completion: {
                    user, error in
                    
                    if error != nil {
                        print("Login Error")
                    } else {
                        FIRAuth.auth()?.addAuthStateDidChangeListener {
                            auth, user in
                            
                            if let user = user {
                                if let user = FIRAuth.auth()?.currentUser {
                                    let uid = user.uid
                                    print(uid)
                                    
                                    //Creation of account
                                    let base : NSNumber = 1
                                    let level : NSNumber = 1
                                    let key = self.ref.child("Account").childByAutoId().key
                                    let Account = ["uid": uid, "name": self.UsernameLabel.text!, "base damage" : base, "level" : level]
                                    let childUpdates = ["/Account/\(key)": Account]
                                    self.ref.updateChildValues(childUpdates)
                                    //self.ref.child("Account").child(uid).setValue(["name" : self.UsernameLabel.text!])
                                    
//                                    DatabaseManager.registerAccount(uid, name: self.UsernameLabel.text!, monstersKilled: 0, level: 1)
                                    self.activityIndicator.stopAnimating()
                                    print("Account creation OK!")
                                    self.dismiss()
                                }
                            } else {
                                
                            }
                        }
                    }
                })
            }
        })
        
    }
}
