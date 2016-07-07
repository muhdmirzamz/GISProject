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
        
       // view.backgroundColor = ThemeManager.currentTheme().backgroundColor
      //  tableView.separatorColor = ThemeManager.currentTheme().secondaryColor
        
       
        
        //custom images and title for tab bar
        var tabBarController: UITabBarController = self
        
        var tabBarItem0 = tabBarController.tabBar.items![0] as UITabBarItem
        var tabBarItem1 = tabBarController.tabBar.items![1] as UITabBarItem
        var tabBarItem2 = tabBarController.tabBar.items![2] as UITabBarItem
        var tabBarItem3 = tabBarController.tabBar.items![3] as UITabBarItem
        
        var tabBar: UITabBar = tabBarController.tabBar
        
     
        
        //set title for individual tabs
        tabBarItem0.title = "QR"
        tabBarItem1.title = "Map"
        tabBarItem2.title = "Profile"
        tabBarItem3.title = "Friends"
      
        // select and unselect images
        tabBarItem0.image = UIImage(named: "qrIcon")?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem1.image = UIImage(named: "mapIcon")?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem2.image = UIImage(named: "MeIcon")?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem3.image = UIImage(named: "friendIcon")?.imageWithRenderingMode(.AlwaysOriginal)
        
        
       
        tabBarItem0.selectedImage = UIImage(named: "qrIcon")?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem1.selectedImage = UIImage(named: "mapIcon")?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem2.selectedImage = UIImage(named: "MeIcon")?.imageWithRenderingMode(.AlwaysOriginal)
    }

}
