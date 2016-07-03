//
//  CustomTabBarController.swift
//  GISProject
//
//  Created by XINGYU on 3/7/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //custom images and title for tab bar
        var tabBarController: UITabBarController = self
        var tabBarItem3 = tabBarController.tabBar.items![3] as UITabBarItem
        var tabBar: UITabBar = tabBarController.tabBar
        
        //set title for individual tabs
        tabBarItem3.title = "Friends"
        
        // select and unselect images
        tabBarItem3.image = UIImage(named: "friendIcon")?.imageWithRenderingMode(.AlwaysTemplate)
        tabBarItem3.selectedImage = UIImage(named: "friendIcon")?.imageWithRenderingMode(.AlwaysOriginal)
    }

}
