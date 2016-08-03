//
//  ChatMapViewController.swift
//  GISProject
//
//  Created by XINGYU on 23/7/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import MapKit

class ChatMapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    var location: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var region = MKCoordinateRegion()
        
        region.center.latitude = location.coordinate.latitude
        region.center.longitude = location.coordinate.longitude
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        
        mapView.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        mapView.addAnnotation(annotation)
        annotation.coordinate = location.coordinate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func cancelBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
