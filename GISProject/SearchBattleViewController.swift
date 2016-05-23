//
//  BattleScreenViewController.swift
//  GISProject
//
//  Created by Muhd Mirza on 12/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class SearchBattleViewController: UIViewController, searchLocation {
	
	@IBOutlet var cancelButton: UIBarButtonItem!
	@IBOutlet var searchBattleButton: UIBarButtonItem!
	@IBOutlet var imageView: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.imageView.image = UIImage.init(named: "you are here")
		
		self.navigationItem.leftBarButtonItems?.removeAll()
	}

	func changeToCurrentLocationImage() {
		self.imageView.image = UIImage.init(named: "you are here")
		
		let searchBattleButton = UIBarButtonItem.init(title: "See available battles", style: .Plain, target: self, action: #selector(SearchBattleViewController.goToLocationSearch))
		self.navigationItem.rightBarButtonItem = searchBattleButton
		
		self.navigationItem.leftBarButtonItems?.removeAll()
	}

	func changeToNavigationImage() {
		self.imageView.image = UIImage.init(named: "navigation")
		
		let cancelButton = UIBarButtonItem.init(title: "Cancel", style: .Plain, target: self, action: #selector(SearchBattleViewController.cancelNavigation))
		self.navigationItem.leftBarButtonItem = cancelButton
		
		self.navigationItem.rightBarButtonItems?.removeAll()
		
		let alert = UIAlertController.init(title: "Battle", message: "Start battle?", preferredStyle: .Alert)
		let noAction = UIAlertAction.init(title: "No", style: .Default, handler: nil)
		let yesAction = UIAlertAction.init(title: "Yes", style: .Default) { (action: UIAlertAction) in
			let storyboard = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle())
			let battleVC = storyboard.instantiateViewControllerWithIdentifier("BattleViewController")
		
			self.navigationController?.pushViewController(battleVC, animated: true)
		}
		alert.addAction(noAction)
		alert.addAction(yesAction)
		
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	func goToLocationSearch() {
		self.performSegueWithIdentifier("locationSegue", sender: self)
	}
	
	func cancelNavigation() {
		self.changeToCurrentLocationImage()
	}
	
	func startBattle() {
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "locationSegue" {
			let navController = segue.destinationViewController as? UINavigationController
			let searchLocationVC = navController?.topViewController as? SearchLocationViewController
			searchLocationVC?.delegate = self
		}
    }

}
