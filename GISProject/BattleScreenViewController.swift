//
//  BattleScreenViewController.swift
//  GISProject
//
//  Created by Muhd Mirza on 12/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class BattleScreenViewController: UIViewController {

	@IBOutlet var mapImageView: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let tap = UITapGestureRecognizer.init(target: self, action: #selector(BattleScreenViewController.tap))
		tap.numberOfTapsRequired = 1
		tap.numberOfTouchesRequired = 1
		
		// add to the view, not the image view
		self.view.addGestureRecognizer(tap)
    }
	
	func tap() {
		print("Did..\n")
		
		self.mapImageView.image = UIImage.init(named: "nyp_static_zoom_in_img")

		let isInRange = true
		
		if isInRange {
			let alertController = UIAlertController.init(title: "Do you want to join the battle?", message: "", preferredStyle: .ActionSheet)
			let yesAction = UIAlertAction.init(title: "Yes", style: .Default, handler: nil)
			let noAction = UIAlertAction.init(title: "No", style: .Default, handler: nil)
			alertController.addAction(yesAction)
			alertController.addAction(noAction)
			self.presentViewController(alertController, animated: true, completion: nil)
		}
		
		// possibly for next view controller
//		let actionViewController = UIViewController()
//		actionViewController.view.frame = CGRectMake(0, self.view.frame.size.height / 2, self.view.frame.size.width, self.view.frame.size.height / 2)
//		let colour = UIColor.init(red: 1.0, green: 0.8, blue: 0.5, alpha: 1.0)
//		actionViewController.view.backgroundColor = colour
//		
//		self.view.addSubview(actionViewController.view)
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
