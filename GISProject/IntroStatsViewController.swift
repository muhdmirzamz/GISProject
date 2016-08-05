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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
