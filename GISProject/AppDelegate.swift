
//
//  AppDelegate.swift
//  GISProject
//
//  Created by Muhd Mirza on 11/5/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

	var window: UIWindow?
     
    
    //setup plist to get location working
    //NSLocationWhenInUseUsageDescription
    var locationManager: CLLocationManager?
    var coordinate: CLLocationCoordinate2D?
    var timer : NSTimer?
    var count = 0
    var seconds = 0
   
    
    //MARK:  LocationManger fuctions
    
    func locationManagerStart() {
        
        if locationManager == nil {
            print("init locationManager")
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
           // locationManager!.allowsBackgroundLocationUpdates = true
        }
        
        print("have location manager")
        locationManager!.startUpdatingLocation()
        
    }
    
    func locationManagerStop() {
        locationManager!.stopUpdatingLocation()
    }
    
    
    //MARK: CLLocationManager Delegate
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        coordinate = newLocation.coordinate
        
       //print(coordinate!.longitude)
        //print(coordinate!.latitude)
        
        locationManagerStop()
        
        //update firebase location 
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       let setCoordinateViewController = storyboard.instantiateViewControllerWithIdentifier("qrViewController") as! QRViewController
        
            setCoordinateViewController.lat = coordinate!.latitude
            setCoordinateViewController.log = coordinate!.longitude
            setCoordinateViewController.updateLocation()
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error: \(error)")
        
      
    }
    
    func locationManagerDidPauseLocationUpdates(manager: CLLocationManager) {
        print("pause location update")
    }
    
    func locationManagerDidResumeLocationUpdates(manager: CLLocationManager) {
        print("resume location update")
    }
    
    func setupLocationTimer(){
        count = 0
        seconds = 180
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
                                                       target: self,
                                                       selector: "updateLocationInterval", userInfo: nil,
                                                       repeats: true)
    }
    
    func stopTimer(){
          timer?.invalidate()
    }
    
    func updateLocationInterval(){
        
        seconds--
        //print(seconds)
        if (seconds == 0) {
            // Optional chaining – don’t call 
            // invalidate if timer is null.
            
            timer?.invalidate()
            locationManagerStart()
             setupLocationTimer()
        }
        
    }
    //
    func application(application: UIApplication,
                     didReceiveLocalNotification notification:
        UILocalNotification) {
        let state = application.applicationState
        // We will want to show an alert only when the
        // application is still running as a foreground
        // app when the notification is received.
        //
        if(state == UIApplicationState.Active)
        {
            
            
            let alert = UIAlertController(
            title: "Reminder",
            message: notification.alertBody,
            preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK",
                style: .Default, handler: nil))
            
            // Gets the topmost visible view controller
            //
            var topViewController = self.window!.rootViewController!
            while (topViewController.presentedViewController != nil) {
                topViewController =
                    topViewController.presentedViewController!;
            }
            
            // Present the alert on top of the topmost
            // visible controller
            topViewController.presentViewController(alert,
                                                    animated: true, completion: nil) }
        
        // Request to reload table view data
        NSNotificationCenter.defaultCenter()
            .postNotificationName("reloadData", object: self)
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
        
        
    }
    
    
    
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		FIRApp.configure()
        
        FIRDatabase.database().persistenceEnabled = true //change
        // set up local notification
        
        if (UIApplication.instancesRespondToSelector(
                "registerUserNotificationSettings:"))
        {
            let notificationSettings =
                UIUserNotificationSettings( forTypes: [.Alert, .Badge, .Sound], categories: nil)
            UIApplication.sharedApplication()
                .registerUserNotificationSettings(notificationSettings)
        }
        application.applicationIconBadgeNumber = 0
        
        
        return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
         locationManagerStart()
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        locationManagerStop()
	}

    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.razeware.HitList" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("User", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

