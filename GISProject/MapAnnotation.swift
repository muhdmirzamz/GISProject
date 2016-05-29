//
//  MapAnnotation.swift
//  GISProject
//
//  Created by Muhd Mirza on 29/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
	var coordinate: CLLocationCoordinate2D
	var title: String?
	var subtitle: String?
	
	init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
		self.coordinate = coordinate
		self.title = title
		self.subtitle = subtitle
		
		super.init()
	}
}
