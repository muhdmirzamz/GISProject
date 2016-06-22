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

class QRViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateQRCode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func generateQRCode() {
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        var qrCode = QRCode(uid)
        qrCode?.image
        qrCode?.size = CGSize(width: 300, height: 300)
        qrCode?.image
        
        let QRCodeImageView = UIImageView(qrCode: qrCode!)
        self.view.addSubview(QRCodeImageView)
        QRCodeImageView.frame = CGRectMake(100, 0, 250, 250)
        
    }

}
