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
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapFunc2 = UITapGestureRecognizer.init(target: self, action: "hideKeyboard")
        self.view.addGestureRecognizer(tapFunc2)
        self.ref = FIRDatabase.database().reference()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    @IBAction func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //
    //Functions made just for UIAlerts
    //
    func dismissAlert (addedAlert: UIAlertAction!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func CreateAccount(sender: AnyObject) {
        self.registerBtn.enabled = false
        self.cancelBtn.enabled = false
        
        hideKeyboard()
        activityIndicator.startAnimating()
        
        FIRAuth.auth()?.createUserWithEmail(EmailLabel.text!, password: PasswordLabel.text!, completion: {
            user, error in
            
            if error != nil {
                self.activityIndicator.stopAnimating()
                let errorFailed = UIAlertController(title: "Account Creation Failed", message: "Please ensure information given is correct and all fields are filled up!", preferredStyle: .Alert)
                errorFailed.addAction(UIAlertAction(title: "Retry Creation", style: .Default, handler: nil))
                self.presentViewController(errorFailed, animated: true, completion: nil)
            } else {
                
                FIRAuth.auth()?.signInWithEmail(self.EmailLabel.text!, password: self.PasswordLabel.text!, completion: {
                    user, error in
                    
                    if error != nil {
                        
                    } else {
                        let uid = (FIRAuth.auth()?.currentUser?.uid)!
                        
                        let base : NSNumber = 1
                        let level : NSNumber = 1
                        let monst : NSNumber = 0
                        let cards : NSNumber = 0
                        let pict : NSNumber = 7
                        
                        //Create "Account" Firebase
                        self.ref.child("/Account/\(uid)/Name").setValue(self.UsernameLabel.text!)
                        self.ref.child("/Account/\(uid)/Base Damage").setValue(base)
                        self.ref.child("/Account/\(uid)/Level").setValue(level)
                        self.ref.child("/Account/\(uid)/Monsters killed").setValue(monst)
                        self.ref.child("/Account/\(uid)/Picture").setValue(pict)
                        self.ref.child("/Account/\(uid)/Cards").setValue(cards)
                        
                        self.activityIndicator.stopAnimating()
                        try! FIRAuth.auth()!.signOut()
                        let errorSuccess = UIAlertController(title: "Account Successfully Created", message: "Enter your information you signed up with to enter the world of LOBA", preferredStyle: .Alert)
                        errorSuccess.addAction(UIAlertAction(title: "Enter LOBA!", style: .Default, handler: self.dismissAlert))
                        self.presentViewController(errorSuccess, animated: true, completion: nil)
                        self.EmailLabel.text! = ""
                        self.UsernameLabel.text! = ""
                        self.PasswordLabel.text! = ""
                    }
                })
            }
        })
        
    }
}
