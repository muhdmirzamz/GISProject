//
//  HelloViewController.swift
//  GISProject
//
//  Created by Muhd Mirza on 5/8/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class IntroViewController: UIViewController, ProfileProtocol {

	@IBOutlet var scrollView: UIScrollView!
	var introQRVC: IntroQRViewController?
	var introActivityVC: IntroActivityViewController?
	var introBattleVC: IntroBattleViewController?
	var introStatsVC: IntroStatsViewController?
	var loginVC: LoginViewController?
	
	var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

	override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

		let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: self.appDelegate.managedObjectContext)
		let sortDescriptor = NSSortDescriptor.init(key: "username", ascending: true)
		let fetchReq = NSFetchRequest()
		fetchReq.entity = entity
		fetchReq.sortDescriptors = [sortDescriptor]
		
		let fetchResController = NSFetchedResultsController.init(fetchRequest: fetchReq, managedObjectContext: self.appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		
		var loggedIn = false
		
		do {
			try fetchResController.performFetch()
			
			if fetchResController.fetchedObjects?.count == 1 {
				print("Logged in")
				
				loggedIn = true
			} else {
				print("Not logged in")
				
				loggedIn = false
			}
		} catch {
			print("Unable to fetch!\n")
		}
		
		if loggedIn {
			self.view.hidden = true
			
			let object = fetchResController.fetchedObjects![0]
			let username = object.valueForKey("username") as? String
			let password = object.valueForKey("password") as? String
			
			// if user exit app
			// if user session has been terminated
			if (FIRAuth.auth()?.currentUser)! == nil {
				// log user in
				FIRAuth.auth()?.signInWithEmail(username!, password: password!, completion: nil)
			}
			
			let tabBarController = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("tabBarControllerMain") as? UITabBarController
			
			for vc in (tabBarController?.viewControllers)! {
				if vc.isKindOfClass(ProfileViewController) {
					let tmpVC = vc as! ProfileViewController
					tmpVC.delegate = self
				}
			}
			
			
			self.presentViewController(tabBarController!, animated: true, completion: nil)
		} else {
			self.introQRVC = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("IntroQRViewController") as? IntroQRViewController
			self.introActivityVC = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("IntroActivityViewController") as? IntroActivityViewController
			self.introBattleVC = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("IntroBattleViewController") as? IntroBattleViewController
			self.introStatsVC = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("IntroStatsViewController") as? IntroStatsViewController
			self.loginVC = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController
			
			// pass the scrollview to the view controllers so they have access
			// need this so you can change screens when button is pressed
			self.introQRVC?.scrollView = self.scrollView
			self.introActivityVC?.scrollView = self.scrollView
			self.introBattleVC?.scrollView = self.scrollView
			self.introStatsVC?.scrollView = self.scrollView
			
			// add in reverse order because it is a stack
			self.addChildViewController(loginVC!)
			self.scrollView.addSubview((loginVC?.view)!)
			self.addChildViewController(introStatsVC!)
			self.scrollView.addSubview((introStatsVC?.view)!)
			self.addChildViewController(introBattleVC!)
			self.scrollView.addSubview((introBattleVC?.view)!)
			self.addChildViewController(introActivityVC!)
			self.scrollView.addSubview((introActivityVC?.view)!)
			self.addChildViewController(introQRVC!)
			self.scrollView.addSubview((introQRVC?.view)!)
			
			// set the frame
			// just multiply the frame width because you want the origin to be at the width of each screen
			var introQRVCFrame = introQRVC?.view.frame
			introQRVCFrame?.origin.x = (introQRVCFrame?.width)!;
			introActivityVC!.view.frame = introQRVCFrame!;
			
			var introActivityVCFrame = introActivityVC?.view.frame
			introActivityVCFrame!.origin.x = 2 * (introActivityVCFrame?.width)!;
			introBattleVC!.view.frame = introActivityVCFrame!;
			
			var introBattleVCFrame = introBattleVC?.view.frame
			introBattleVCFrame!.origin.x = 3 * (introBattleVCFrame?.width)!;
			introStatsVC!.view.frame = introBattleVCFrame!;
			
			var introStatsVCFrame = introStatsVC?.view.frame
			introStatsVCFrame!.origin.x = 4 * (introStatsVCFrame?.width)!;
			loginVC!.view.frame = introStatsVCFrame!;
			
			let scrollWidth = 5 * self.view.frame.width
			let scrollHeight = self.view.frame.height
			self.scrollView.contentSize = CGSizeMake(scrollWidth, scrollHeight)
		}
    }
	
	func makeViewVisible() {
		self.view.hidden = false
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
