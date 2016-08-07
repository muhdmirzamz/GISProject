//
//  QRViewController.swift
//  GISProject
//
//  Created by Jun Hui Foong on 22/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase
import QRCode
import MaterialCard
import BFPaperButton

class QRViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var cardLabel: UILabel!
    
    var sendUid :String!
    var lat : Double! = 0
    var log : Double! = 0
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBG()
        
        //start timer upon successful logged in
        appDelegate.setupLocationTimer()
        appDelegate.locationManagerStart()
    }

    override func viewWillAppear(animated: Bool) {
        generateQRCode()
        setCustomLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    //
    // Custom labels for user based on stats
    //
    func setCustomLabel() {
        //Init
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        let ref = FIRDatabase.database().reference().child("/Account/\(uid)")
        let ref2 = FIRDatabase.database().reference().child("/Friend/\(uid)")
        
        var name : String = ""
        var card : Int = 0
        let battle = Battle()
        
        KEY_UID = uid
        onlineUserRef.child(KEY_UID).updateChildValues(["KEY_ISONLINE":true])

        ref2.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            for i in snapshot.children {
                let key = i.key!!
                let value = snapshot.value!["\(key)"] as? NSNumber
                if value?.integerValue == 1 {
                    battle.uidArr?.addObject(key)
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.cardLabel.text = "\((battle.uidArr?.count)!)"
            })
        })
        
        ref.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                //Get values
                let name = snapshot.value!["Name"] as! String
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //Set to labels
                    self.nameLabel.text = "\(name)"
                    
                })
            })
        })
    }
    
    //
    // Generate user specific QRCode using UID
    //
    func generateQRCode() {
        let qrCard = MaterialCard(frame: CGRectMake(62.5, 157, 250, 250))
        qrCard.backgroundColor = UIColor.whiteColor()
        qrCard.shadowOpacity = 0.5
        qrCard.shadowOffsetHeight = 0
        qrCard.cornerRadius = 0
        self.view.addSubview(qrCard)
        
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        var qrCode = QRCode(uid)
        qrCode?.image
        qrCode?.size = CGSize(width: 300, height: 300)
        qrCode?.image
        let QRCodeImageView = UIImageView(qrCode: qrCode!)
        self.view.addSubview(QRCodeImageView)
        QRCodeImageView.frame = CGRectMake(62.5, 157, 250, 250)
    
        // material design button
        let button = BFPaperButton(frame: CGRectMake(112, 550, 150, 40), raised: true)
        button.setTitle("Add Card", forState: .Normal)
        button.titleFont = UIFont.systemFontOfSize(22, weight: UIFontWeightLight)
        button.backgroundColor = UIColor(red: 28/255, green: 211/255, blue: 235/255, alpha: 1)
        button.cornerRadius = 3
        button.rippleFromTapLocation = true
        button.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
    }
    
    //
    // Set HTML based map background
    //
    func setBG() {
        let localfilePath = NSBundle.mainBundle().URLForResource("simple", withExtension: "html");
        let myRequest = NSURLRequest(URL: localfilePath!);
        webView.loadRequest(myRequest);
    }
    
    //
    // Custom function to redirect viewcontroller (used due to button being coded and not in storyboard)
    //
    @IBAction func buttonPressed(sender: UIButton!) {
        let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("QRReaderViewController")
        self.showViewController(vc as! UIViewController, sender: vc)

    }
    
    //Xingyu's code
    func updateLocation(){
        sendUid = KEY_UID
        var ref =  FIRDatabase.database().reference().child("/Account/")
        if(KEY_UID != ""){
            ref.childByAppendingPath(KEY_UID).updateChildValues(["lat":self.lat])
            ref.childByAppendingPath(KEY_UID).updateChildValues(["lng":self.log])
        }else{
            print("no key yet")
        }
    }

}
