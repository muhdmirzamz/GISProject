//
//  LoginViewController.swift
//  Loba
//
//  Created by Jun Hui Foong on 26/5/16.
//  Copyright © 2016 NANYANG POLYTECHNIC. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import MaterialCard
import SCLAlertView

class LoginViewController: UIViewController, ProfileProtocol {

    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var blackLine: UIImageView!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var loginBtnBG: UIImageView!
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var myid : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dark KB
        Email.keyboardAppearance = .Dark
        Password.keyboardAppearance = .Dark
        
        //Disable Auto Correct
        Email.autocorrectionType = .No
        Password.autocorrectionType = .No
        
        //hide keyboard
        let tapFunc2 = UITapGestureRecognizer.init(target: self, action: "hideKeyboard")
        self.view.addGestureRecognizer(tapFunc2)
        
        self.login.layer.cornerRadius = 5
        self.loginBtnBG.layer.cornerRadius = 5
        
        self.view.bringSubviewToFront(blackLine)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: self.appDelegate.managedObjectContext)
        let sortDescriptor = NSSortDescriptor.init(key: "username", ascending: true)
        let fetchReq = NSFetchRequest()
        fetchReq.entity = entity
        fetchReq.sortDescriptors = [sortDescriptor]
        
        let fetchResController = NSFetchedResultsController.init(fetchRequest: fetchReq, managedObjectContext: self.appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        var loggedIn = false
        
        do {
            try fetchResController.performFetch()
            
            if fetchResController.fetchedObjects?.count == 1 {
                print("Logged in")
                
                loggedIn = true
            } else {
                print("Not logged in")
                
                loggedIn = false
            }
        } catch {
            print("Unable to fetch!\n")
        }
        
        if loggedIn {
            let object = fetchResController.fetchedObjects![0]
            let username = object.valueForKey("username") as? String
            let password = object.valueForKey("password") as? String
            
            self.view.hidden = true
            
            // if user exit app
            // if user session has been terminated
            if (FIRAuth.auth()?.currentUser)! == nil {
                // log user in
                FIRAuth.auth()?.signInWithEmail(username!, password: password!, completion: nil)
            }
            
            let tabBarController = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("tabBarControllerMain") as? UITabBarController
            
            for vc in (tabBarController?.viewControllers)! {
                if vc.isKindOfClass(ProfileViewController) {
                    let tmpVC = vc as! ProfileViewController
                    tmpVC.delegate = self
                }
            }
            
            self.presentViewController(tabBarController!, animated: true, completion: nil)
        }
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func makeViewVisible() {
        self.view.hidden = false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func Login(sender: AnyObject) {
        hideKeyboard()
        self.login.enabled = false
        FIRAuth.auth()?.signInWithEmail(Email.text!, password: Password.text!, completion: {
            user, error in
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //set alert appearance
                    let appearance = SCLAlertView.SCLAppearance(
                        kTitleFont: UIFont.systemFontOfSize(30, weight: UIFontWeightLight),
                        kTitleHeight: 40,
                        kButtonFont: UIFont.systemFontOfSize(18, weight: UIFontWeightLight),
                        showCloseButton: false
                    )
                    self.login.enabled = true
                    //pop up alert
                    let alertView = SCLAlertView(appearance : appearance)
                    alertView.addButton("Retry") {
                        alertView.dismissViewControllerAnimated(true, completion: nil)
                    }
                    alertView.showError("Login Failed", subTitle: "\n Please ensure information given is correct! \n")
                })
				
                self.Email.text! = ""
                self.Password.text! = ""
            } else {
                let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: self.appDelegate.managedObjectContext)
                let object = NSManagedObject.init(entity: entity!, insertIntoManagedObjectContext: self.appDelegate.managedObjectContext)
                
                object.setValue(self.Email.text!, forKey: "username")
                object.setValue(self.Password.text!, forKey: "password")
                
                do {
                    try self.appDelegate.managedObjectContext.save()
                } catch {
                    print("Unable to save!")
                }
                
                let tabBarController = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("tabBarControllerMain") as? UITabBarController
                self.presentViewController(tabBarController!, animated: true, completion: nil)
                self.Email.text! = ""
                self.Password.text! = ""
            }
        })
    }


}

