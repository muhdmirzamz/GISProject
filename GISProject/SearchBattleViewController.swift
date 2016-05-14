//
//  BattleScreenViewController.swift
//  GISProject
//
//  Created by Muhd Mirza on 12/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class SearchBattleViewController: UIViewController, searchLocationProtocol {

	@IBOutlet var mapImageView: UIImageView!
	
	var searchLocationTableViewController: SearchLocationTableViewController?
	var navController: UINavigationController?
	
	var tabBarHeight: CGFloat!
	var navControllerYPos: CGFloat!
	var navControllerHeight: CGFloat!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let storyboard = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle())
		self.searchLocationTableViewController = storyboard.instantiateViewControllerWithIdentifier("SearchLocation") as? SearchLocationTableViewController
		self.searchLocationTableViewController!.delegate = self
		self.navController = UINavigationController.init(rootViewController: searchLocationTableViewController!)
		
		self.tabBarHeight = self.tabBarController?.tabBar.frame.size.height
		self.navControllerYPos = self.view.frame.size.height - tabBarHeight! - navController!.navigationBar.frame.height
		self.navControllerHeight = self.view.frame.size.height - tabBarHeight!
	
		self.navController!.view.frame = CGRectMake(0, self.navControllerYPos, self.view.frame.size.width, self.view.frame.height - 50)
	
		self.navController!.navigationBar.backgroundColor = UIColor.redColor()
		self.view.addSubview((self.navController?.view)!)
    }

	func didTouchTableViewController(didTouch: Bool) {
		if (didTouch) {
			self.navController!.view.frame = CGRectMake(0, navControllerYPos - 200, self.view.frame.size.width, navControllerHeight - 50)
		}
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
