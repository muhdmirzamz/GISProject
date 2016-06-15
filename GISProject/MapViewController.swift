//
//  BattleScreenViewController.swift
//  GISProject
//
//  Created by Muhd Mirza on 12/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

class MapViewController: UIViewController, LocationsProtocol, MKMapViewDelegate {
	
	@IBOutlet var cancelButton: UIBarButtonItem!
	@IBOutlet var map: MKMapView!
	
	var locationManager: CLLocationManager?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.locationManager = CLLocationManager()
		self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager?.requestWhenInUseAuthorization()
		self.locationManager?.startUpdatingLocation()
		
		self.map.showsUserLocation = true
		self.map.mapType = .Standard
		self.map.zoomEnabled = true
		self.map.scrollEnabled = true
		self.map.delegate = self
		
//		let location = Location()
//		location.delegate = self
//		location.downloadItems()
		
		let ref = FIRDatabase.database().reference().child("/Location")
		
		ref.observeEventType(.Value, withBlock: {(snapshot) in
			for record in snapshot.children {
				let latitude = record.value!["latitude"] as! NSNumber
				let longitude = record.value!["longitude"] as! NSNumber
				
				print("ello")
				print(latitude.doubleValue)
				print(longitude.doubleValue)
			
				let location = LocationModel.init(latitude: latitude.doubleValue, longitude: longitude.doubleValue, title: "Test", subtitle: "This is a test")
				self.map.addAnnotation(location)
			}
		})
		
		var span = MKCoordinateSpan()
		span.latitudeDelta = 0.02
		span.longitudeDelta = 0.02
		
		var locationTest = CLLocationCoordinate2D()
		locationTest.latitude = (1.376527 + 1.383884) / 2
		locationTest.longitude = (103.843563 + 103.850891) / 2
		
		var region = MKCoordinateRegion()
		region.center = locationTest
		region.span = span
		
		self.map.setRegion(region, animated: true)
	}
	
	func itemsDownloaded(items: NSArray) {
		for i in 0 ..< items.count {
			let locationModel = items[i] as? LocationModel
			self.map.addAnnotation(locationModel!)
		}
		
		var span = MKCoordinateSpan()
		span.latitudeDelta = 0.02
		span.longitudeDelta = 0.02
		
		var locationTest = CLLocationCoordinate2D()
		locationTest.latitude = (1.376527 + 1.383884) / 2
		locationTest.longitude = (103.843563 + 103.850891) / 2
		
		var region = MKCoordinateRegion()
		region.center = locationTest
		region.span = span
		
		self.map.setRegion(region, animated: true)
	}
	
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is LocationModel {
			var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
			
			if annotationView == nil {
				annotationView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "pin")
				annotationView?.canShowCallout = true
				annotationView?.pinTintColor = UIColor.redColor()
				
				let button = UIButton.init(type: .DetailDisclosure)
				annotationView?.rightCalloutAccessoryView = button
			} else {
				annotationView?.annotation = annotation
			}
			
			return annotationView
		}
		
		return nil
	}
	
	func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		let joinBattleVC = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("JoinBattleViewController")
		self.presentViewController(joinBattleVC, animated: true, completion: nil)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

}
