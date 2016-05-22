//
//  SearchLocationTableViewController.swift
//  GISProject
//
//  Created by Muhd Mirza on 14/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

protocol searchLocation {
	func changeToNavigationImage()
	func changeToCurrentLocationImage()
}

class SearchLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet var goButton: UIBarButtonItem!
	@IBOutlet var mapImageView: UIImageView!
	@IBOutlet var tableView: UITableView!
	
	var delegate: searchLocation!

	var availableBattle: NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
		self.mapImageView.image = UIImage.init(named: "you are here")
		
		// possible retrieve from server
		// but hardcode for now
		self.availableBattle = NSMutableArray()
		self.availableBattle = ["Nanyang Polytechnic"]
    }
	
	@IBAction func close() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func goToNavigation() {
		self.dismissViewControllerAnimated(true, completion: nil)
		
		self.delegate.changeToNavigationImage()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.availableBattle?.count)!
    }

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell...
		cell.textLabel?.text = self.availableBattle![indexPath.row] as? String

        return cell
    }
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let cell = tableView.cellForRowAtIndexPath(indexPath)
		
		cell?.accessoryType = .Checkmark
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		self.mapImageView.image = UIImage.init(named: "nearby battles")
	}
}
