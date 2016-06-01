//
//  LocationModel.swift
//  GISProject
//
//  Created by Muhd Mirza on 1/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import MapKit

class LocationModel: NSObject, MKAnnotation {
	var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
//	var title: String?
//	var subtitle: String?
	
	init(latitude: Double, longitude: Double) {
		self.coordinate.latitude = latitude
		self.coordinate.longitude = longitude
		
		super.init()
	}
}
