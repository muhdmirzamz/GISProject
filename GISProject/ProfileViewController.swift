//
//  ProfileViewController.swift
//  GISProject
//
//  Created by iOS on 16/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    var name : String = ""
    var monstersKilled : Int = 0
    var level : Int = 0
    var uid : String = ""
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var monstersLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        
        if let user = FIRAuth.auth()?.currentUser {
            uid = user.uid
            print(uid)
        }
        var ref = FIRDatabase.database().reference().child("Account")
        
        ref.queryEqualToValue(uid)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            ref.observeEventType(.Value, withBlock: {(snapshot) in

                for record in snapshot.children {
                    let level = record.value!!["Level"] as! NSNumber
                    let monstersKilled = record.value!!["Monsters killed"] as! NSNumber
                    let name = record.value!!["Name"] as! String
                    print(level.intValue)
                    print(monstersKilled.intValue)
                    print(name)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.nameLabel.text = name
                        self.monstersLabel.text = String(monstersKilled.intValue)
                        self.levelLabel.text = String(level.intValue)
                        
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidden = true
                    })
                }
            })
        }
        
 
        //DatabaseManager.retrieveAccount("XHPcy86H9gbGHsYYfs4FWqOtbvE")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = "Profile"
        navigationItem.rightBarButtonItem?.title = "Activity Log"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logout() {
        
        do {
            try! FIRAuth.auth()!.signOut()
            self.dismiss()
        } catch {
            
        }

    }

}
