//
//  SignupViewController.swift
//  Loba
//
//  Created by Jun Hui Foong on 26/5/16.
//  Copyright © 2016 NANYANG POLYTECHNIC. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

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
    
    @IBAction func CreateAccount(sender: AnyObject) {
        self.registerBtn.enabled = false
        self.cancelBtn.enabled = false
        //set alert appearance
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont.systemFontOfSize(30, weight: UIFontWeightLight),
            kTitleHeight: 40,
            kButtonFont: UIFont.systemFontOfSize(18, weight: UIFontWeightLight),
            showCloseButton: false
        )
        
        hideKeyboard()
        activityIndicator.startAnimating()
        
        FIRAuth.auth()?.createUserWithEmail(EmailLabel.text!, password: PasswordLabel.text!, completion: {
            user, error in
            
            if error != nil {
                self.activityIndicator.stopAnimating()
                //pop up alert
                let alertView = SCLAlertView(appearance : appearance)
                alertView.addButton("Retry") {
                    alertView.dismissViewControllerAnimated(true, completion: nil)
                }
                alertView.showError("Creation Failed", subTitle: "\n Please ensure information given is correct and all fields are filled up! \n")
                self.registerBtn.enabled = true
                self.cancelBtn.enabled = true
            } else {
                
                FIRAuth.auth()?.signInWithEmail(self.EmailLabel.text!, password: self.PasswordLabel.text!, completion: {
                    user, error in
                    
                    if error != nil {
                        
                    } else {
                        let uid = (FIRAuth.auth()?.currentUser?.uid)!
                        
                        let base : NSNumber = 1
                        let level : NSNumber = 1
                        let monst : NSNumber = 0
                        let pict : NSNumber = 7
                        let lat : NSNumber = 0
                        let lng : NSNumber = 0
                        let KEY_ISONLINE : Bool = false
                        
                        //Create "Account" Firebase
                        self.ref.child("/Account/\(uid)/Name").setValue(self.UsernameLabel.text!)
                        self.ref.child("/Account/\(uid)/Base Damage").setValue(base)
                        self.ref.child("/Account/\(uid)/Level").setValue(level)
                        self.ref.child("/Account/\(uid)/Monsters killed").setValue(monst)
                        self.ref.child("/Account/\(uid)/Picture").setValue(pict)
                        self.ref.child("/Account/\(uid)/lat").setValue(lat)
                        self.ref.child("/Account/\(uid)/lng").setValue(lng)
                        self.ref.child("/Account/\(uid)/KEY_ISONLINE").setValue(KEY_ISONLINE)
                        
                        
                        self.activityIndicator.stopAnimating()
                        try! FIRAuth.auth()!.signOut()
                        //pop up alert
                        let alertView = SCLAlertView(appearance : appearance)
                        alertView.addButton("Done") {
                            self.dismiss()
                        }
                        alertView.showSuccess("Success!", subTitle: "\n Enter your information you signed up with to enter the world of LOBA \n")

                        self.EmailLabel.text! = ""
                        self.UsernameLabel.text! = ""
                        self.PasswordLabel.text! = ""
                    }
                })
            }
        })
        
    }
}
