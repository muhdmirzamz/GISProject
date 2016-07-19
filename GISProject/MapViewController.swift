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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, BattleProtocol {
	
	@IBOutlet var cancelButton: UIBarButtonItem!
	@IBOutlet var mapView: MKMapView!
	
	var locationManager: CLLocationManager?
	
	var userLat: Double?, userLong: Double?
	var region: MKCoordinateRegion?

    var monsterImg: UIImage?
	
	let userID = (FIRAuth.auth()?.currentUser?.uid)!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.locationManager = CLLocationManager()
		self.locationManager?.delegate = self
		self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager?.requestWhenInUseAuthorization()
		
		// you need this for user location
		self.locationManager?.startUpdatingLocation()
		
		self.mapView.showsUserLocation = true
		self.mapView.mapType = .Standard
		self.mapView.zoomEnabled = true
		self.mapView.scrollEnabled = true
		self.mapView.delegate = self
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		print("Hello MAP")
		
		self.reloadData()
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
			let annotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: "pin")
			
			let currAnnotation = annotation as? Location
			let image = UIImage.init(named: (currAnnotation?.imageString)!)
			
			// resize image using a new image graphics context
			UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 40, height: 40), false, 0.0);
			image!.drawInRect(CGRectMake(0, 0, 40, 40))
			let newImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			
			annotationView.image = newImage
			
			return annotationView
		}
		
		return nil
	}
	
	func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
		// you need this for measuring distance between battle locations and you
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
		let battleVC = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("BattleViewController") as? BattleViewController
		battleVC?.selectedAnnotation = selectedAnnotation
		battleVC?.imageString = selectedAnnotation?.imageString
		battleVC?.delegate = self
		
		// this is used so that when the presented view controller comes on, the parent view controller stays visible in the background
		// property set here because it is the root view for this hierarchy
		battleVC?.definesPresentationContext = true
		battleVC?.modalPresentationStyle = .OverCurrentContext
		
		let battle = Battle()
		
		let ref = FIRDatabase.database().reference().child("/Friend")
		ref.child("/\(self.userID)").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
			for i in snapshot.children {
				let key = i.key!!
				let value = snapshot.value!["\(key)"] as? NSNumber
				
				if value?.integerValue == 1 {
					battle.uidArr?.addObject(key)
				}
			}
			
			battle.amountOfCardsAvailable = NSNumber(integer: Int((battle.uidArr?.count)!))
			
            // be sure to check if own card is available too
			if ((UIApplication.sharedApplication().scheduledLocalNotifications?.count)! == 1) && ((battle.amountOfCardsAvailable?.integerValue)! == 0) {
				dispatch_async(dispatch_get_main_queue(), { 
					let alert = UIAlertController.init(title: "Hold up", message: "Sorry you don't have enough cards", preferredStyle: .Alert)
					let okAction = UIAlertAction.init(title: "Ok", style: .Default, handler: nil)
					alert.addAction(okAction)
					self.presentViewController(alert, animated: true, completion: nil)
				})
			} else {
				dispatch_async(dispatch_get_main_queue(), {
					battleVC?.battle = battle
					
					battleVC?.view.backgroundColor = UIColor.clearColor()
					
					self.presentViewController(battleVC!, animated: true, completion: nil)
				})
			}
		})
	}
	
	func reloadMap() {
		self.reloadData()
	}
	
	func reloadData() {
		self.mapView.selectedAnnotations.removeAll()
		self.mapView.removeAnnotations(self.mapView.annotations)
	
		let ref = FIRDatabase.database().reference().child("/Location")
		
		ref.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
			for record in snapshot.children {
				let key = record.key!!
				var coordinate = CLLocationCoordinate2D()
				
				let latitude = record.value!!["latitude"] as! NSNumber
				let longitude = record.value!!["longitude"] as! NSNumber
				
				coordinate.latitude = latitude.doubleValue
				coordinate.longitude = longitude.doubleValue
				
				let imageString = record.value!!["image string"] as! String
				
				let locationModel = Location.init(key: key, coordinate: coordinate, imageString: imageString)
				
				self.mapView.addAnnotation(locationModel)
			}
		})
		
		// center view within region
		var span = MKCoordinateSpan()
		span.latitudeDelta = 0.004
		span.longitudeDelta = 0.004
		
        // coordinate limits
		// 1.382414, 103.848156 - top left
		// 1.377431, 103.850278 - bottom right
		
		var location = CLLocationCoordinate2D()
		location.latitude = (1.377431 + 1.382414) / 2
		location.longitude = (103.848156 + 103.850278) / 2
		
		self.region = MKCoordinateRegion()
		self.region!.center = location
		self.region!.span = span
		
		self.mapView.setRegion(self.region!, animated: true)
		self.mapView.setCenterCoordinate((self.region?.center)!, animated: true)
        
        // displays map in an angle
        var eyeCoord = CLLocationCoordinate2D()
        eyeCoord.latitude = ((1.377431 + 1.382414) / 2) - 0.0099
        eyeCoord.longitude = ((103.848156 + 103.850278) / 2)
        
        let camera = MKMapCamera.init(lookingAtCenterCoordinate: location, fromEyeCoordinate: eyeCoord, eyeAltitude: 20)
        self.mapView.setCamera(camera, animated: true)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
