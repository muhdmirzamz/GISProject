//
//  JoinBattleViewController.swift
//  GISProject
//
//  Created by Muhd Mirza on 24/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase

protocol JoinProtocol {
    func reload()
}

class JoinBattleViewController: UIViewController, BattleProtocol {

	var selectedAnnotation: Location?
    var imageString: String?
    var delegate: JoinProtocol?
    
    @IBOutlet var monsterHealth: UILabel!
    @IBOutlet var monsterImgView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.monsterImgView.image = UIImage.init(named: self.imageString!)
		
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
        self.delegate?.reload()
		self.dismiss()
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "battleSegue" {
			let battleVC = segue.destinationViewController as? BattleViewController
			battleVC!.delegate = self
			battleVC!.selectedAnnotation = self.selectedAnnotation
		}
    }

}
