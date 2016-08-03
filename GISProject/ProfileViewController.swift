//
//  ProfileViewController.swift
//  GISProject
//
//  Created by iOS on 16/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import Bluuur
import ISTimeline
import SCLAlertView

protocol ProfileProtocol {
    func makeViewVisible()
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var blurView: MLWLiveBlurView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollView2: UIScrollView!
    
    
  
    
    var name : String = ""
    var monstersKilled : Int = 0
    var level : Int = 0
    var card : Int = 0
    var ref: FIRDatabaseReference!
    var delegate: ProfileProtocol?
    
    var lastSeen: [LastSeenLog] = []
    var activityLogs: [ActivityLog] = []
    var i = 0
    var boolActivity = true
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
//    @IBOutlet var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var monstersLabel: UILabel!
//    @IBOutlet weak var levelLabel: UILabel!
//    @IBOutlet weak var imageProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityLog()
        
        
        let localfilePath = NSBundle.mainBundle().URLForResource("simple", withExtension: "html");
        let myRequest = NSURLRequest(URL: localfilePath!);
        webView.loadRequest(myRequest);
        
        //DatabaseManager.retrieveAccount("XHPcy86H9gbGHsYYfs4FWqOtbvE")
        // Do any additional setup after loading the view.
        
        self.delegate?.makeViewVisible()
    }
    
    
    @IBAction func takePhotoBtn(sender: AnyObject) {
        print("aa")
    }
   
    

    
    
    override func viewWillAppear(animated: Bool) {
        setProfileBG()
        
        let uid = (FIRAuth.auth()?.currentUser?.uid)!

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismiss(){
       self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logout() {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont.systemFontOfSize(30, weight: UIFontWeightLight),
            kTitleHeight: 40,
            kButtonFont: UIFont.systemFontOfSize(18, weight: UIFontWeightLight),
            showCloseButton: false
        )
        //pop up alert
        let alertView = SCLAlertView(appearance : appearance)
        alertView.addButton("Yeah, log me out") {
            
            //stop updating location before log out
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.locationManagerStop()
            appDelegate.stopTimer()
            
            //set online to false
            onlineUserRef.child(KEY_UID).updateChildValues(["KEY_ISONLINE":false])
            
            
            KEY_UID = ""
            HANDLE = ""
            NEW_USER = false
            
            
            
            self.logoutSeq()
        }
        alertView.addButton("ABORT!!1!") {
            alertView.hideView()
        }
        alertView.showNotice("Logging Out", subTitle: "\n Are you sure? \n")
        
    }

    func logoutSeq () {
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: self.appDelegate.managedObjectContext)
        let sortDescriptor = NSSortDescriptor.init(key: "username", ascending: true)
        let fetchReq = NSFetchRequest()
        fetchReq.entity = entity
        fetchReq.sortDescriptors = [sortDescriptor]
        
        let fetchResController = NSFetchedResultsController.init(fetchRequest: fetchReq, managedObjectContext: self.appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchResController.performFetch()
            
            for object in fetchResController.fetchedObjects! {
                self.appDelegate.managedObjectContext.deleteObject(object as! NSManagedObject)
                print("delete")
            }
            
            do {
                try self.appDelegate.managedObjectContext.save()
            } catch {
                print("Unable to delete account")
            }
            
            print("DELETE account")
        } catch {
            print("Unable to fetch!\n")
        }
        
        
        do {
            try! FIRAuth.auth()!.signOut()
            
            print("LOGGED OUT")
            
            self.dismiss()
        } catch {
        }
    }
    
    func setProfileBG(){
//        let i = Int(arc4random_uniform(5) + 1)
//        bgProfile.image = UIImage(named: "bg\(i)")

        blurView.blurProgress = 1
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func activityLog() {
        let timeline = ISTimeline(frame: CGRectMake(0, 0, 350, 400))
        timeline.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0)
        timeline.bubbleColor = .init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        timeline.titleColor = .blackColor()
        timeline.descriptionColor = .lightTextColor()
        timeline.pointDiameter = 7.0
        timeline.lineWidth = 2.0
        timeline.bubbleRadius = 0.5
        
        let timeline2 = ISTimeline(frame: CGRectMake(0, 0, 350, 400))
        timeline2.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0)
        timeline2.bubbleColor = .init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        timeline2.titleColor = .blackColor()
        timeline2.descriptionColor = .lightTextColor()
        timeline2.pointDiameter = 7.0
        timeline2.lineWidth = 2.0
        timeline2.bubbleRadius = 0.5
        timeline2.bubbleArrows = false
        
        self.scrollView.addSubview(timeline)
        self.scrollView2.addSubview(timeline2)
        view.bringSubviewToFront(timeline)
        
        
        
        let ref = FIRDatabase.database().reference().child("/Activity")
        
        ref.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            for record in snapshot.children {
                let key = record.key!!
                
                let uid = record.value!!["uid"] as! String
                let activity = record.value!!["activity"] as! String
                let name = record.value!!["name"] as! String
                
                let point = ISPoint(title: name)
                point.description = activity
                point.lineColor = .greenColor()
                timeline.points.append(point)
                let Activity = ActivityLog.init(key: key, activity: activity, uid: uid, name: name)
                
                self.activityLogs.append(Activity)
            }
        })
    }
   //     let uid = (FIRAuth.auth()?.currentUser?.uid)!
//        let ref2 = FIRDatabase.database().reference().child("/Friend/\(uid)")
//        
//        ref2.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
//            for record in snapshot.children {
//                let key = record.key!!
//                
//                print(key)
//        
//                let ref3 = FIRDatabase.database().reference().child("/Journal/1gpYuTJr13OPfGPkmvlQSCUI5jI3")
//                
//                ref3.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
//                    let monsterType = snapshot.value!["MonsterType"] as! String
//                    let timeRetrieve = snapshot.value!["Time"] as! NSNumber
//                    let nameRetrieve = snapshot.value!["Name"] as! String
//                    
//                    //let timeConvert = timeRetrieve.integerValue
//                    let timeConvert = String(timeRetrieve)
//                    
//                    let point = ISPoint(title: nameRetrieve)
//                    point.description = monsterType
//                    timeline2.points.append(point)
//                    point.lineColor = .blueColor()
//                    let lastSeen = LastSeenLog.init(monsterType: monsterType, time: timeConvert, name: nameRetrieve)
//                    self.lastSeen.append(lastSeen)
//                
//                //                let uid = record.value!!["uid"] as! String
//                //                let activity = record.value!!["activity"] as! String
//                //                let name = record.value!!["name"] as! String
//        
//                //                self.activityLogs.append(Activity)
//        })
//    }

    
}
