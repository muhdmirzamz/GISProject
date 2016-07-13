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

    var monsterImg: UIImage?
    
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
                
                let random = Int(arc4random()) % 5
                print(random)
                
                if random == 0 {
                    self.monsterImg = UIImage.init(named: "electric_monster")
                } else if random == 1 {
                    self.monsterImg = UIImage.init(named: "fire_monster")
                } else if random == 2 {
                    self.monsterImg = UIImage.init(named: "ghost_monster")
                } else if random == 3 {
                    self.monsterImg = UIImage.init(named: "grass_monster")
                } else if random == 4 {
                    self.monsterImg = UIImage.init(named: "water_monster")
                }
				
				let locationModel = Location.init(key: key, coordinate: coordinate, title: "Test", subtitle: "This is a test", image: self.monsterImg)
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
	
		if annotation is Location {
			var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
			
			if annotationView == nil {
				annotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: "pin")
				annotationView?.canShowCallout = true

            
				// resize image using a new image graphics context
				UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 30, height: 30), false, 0.0);
				self.monsterImg?.drawInRect(CGRectMake(0, 0, 30, 30))
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
//        // you need this for measuring distance between battle locations and you
//        let boundaryLocation = CLLocation.init(latitude: (self.region?.center.latitude)!, longitude: (self.region?.center.longitude)!)
//        let userLocation = CLLocation.init(latitude: self.userLat!, longitude: self.userLong!)
//        let distance = userLocation.distanceFromLocation(boundaryLocation)
//        
//        // follows meters
//        if distance > 50 {
//            let alert = UIAlertController.init(title: "Hold on", message: "You're too far", preferredStyle: .Alert)
//            let okAction = UIAlertAction.init(title: "Ok", style: .Default, handler: nil)
//            alert.addAction(okAction)
//            self.presentViewController(alert, animated: true, completion: nil)
//        } else {
//            let joinBattleVC = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("JoinBattleViewController")
//            self.presentViewController(joinBattleVC, animated: true, completion: nil)
//        }
        
		let selectedAnnotation = mapView.selectedAnnotations.first as? Location
		let joinBattleVC = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("JoinBattleViewController") as? JoinBattleViewController
		joinBattleVC?.selectedAnnotation = selectedAnnotation
        joinBattleVC?.monsterImg = self.monsterImg
		let navController = UINavigationController.init(rootViewController: joinBattleVC!)
		navController.navigationBarHidden = true
		self.presentViewController(navController, animated: true, completion: nil)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
