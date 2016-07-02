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

class QRReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
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
    
    //Functions made just for UIAlerts
    func dismissAlert (addedAlert: UIAlertAction!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func restartCapture (addedAlert: UIAlertAction!) {
        captureSession?.startRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            messageLabel.text = ""
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedBarCodes.contains(metadataObj.type) {
            captureSession?.stopRunning()
            if metadataObj.stringValue != nil {
                
                friendUID = metadataObj.stringValue
                let ref = FIRDatabase.database().reference().child("/Account")
                
                addFriendToDB(ownerUID, friendUIDLocal: friendUID)
                
                ref.child(friendUID).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                    self.name = snapshot.value!["Name"] as! String
                    self.messageLabel.text = "Last added user, \(self.name)."
                    let addedAlert = UIAlertController(title: "\(self.name)", message: "Friend has been added", preferredStyle: .Alert)
                    addedAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: self.dismissAlert))
                    addedAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: self.restartCapture))
                    self.presentViewController(addedAlert, animated: true, completion: nil)
                })
            }
        }
    }
    
    func addFriendToDB(ownerUIDLocal : String, friendUIDLocal : String) {
        let ref = FIRDatabase.database().reference()
        ref.child("/Friend/\(ownerUIDLocal)/\(friendUIDLocal)").setValue(1)
    }
}


