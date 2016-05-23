//
//  BattleViewController.swift
//  GISProject
//
//  Created by Muhd Mirza on 22/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		let alert = UIAlertController.init(title: "Battle", message: "Battle over!", preferredStyle: .Alert)
		let okAction = UIAlertAction.init(title: "Ok", style: .Default) { (action: UIAlertAction) in
			let storyboard = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle())
			let battleVC = storyboard.instantiateViewControllerWithIdentifier("BattleSummaryViewController")
			
			self.navigationController?.pushViewController(battleVC, animated: true)
		}
		alert.addAction(okAction)
		
		self.presentViewController(alert, animated: true, completion: nil)
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
