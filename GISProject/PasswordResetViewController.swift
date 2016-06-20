//
//  PasswordResetViewController.swift
//  GISProject
//
//  Created by Jun Hui Foong on 20/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase

class PasswordResetViewController: UIViewController {

    @IBOutlet weak var EmailLabel: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapFunc2 = UITapGestureRecognizer.init(target: self, action: "hideKeyboard")
        self.view.addGestureRecognizer(tapFunc2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func PasswordReset(sender: AnyObject) {
        hideKeyboard()
        activityIndicator.startAnimating()
        
        let email = EmailLabel.text!

        FIRAuth.auth()?.sendPasswordResetWithEmail(email) { error in
            if let error = error {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.activityIndicator.stopAnimating()
                    let errorAlert = UIAlertController(title: "Password Reset Failed", message: "Please ensure information given is correct!", preferredStyle: .Alert)
                    errorAlert.addAction(UIAlertAction(title: "Fix it now!!!", style: .Default, handler: nil))
                    self.presentViewController(errorAlert, animated: true, completion: nil)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.activityIndicator.stopAnimating()
                    let errorAlert = UIAlertController(title: "Password Reset Complete", message: "Please check the provided Email to proceed.", preferredStyle: .Alert)
                    errorAlert.addAction(UIAlertAction(title: "Alright!", style: .Default, handler: nil))
                    self.presentViewController(errorAlert, animated: true, completion: nil)
                    self.EmailLabel.text! = ""
                    self.dismiss()
                })
            }
        }
    }
    
}
