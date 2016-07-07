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

class QRViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        generateQRCode()
        setCustomNameLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func setCustomNameLabel() {
        let ref = FIRDatabase.database().reference().child("/Account")
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        var name : String = ""
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            ref.child("/\(uid)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                name = snapshot.value!["Name"] as! String
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.nameLabel.text = "\(name)"
                })
            })
        }
    }
    
    func generateQRCode() {
        let qrCard = MaterialCard(frame: CGRectMake(62.5, 157, 250, 250))
        qrCard.backgroundColor = UIColor.whiteColor()
        qrCard.shadowOpacity = 0.5
        qrCard.shadowOffsetHeight = 0
        qrCard.cornerRadius = 0
        self.view.addSubview(qrCard)
        
        let buttonCard = MaterialCard(frame: CGRectMake(87, 496, 200, 40))
        buttonCard.backgroundColor = UIColor.whiteColor()
        buttonCard.shadowOpacity = 0.5
        buttonCard.shadowOffsetHeight = 0
        buttonCard.cornerRadius = 0
        self.view.addSubview(buttonCard)
        self.view.sendSubviewToBack(buttonCard)
        
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        var qrCode = QRCode(uid)
        qrCode?.image
        qrCode?.size = CGSize(width: 300, height: 300)
        qrCode?.image
        let QRCodeImageView = UIImageView(qrCode: qrCode!)
        self.view.addSubview(QRCodeImageView)
        QRCodeImageView.frame = CGRectMake(62.5, 157, 250, 250)
    
    }

}
