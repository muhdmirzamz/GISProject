//
//  PasswordResetViewController.swift
//  GISProject
//
//  Created by Jun Hui Foong on 20/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class PasswordResetViewController: UIViewController {

    @IBOutlet weak var EmailLabel: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Disable Auto Correct
        EmailLabel.autocorrectionType = .No

        //Dark KB
        EmailLabel.keyboardAppearance = .Dark
        
        //hide keyboard
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
    
    //
    // Password reset on button click
    //
    @IBAction func PasswordReset(sender: AnyObject) {
        hideKeyboard()
        activityIndicator.startAnimating()
        
        let email = EmailLabel.text!
        //set alert appearance
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont.systemFontOfSize(28, weight: UIFontWeightLight),
            kTitleHeight: 40,
            kButtonFont: UIFont.systemFontOfSize(18, weight: UIFontWeightLight),
            showCloseButton: false
        )
        
        FIRAuth.auth()?.sendPasswordResetWithEmail(email) { error in
            if let error = error {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.activityIndicator.stopAnimating()
                    //pop up alert
                    let alertView = SCLAlertView(appearance : appearance)
                    alertView.addButton("Retry") {
                        alertView.hideView()
                    }
                    alertView.showError("Reset Failed", subTitle: "\n Please ensure information given is correct! \n")
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.activityIndicator.stopAnimating()
                    //pop up alert
                    let alertView = SCLAlertView(appearance : appearance)
                    alertView.addButton("Done") {
                        self.dismiss()
                    }
                    alertView.showSuccess("Reset Requested", subTitle: "\n Please check provided email for further instructions. \n")
                    self.EmailLabel.text! = ""
                })
            }
        }
    }
    
}
