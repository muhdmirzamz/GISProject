//
//  IntroStatsViewController.swift
//  GISProject
//
//  Created by Muhd Mirza on 5/8/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class IntroStatsViewController: UIViewController {

	var scrollView: UIScrollView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	@IBAction func scroll() {
		self.scrollView?.setContentOffset(CGPointMake(4 * self.view.frame.width, 0), animated: true)
	}
	
	@IBAction func scrollBack() {
		self.scrollView?.setContentOffset(CGPointMake(2 * self.view.frame.width, 0), animated: true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
