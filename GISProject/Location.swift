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
	var title: String?
	var subtitle: String?
    var imageString: String?
	
    init(key: String?, coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, imageString: String?) {
		self.key = key
		self.coordinate = coordinate
		
		self.title = title
		self.subtitle = subtitle
        
        self.imageString = imageString
		
		super.init()
	}
}
