//
//  LocationModel.swift
//  GISProject
//
//  Created by Muhd Mirza on 1/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import MapKit

class Location: NSObject, MKAnnotation {
	var key: String?
	var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var imageString: String?
	
    init(key: String?, coordinate: CLLocationCoordinate2D, imageString: String?) {
		self.key = key
		self.coordinate = coordinate
        self.imageString = imageString
		
		super.init()
	}
}
