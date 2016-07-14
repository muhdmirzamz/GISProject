//
//  JoinBattleViewController.swift
//  GISProject
//
//  Created by Muhd Mirza on 24/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase
import Bluuur

protocol JoinProtocol {
	func reloadMap()
}

class JoinBattleViewController: UIViewController, BattleProtocol {

    @IBOutlet weak var blurView: MLWLiveBlurView!
    
	var selectedAnnotation: Location?
    var imageString: String?
	
	var delegate: JoinProtocol?
	
    @IBOutlet var monsterHealth: UILabel!
    @IBOutlet var monsterImgView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
		
        self.blurView.blurProgress = 0.3
		
		let image = UIImage.init(named: self.imageString!)
		
		UIGraphicsBeginImageContextWithOptions(CGSize.init(width: self.monsterImgView.frame.width, height: self.monsterImgView.frame.height), false, 0.0);
		image!.drawInRect(CGRectMake(0, 0, self.monsterImgView.frame.width, self.monsterImgView.frame.height))
		let newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		self.monsterImgView.image = newImage
		
        self.monsterHealth.text = "1/1"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	@IBAction func dismiss() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func backtoMap() {
		self.delegate?.reloadMap()
	
		self.dismiss()
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "battleSegue" {
			let battleVC = segue.destinationViewController as? BattleViewController
			battleVC!.delegate = self
			battleVC!.selectedAnnotation = self.selectedAnnotation
			battleVC?.imageString = self.imageString
		}
    }

}
