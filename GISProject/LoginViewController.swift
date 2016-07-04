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

class LoginViewController: UIViewController {

    @IBOutlet var image: UIImageView!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var myid : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //easter egg :D
        let tapFunc1 = UITapGestureRecognizer.init(target: self, action: "changeView")
        tapFunc1.numberOfTapsRequired = 10
        tapFunc1.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapFunc1)
        
        //hide keyboard
        let tapFunc2 = UITapGestureRecognizer.init(target: self, action: "hideKeyboard")
        self.view.addGestureRecognizer(tapFunc2)
    }

    func changeView() {
        self.image.image = UIImage.init(named: "loba")
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func Login(sender: AnyObject) {
        hideKeyboard()
        FIRAuth.auth()?.signInWithEmail(Email.text!, password: Password.text!, completion: {
            user, error in
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let errorAlert = UIAlertController(title: "Login Failed", message: "Please ensure information given is correct!", preferredStyle: .Alert)
                    errorAlert.addAction(UIAlertAction(title: "Fix it now!!!", style: .Default, handler: nil))
                    self.presentViewController(errorAlert, animated: true, completion: nil)
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

