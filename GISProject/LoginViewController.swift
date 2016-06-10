//
//  LoginViewController.swift
//  Loba
//
//  Created by Jun Hui Foong on 26/5/16.
//  Copyright © 2016 NANYANG POLYTECHNIC. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .LightContent
//    }
    

    @IBAction func Login(sender: AnyObject) {
        FIRAuth.auth()?.signInWithEmail(Email.text!, password: Password.text!, completion: {
            user, error in
            
            if error != nil {
                print("Login Error")
            } else {
                let tabBarController = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("tabBarControllerMain") as? UITabBarController
                    self.presentViewController(tabBarController!, animated: true, completion: nil)
                self.Email.text! = ""
                self.Password.text! = ""
                print("Login OK!")
            }
        })
    }

}
