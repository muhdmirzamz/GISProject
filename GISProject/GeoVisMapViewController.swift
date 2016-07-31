//
//  GeoVisMapViewController.swift
//  GISProject
//
//  Created by Jun Hui Foong on 19/7/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import PageMenu

class GeoVisMapViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    var controllerArray : [UIViewController] = []

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize view controllers to display and place in array
        let controller1 : HeatMapViewController = HeatMapViewController(nibName: "HeatMapViewController", bundle: nil)
        controller1.title = "HeatMap"
        controllerArray.append(controller1)

        let controller2 : LayerMapViewController = LayerMapViewController(nibName: "LayerMapViewController", bundle: nil)
        controller2.title = "Layers"
        controllerArray.append(controller2)
        
        let controller3 : WeatherMapViewController = WeatherMapViewController(nibName: "WeatherMapViewController", bundle: nil)
        controller3.title = "WeatherMap"
        controllerArray.append(controller3)
        
        let controller4 : FriendsMapViewController = FriendsMapViewController(nibName: "FriendsMapViewController", bundle: nil)
        controller4.title = "FriendsMap"
        controllerArray.append(controller4)

        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0)),
            .ViewBackgroundColor(UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0)),
            .SelectionIndicatorColor(UIColor(red: 28/255, green: 211/255, blue: 235/255, alpha: 1)),
            .BottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 15.0)!),
            .MenuHeight(50.0),
            .MenuItemWidth(100.0),
            .CenterMenuItems(true)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 20.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        pageMenu!.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
