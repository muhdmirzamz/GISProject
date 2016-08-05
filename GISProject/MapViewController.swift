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
import CoreData
import Bluuur

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, BattleProtocol {
	
	@IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet weak var blurView: MLWLiveBlurView!
	@IBOutlet var mapView: MKMapView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var cardFriends: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageOwnCard: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var damageLabel: UILabel!
	
	var locationManager: CLLocationManager?
	
	var userLat: Double?, userLong: Double?
	var region: MKCoordinateRegion?

    var monsterImg: UIImage?
	
	let userID = (FIRAuth.auth()?.currentUser?.uid)!
	var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var ref: FIRDatabaseReference!
	
	// for debugging purposes
	@IBOutlet weak var distanceButton: UIButton!
	var distanceLimit: Double?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.locationManager = CLLocationManager()
		self.locationManager?.delegate = self
		self.locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
		self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.distanceFilter = 50
		
		// you need this for user location
		self.locationManager?.startUpdatingLocation()
		
		self.mapView.showsUserLocation = true
		self.mapView.mapType = .Standard
		self.mapView.zoomEnabled = true
		self.mapView.scrollEnabled = true
		self.mapView.delegate = self
		
		// for debugging purposes
		self.distanceLimit = 1000
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
        blurView.blurProgress = 0.5
		
		print("Hello MAP")
		
		self.reloadMap()
        
        let battle = Battle()
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        let ref2 = FIRDatabase.database().reference().child("/Account/\(uid)")
        let ref3 = FIRDatabase.database().reference().child("/Friend/\(uid)")
        
        ref3.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            for i in snapshot.children {
                let key = i.key!!
                let value = snapshot.value!["\(key)"] as? NSNumber
                if value?.integerValue == 1 {
                    battle.uidArr?.addObject(key)
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.cardFriends.text = "\((battle.uidArr?.count)!)"
            })
        })
        
        ref2.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            
            let level = snapshot.value!["Level"] as! NSNumber
            let monstersKilled = snapshot.value!["Monsters killed"] as! NSNumber
            let damage = snapshot.value!["Base Damage"] as! NSNumber
            let name = snapshot.value!["Name"] as! String
            let pict = snapshot.value!["Picture"] as! NSNumber
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.nameLabel.text = name
                self.levelLabel.text = String(level.intValue)
                self.damageLabel.text = String(damage.intValue)
                
                switch pict.intValue {
                case 0 :
                    self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                    self.imageProfile.layer.borderWidth = 2.0
                    self.imageProfile.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).CGColor
                    self.imageProfile.image = UIImage(named: "ProfileBlack")
                case 1 :
                    self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                    self.imageProfile.layer.borderWidth = 2.0
                    self.imageProfile.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).CGColor
                    self.imageProfile.image = UIImage(named: "ProfileBlue")
                case 2 :
                    self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                    self.imageProfile.layer.borderWidth = 2.0
                    self.imageProfile.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).CGColor
                    self.imageProfile.image = UIImage(named: "ProfileGreen")
                case 3 :
                    self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                    self.imageProfile.layer.borderWidth = 2.0
                    self.imageProfile.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).CGColor
                    self.imageProfile.image = UIImage(named: "ProfileOrange")
                case 4 :
                    self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                    self.imageProfile.layer.borderWidth = 2.0
                    self.imageProfile.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).CGColor
                    self.imageProfile.image = UIImage(named: "ProfilePurple")
                case 5 :
                    self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                    self.imageProfile.layer.borderWidth = 2.0
                    self.imageProfile.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).CGColor
                    self.imageProfile.image = UIImage(named: "ProfileRed")
                case 6 :
                    self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                    self.imageProfile.layer.borderWidth = 2.0
                    self.imageProfile.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).CGColor
                    self.imageProfile.image = UIImage(named: "ProfileSponge")
                default:
                    self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                    self.imageProfile.layer.borderWidth = 2.0
                    self.imageProfile.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).CGColor
                    self.imageProfile.image = UIImage(named: "ProfileBlack")
                }
                
            })
            
        })
        view.bringSubviewToFront(imageProfile)
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("LOCATION UPDATE")
        
		let userLocation = locations.last!
		
		self.userLat = userLocation.coordinate.latitude
		self.userLong = userLocation.coordinate.longitude
		
		self.reloadMap()
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
        print("Selected")
        
		// checks if user has enabled gps
		if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
			// user location must have a value
			if self.userLat != nil && self.userLong != nil {
				let selectedAnnotation = mapView.selectedAnnotations.first as? Location
				
				//you need this for measuring distance between battle locations and you
				let boundaryLocation = CLLocation.init(latitude: (selectedAnnotation?.coordinate.latitude)!, longitude: (selectedAnnotation?.coordinate.longitude)!)
				let userLocation = CLLocation.init(latitude: self.userLat!, longitude: self.userLong!)
				let distance = userLocation.distanceFromLocation(boundaryLocation)
				
				// follows meters
				// for debugging purposes
				if distance > self.distanceLimit! {
					let alert = UIAlertController.init(title: "Hold on", message: "You have to be at least 50m in range. You are \(Int(distance))m away!", preferredStyle: .Alert)
					let okAction = UIAlertAction.init(title: "Ok", style: .Default, handler: nil)
					alert.addAction(okAction)
					self.presentViewController(alert, animated: true, completion: nil)
				} else {
					// setting up the next view controller
					let battleVC = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("BattleViewController") as? BattleViewController
					battleVC?.selectedAnnotation = selectedAnnotation
					battleVC?.imageString = selectedAnnotation?.imageString
					battleVC?.delegate = self
					
					// this is used so that when the presented view controller comes on, the parent view controller stays visible in the background
					// property set here because it is the root view for this hierarchy
					battleVC?.definesPresentationContext = true
					battleVC?.modalPresentationStyle = .OverCurrentContext
					
					// check for uid entry in Date entity of core data
					// this checks if user has used their own card
					var userCanUseCard = true
					
					let entity = NSEntityDescription.entityForName("Date", inManagedObjectContext: self.appDelegate.managedObjectContext)
					let sortDescriptor = NSSortDescriptor.init(key: "uid", ascending: true)
					let fetchReq = NSFetchRequest()
					fetchReq.entity = entity
					fetchReq.sortDescriptors = [sortDescriptor]
					
					let fetchResController = NSFetchedResultsController.init(fetchRequest: fetchReq, managedObjectContext: self.appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
					
					do {
						try fetchResController.performFetch()
						
						for i in fetchResController.fetchedObjects! {
							let object = i as? NSManagedObject
							
							if (FIRAuth.auth()?.currentUser?.uid)! == (object?.valueForKey("uid"))! as! String {
								let storedDate = object?.valueForKey("date") as? NSDate
								
								print(storedDate?.timeIntervalSinceNow)
								
								let dateFormatter = NSDateFormatter()
								dateFormatter.dateFormat = "HH:mm dd-MM-yyyy"
								print("Stored date: \(dateFormatter.stringFromDate(storedDate!))")
								
								// if the date has past, delete the object
								// if stored date has passed, the time interval between now and the stored date should be a negative
								if storedDate?.timeIntervalSinceNow < 0 {
									self.appDelegate.managedObjectContext.deleteObject(object!)
									
									do {
										try self.appDelegate.managedObjectContext.save()
									} catch {
										print("Unable to delete object")
									}
									
									userCanUseCard = true
									
									break
								} else {
									userCanUseCard = false
								}
							}
						}
					} catch {
						print("Unable to fetch")
					}
					
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
						
						print(userCanUseCard)
						
						// be sure to check if own card is available too
						if (userCanUseCard == false && (battle.amountOfCardsAvailable?.integerValue)! == 0) {
							dispatch_async(dispatch_get_main_queue(), {
								let alert = UIAlertController.init(title: "Hold up", message: "Sorry you don't have enough cards", preferredStyle: .Alert)
								let okAction = UIAlertAction.init(title: "Ok", style: .Default, handler: nil)
								alert.addAction(okAction)
								self.presentViewController(alert, animated: true, completion: nil)
							})
						} else {
							dispatch_async(dispatch_get_main_queue(), {
								battleVC?.battle = battle
								
								// make this a clear background
								battleVC?.view.backgroundColor = UIColor.clearColor()
								
								self.presentViewController(battleVC!, animated: true, completion: nil)
							})
						}
					})
				}
			} else {
				let alert = UIAlertController.init(title: "Hold up", message: "Please wait for your location to stabilise in a few seconds", preferredStyle: .Alert)
				let okAction = UIAlertAction.init(title: "Ok", style: .Default, handler: nil)
				alert.addAction(okAction)
				self.presentViewController(alert, animated: true, completion: nil)
			}
		} else {
			let alert = UIAlertController.init(title: "Hold up", message: "Sorry, location services is not enabled. Do you want to enable it?", preferredStyle: .Alert)
			let noAction = UIAlertAction.init(title: "No", style: .Default, handler: nil)
			let yesAction = UIAlertAction.init(title: "Yes", style: .Default, handler: { (action) in
				UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
			})
			alert.addAction(noAction)
			alert.addAction(yesAction)
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	func reloadMap() {
		self.mapView.selectedAnnotations.removeAll()
		self.mapView.removeAnnotations(self.mapView.annotations)
	
		let ref = FIRDatabase.database().reference().child("/Location")
		
		// make sure user location is not nil
		if self.userLat != nil && self.userLong != nil {
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
                    
					// compare distance on reload so you only download necessary models
					let boundaryLocation = CLLocation.init(latitude: locationModel.coordinate.latitude, longitude: locationModel.coordinate.longitude)
					let userLocation = CLLocation.init(latitude: self.userLat!, longitude: self.userLong!)
					let distance = userLocation.distanceFromLocation(boundaryLocation)
					
					if distance < self.distanceLimit! {
						self.mapView.addAnnotation(locationModel)
					}
				}
			})
		}
		
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
        
        let camera = MKMapCamera.init(lookingAtCenterCoordinate: location, fromEyeCoordinate: eyeCoord, eyeAltitude: 1000)
        self.mapView.setCamera(camera, animated: true)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
