//
//  QRReaderViewController.swift
//  GISProject
//
//  Created by Jun Hui Foong on 24/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

//
// FROM www.appcoda.com/qr-code-reader-swift/
//

import UIKit
import AVFoundation
import MaterialCard
import Firebase

class QRReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var ref : FIRDatabaseReference!
    
    var name : String!
    
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    //var qrCodeFrameView:UIView?
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode]
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    @IBAction func dismiss(){
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
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Add material card design
            let qrCardScanner = MaterialCard(frame: CGRectMake(62.5, 157, 250, 250))
            qrCardScanner.backgroundColor = UIColor.whiteColor()
            qrCardScanner.shadowOpacity = 0.5
            qrCardScanner.shadowOffsetHeight = 0
            qrCardScanner.cornerRadius = 0
            self.view.addSubview(qrCardScanner)
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            //videoPreviewLayer?.frame = view.layer.bounds
            videoPreviewLayer?.frame = CGRectMake(62.5, 157, 250, 250)
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession?.startRunning()
            
            // Move the message label to the top view
            view.bringSubviewToFront(messageLabel)
            
            // Initialize QR Code Frame to highlight the QR code
            //qrCodeFrameView = UIView()
            
            //            if let qrCodeFrameView = qrCodeFrameView {
            //                qrCodeFrameView.layer.borderColor = UIColor.greenColor().CGColor
            //                qrCodeFrameView.layer.borderWidth = 2
            //                view.addSubview(qrCodeFrameView)
            //                view.bringSubviewToFront(qrCodeFrameView)
            //            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            //            qrCodeFrameView?.frame = CGRectZero
            messageLabel.text = ""
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
            //        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            //let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj)
            //qrCodeFrameView?.frame = barCodeObject!.bounds
            captureSession?.stopRunning()
            if metadataObj.stringValue != nil {
                let ref = FIRDatabase.database().reference().child("/Account")
                ref.child(metadataObj.stringValue).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
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
}


