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
    var ref: FIRDatabaseReference!
    
//    @IBOutlet var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var monstersLabel: UILabel!
//    @IBOutlet weak var levelLabel: UILabel!
//    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var monstersLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var bgProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DatabaseManager.retrieveAccount("XHPcy86H9gbGHsYYfs4FWqOtbvE")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        setProfileBG()
        
        self.activityIndicator.startAnimating()
        
        let ref = FIRDatabase.database().reference().child("/Account")
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        print(uid)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            ref.child("/\(uid)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                
                let level = snapshot.value!["Level"] as! NSNumber
                let monstersKilled = snapshot.value!["Monsters killed"] as! NSNumber
                let name = snapshot.value!["Name"] as! String
                let pict = snapshot.value!["Picture"] as! NSNumber
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.nameLabel.text = name
                    self.monstersLabel.text = String(monstersKilled.intValue)
                    self.levelLabel.text = String(level.intValue)
                    switch pict.intValue {
                    case 0 :
                        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                        self.imageProfile.layer.borderWidth = 2.0
                        self.imageProfile.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).CGColor
                        self.imageProfile.image = UIImage(named: "ProfileBlack")
                    case 1 :
                        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                        self.imageProfile.layer.borderWidth = 2.0
                        self.imageProfile.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).CGColor
                        self.imageProfile.image = UIImage(named: "ProfileBlue")
                    case 2 :
                        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                        self.imageProfile.layer.borderWidth = 2.0
                        self.imageProfile.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).CGColor
                        self.imageProfile.image = UIImage(named: "ProfileGreen")
                    case 3 :
                        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                        self.imageProfile.layer.borderWidth = 2.0
                        self.imageProfile.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).CGColor
                        self.imageProfile.image = UIImage(named: "ProfileOrange")
                    case 4 :
                        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                        self.imageProfile.layer.borderWidth = 2.0
                        self.imageProfile.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).CGColor
                        self.imageProfile.image = UIImage(named: "ProfilePurple")
                    case 5 :
                        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                        self.imageProfile.layer.borderWidth = 2.0
                        self.imageProfile.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).CGColor
                        self.imageProfile.image = UIImage(named: "ProfileRed")
                    case 6 :
                        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                        self.imageProfile.layer.borderWidth = 2.0
                        self.imageProfile.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).CGColor
                        self.imageProfile.image = UIImage(named: "ProfileSponge")
                    default:
                        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                        self.imageProfile.layer.borderWidth = 2.0
                        self.imageProfile.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).CGColor
                        self.imageProfile.image = UIImage(named: "ProfileBlack")
                    }
                    
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    
                })
                
            })
        }

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
    
    func setProfileBG(){
        let i = Int(arc4random_uniform(5) + 1)
        
        bgProfile.image = UIImage(named: "bg\(i)")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    


}
