//
//  BattleSummaryViewController.swift
//  GISProject
//
//  Created by Muhd Mirza on 23/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class BattleSummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet var tableView: UITableView!

	var playersArr: NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.playersArr = NSMutableArray()
		self.playersArr = ["Irfan", "Jun Hui", "Xingyu", "Mirza"]
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
    }

	@IBAction func backtoMap() {
		self.navigationController?.popToRootViewControllerAnimated(true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (self.playersArr?.count)!
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
		
		// Configure the cell...
		cell.textLabel?.text = self.playersArr![indexPath.row] as? String
		
		return cell
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
