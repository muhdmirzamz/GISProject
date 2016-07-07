//
//  JoinBattleViewController.swift
//  GISProject
//
//  Created by Muhd Mirza on 24/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class JoinBattleViewController: UIViewController, BattleProtocol {

	var selectedAnnotation: LocationModel?
    
    @IBOutlet var monsterHealth: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "mob_bg")?.drawInRect(self.view.bounds)
        
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
        
        
        
        
        self.monsterHealth.text = "1/1"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func dismiss() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func backtoMap() {
		self.dismiss()
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "battleSegue" {
			let battleVC = segue.destinationViewController as? BattleViewController
			battleVC?.delegate = self
			battleVC?.selectedAnnotation = self.selectedAnnotation
		}
    }

}
