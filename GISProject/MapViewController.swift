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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
	
	@IBOutlet var cancelButton: UIBarButtonItem!
	@IBOutlet var map: MKMapView!
	
	var locationManager: CLLocationManager?
	
	var userLat: Double?, userLong: Double?
	var region: MKCoordinateRegion?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.locationManager = CLLocationManager()
		self.locationManager?.delegate = self
		self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager?.requestWhenInUseAuthorization()
		
		// you need this for user location
		//self.locationManager?.startUpdatingLocation()
		
		self.map.showsUserLocation = true
		self.map.mapType = .Standard
		self.map.zoomEnabled = true
		self.map.scrollEnabled = true
		self.map.delegate = self
	}
	
	override func viewWillAppear(animated: Bool) {
		if self.map.annotations.count > 0 {
			self.map.removeAnnotations(self.map.annotations)
		}
	
		let ref = FIRDatabase.database().reference().child("/Location")
		
		ref.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
			for record in snapshot.children {
				let key = record.key!!
				var coordinate = CLLocationCoordinate2D()
				
				let latitude = record.value!!["latitude"] as! NSNumber
				let longitude = record.value!!["longitude"] as! NSNumber
				
				coordinate.latitude = latitude.doubleValue
				coordinate.longitude = longitude.doubleValue
				
				let locationModel = LocationModel.init(key: key, coordinate: coordinate, title: "Test", subtitle: "This is a test")
				self.map.addAnnotation(locationModel)
			}
		})
		
		// center view within region
		var span = MKCoordinateSpan()
		span.latitudeDelta = 0.02
		span.longitudeDelta = 0.02
		
		var locationTest = CLLocationCoordinate2D()
		locationTest.latitude = (1.376527 + 1.383884) / 2
		locationTest.longitude = (103.843563 + 103.850891) / 2
		
		self.region = MKCoordinateRegion()
		self.region!.center = locationTest
		self.region!.span = span
		
		self.map.setRegion(self.region!, animated: true)
		self.map.setCenterCoordinate((self.region?.center)!, animated: true)
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let userLocation = locations.last!
		
		self.userLat = userLocation.coordinate.latitude
		self.userLong = userLocation.coordinate.longitude
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("Could not find location: \(error)");
	}
	
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation.isKindOfClass(MKUserLocation) {
			return nil
		}
	
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
		// you need this for measuring distance between battle locations and you
		//let userLocation = CLLocation.init(latitude: self.userLat!, longitude: self.userLong!)
		//let boundaryLocation = CLLocation.init(latitude: (self.region?.center.latitude)!, longitude: (self.region?.center.longitude)!)
		//let distance = userLocation.distanceFromLocation(boundaryLocation)

		// follows meters
//		if distance > 50 {
//			let alert = UIAlertController.init(title: "Hold on", message: "You're too far", preferredStyle: .Alert)
//			let okAction = UIAlertAction.init(title: "Ok", style: .Default, handler: nil)
//			alert.addAction(okAction)
//			self.presentViewController(alert, animated: true, completion: nil)
//		} else {
//			let joinBattleVC = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("JoinBattleViewController")
//			self.presentViewController(joinBattleVC, animated: true, completion: nil)
//		}
		
		let selectedAnnotation = mapView.selectedAnnotations.first as? LocationModel

		let joinBattleVC = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("JoinBattleViewController") as? JoinBattleViewController
		joinBattleVC?.selectedAnnotation = selectedAnnotation
		let navController = UINavigationController.init(rootViewController: joinBattleVC!)
		navController.navigationBarHidden = true
		self.presentViewController(navController, animated: true, completion: nil)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

}
