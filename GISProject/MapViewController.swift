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
		span.latitudeDelta = 0.01
		span.longitudeDelta = 0.01
		
		// 1.382414, 103.848156 - top left
		// 1.377431, 103.850278 - bottom right
		
		var locationTest = CLLocationCoordinate2D()
		locationTest.latitude = (1.377431 + 1.382414) / 2
		locationTest.longitude = (103.848156 + 103.850278) / 2
		
		self.region = MKCoordinateRegion()
		self.region!.center = locationTest
		self.region!.span = span
		
		self.map.setRegion(self.region!, animated: true)
		self.map.setCenterCoordinate((self.region?.center)!, animated: true)
		
//		for i in 0 ..< 10 {
//			var random = Double(arc4random()) % 0.004983
//			let latitudeRange = 1.377431 + random
//			random = Double(arc4random()) % 0.002122
//			let longitudeRange = 103.848156 + random
//			
//			print("\(latitudeRange) , \(longitudeRange)")
//		}
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
			var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
			
			if annotationView == nil {
				annotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: "pin")
				annotationView?.canShowCallout = true

				let image = UIImage.init(named: "monster")

				// resize image using a new image graphics context
				UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 30, height: 30), false, 0.0);
				image?.drawInRect(CGRectMake(0, 0, 30, 30))
				let newImage = UIGraphicsGetImageFromCurrentImageContext();
				UIGraphicsEndImageContext();
			
				annotationView?.image = newImage
			} else {
				annotationView?.annotation = annotation
			}
			
			return annotationView
		}
		
		return nil
	}
	
	func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
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
