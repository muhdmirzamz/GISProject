//
//  MapAnnotation.swift
//  GISProject
//
//  Created by Muhd Mirza on 29/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import MapKit

protocol LocationsProtocol: class {
	func itemsDownloaded(items: NSArray)
}

class Location: NSObject, NSURLSessionDataDelegate {
	let urlPath: String = "http://loba.duckdns.org/retrieve_locations.php"
	var locationData: NSMutableData = NSMutableData()
	
	var delegate: LocationsProtocol!
	
	func downloadItems() {
		
		let url: NSURL = NSURL(string: urlPath)!
		var session: NSURLSession!
		let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
		
		
		session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
		
		let task = session.dataTaskWithURL(url)
		
		task.resume()
		
	}
	
	func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
		self.locationData.appendData(data);
	}
	
	func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
		if error != nil {
			print("Failed to download data")
		}else {
			print("Data downloaded")
			self.parseJSON()
		}
	}
	
	func parseJSON() {
		
		var jsonResult: NSMutableArray = NSMutableArray()
		
		do{
			jsonResult = try NSJSONSerialization.JSONObjectWithData(self.locationData, options:.AllowFragments) as! NSMutableArray
		} catch let error as NSError {
			print(error)
		}
		
		var jsonElement: NSDictionary = NSDictionary()
		let locations: NSMutableArray = NSMutableArray()
		
		for i in 0 ..< jsonResult.count
		{
			jsonElement = jsonResult[i] as! NSDictionary
			
			//the following insures none of the JsonElement values are nil through optional binding
			if let latitude = jsonElement["latitude"] as? String,
			   let longitude = jsonElement["longitude"] as? String {
				print("Latitude \(Double(latitude)!)")
				print("Latitude \(Double(longitude)!)")

				let location = LocationModel.init(latitude: Double(latitude)!, longitude: Double(longitude)!, title: "Test", subtitle: "This is a test")
				locations.addObject(location)
			}
		}
		
		print(locations.count)
		
		dispatch_async(dispatch_get_main_queue(), { () -> Void in
			
			self.delegate.itemsDownloaded(locations)
			
		})
	}
}
