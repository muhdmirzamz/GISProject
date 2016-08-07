//
//  YoViewController.swift
//  GISProject
//
//  Created by Muhd Mirza on 5/8/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class IntroQRViewController: UIViewController {

	var scrollView: UIScrollView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	

	@IBAction func scroll() {
		self.scrollView?.setContentOffset(CGPointMake(self.view.frame.width, 0), animated: true)
	}
	
	@IBAction func scrollToLogin() {
		self.scrollView?.setContentOffset(CGPointMake(4 * self.view.frame.width, 0), animated: true)
	}

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
