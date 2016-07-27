//
//  QRReaderViewController.swift
//  GISProject
//
//  Created by Jun Hui Foong on 24/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

//
// Credits: www.appcoda.com/qr-code-reader-swift/
//

import UIKit
import AVFoundation
import MaterialCard
import Firebase
import Bluuur
import SCLAlertView

class QRReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var blurView: MLWLiveBlurView!
    
    var ref : FIRDatabaseReference!
    
    var name : String!
    var friendUID : String!
    let ownerUID : String = (FIRAuth.auth()?.currentUser?.uid)!
    
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    let supportedBarCodes = [AVMetadataObjectTypeQRCode]
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    @IBAction func dismiss(){
        captureSession?.stopRunning()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func restartCapture () {
        captureSession?.startRunning()
    }
    
//    func restartCapture (addedAlert: UIAlertAction!) {
//        captureSession?.startRunning()
//    }

    
//    //Functions made just for UIAlerts
//    func dismissAlert (addedAlert: UIAlertAction!) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBG()
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Add material card design
            let qrCardScanner = MaterialCard(frame: CGRectMake(62.5, 157, 250, 250))
            qrCardScanner.backgroundColor = UIColor.whiteColor()
            qrCardScanner.shadowOpacity = 0.5
            qrCardScanner.shadowOffsetHeight = 0
            qrCardScanner.cornerRadius = 0
            self.view.addSubview(qrCardScanner)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = CGRectMake(62.5, 157, 250, 250)
            view.layer.addSublayer(videoPreviewLayer!)
            captureSession?.startRunning()
            view.bringSubviewToFront(messageLabel)
        } catch {
            print(error)
            return
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        setBlur()
        setBG()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            messageLabel.text = ""
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedBarCodes.contains(metadataObj.type) {
            captureSession?.stopRunning()
            if metadataObj.stringValue != nil {
                //translate QRCode to string
                friendUID = metadataObj.stringValue
                //check QRCode length
                let UIDLength = friendUID.characters.count
                //set alert appearance
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont.systemFontOfSize(30, weight: UIFontWeightLight),
                    kTitleHeight: 40,
                    kButtonFont: UIFont.systemFontOfSize(18, weight: UIFontWeightLight),
                    showCloseButton: false
                )
                
                //check if legit UID
                if (UIDLength == 28) {
                    //check if scanning own code
                    if (ownerUID != friendUID) {
                        let ref = FIRDatabase.database().reference().child("/Account")
                        addFriendToDB(ownerUID, friendUIDLocal: friendUID)
                        
                        ref.child(friendUID).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                            //set custom label
                            self.name = snapshot.value!["Name"] as! String
                            self.messageLabel.text = "Added user, \(self.name)."
                            //pop up alert
                            let alertView = SCLAlertView(appearance : appearance)
                            alertView.addButton("Continue Scanning") {
                                self.restartCapture()
                            }
                            alertView.addButton("Done") {
                                self.dismiss()
                            }
                            alertView.showSuccess("Alright!", subTitle: "\n Friend has been added \n")
                        })
                    } else {
                        let alertView = SCLAlertView(appearance : appearance)
                        alertView.addButton("Try Again") {
                            self.restartCapture()
                        }
                        alertView.addButton("Done") {
                            self.dismiss()
                        }
                        alertView.showError("Aw come on!", subTitle: "\n Scanning your own QRCode is lame! Go find a friend! \n")
                    }
                } else {
                    let alertView = SCLAlertView(appearance : appearance)
                    alertView.addButton("Try Again") {
                        self.restartCapture()
                    }
                    alertView.addButton("Done") {
                        self.dismiss()
                    }
                    alertView.showError("Invalid Code", subTitle: "\n What the heck did you just scan?!?! \n")

                }
            }
        }
    }
    
    func addFriendToDB(ownerUIDLocal : String, friendUIDLocal : String) {
        let ref = FIRDatabase.database().reference()
        ref.child("/Friend/\(ownerUIDLocal)/\(friendUIDLocal)").setValue(1)
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
    // Blur overlay
    //
    func setBlur() {
        blurView.blurProgress = 0.5
    }
}


