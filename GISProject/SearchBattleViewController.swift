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
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.mapImageView.image = UIImage.init(named: "you are here")
		
		let tap = UITapGestureRecognizer.init(target: self, action: #selector(SearchBattleViewController.tap))
		tap.numberOfTapsRequired = 1
		tap.numberOfTouchesRequired = 1
		self.view.addGestureRecognizer(tap)
    }

	func tap() {
		let storyboard = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle())
		let searchLocationVC = storyboard.instantiateViewControllerWithIdentifier("SearchLocationViewController") as? SearchLocationViewController
		let navController = UINavigationController.init(rootViewController: searchLocationVC!)
		searchLocationVC?.delegate = self
		
		self.presentViewController(navController, animated: true, completion: nil)
	}
	
	func sendNavigationImage(didSelectBattle: Bool) {
		self.mapImageView.image = UIImage.init(named: "navigation")
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
