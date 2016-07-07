//
//  Theme.swift
//  Pet Finder
//
//  Created by Essan Parto on 5/16/15.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

enum Theme: Int {
    case Default, Dark, Graphical
    
    var mainColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 187.0/255.0, green: 188.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .Graphical:
            return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .Default, .Graphical:
            return .Default
        case .Dark:
            return .Black
        }
    }
    
    var navigationBackgroundImage: UIImage? {
        return self == .Graphical ? UIImage(named: "navBackground_p")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 10, 0, 10), resizingMode: UIImageResizingMode.Stretch) : nil
    }
    
    var tabBarBackgroundImage: UIImage? {
        //return self == .Graphical ? UIImage(named: "tabBarBackground_p") : nil
        return self == .Graphical ? UIImage(named: "tabBarBackground_p")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 6, 0, 6), resizingMode: UIImageResizingMode.Tile) : nil


    }
    
    var backgroundColor: UIColor {
        switch self {
        case .Default, .Graphical:
            return UIColor(white: 0.9, alpha: 1.0)
        case .Dark:
            return UIColor(white: 0.8, alpha: 1.0)
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 242/255.0, green: 235/255.0, blue: 48.0/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red: 34.0/255.0, green: 128.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        case .Graphical:
            return UIColor(red: 242/255.0, green: 235/255.0, blue: 48.0/255.0, alpha: 1.0)
        }
    }
   
    //end of Theme
    
}

let SelectedThemeKey = "SelectedTheme"

struct ThemeManager {
    
    
    static func currentTheme() -> Theme {
        if let storedTheme = NSUserDefaults.standardUserDefaults().valueForKey(SelectedThemeKey)?.integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .Default
        }
    }
    
    static func applyTheme(theme: Theme) {
        // 1
        NSUserDefaults.standardUserDefaults().setValue(theme.rawValue, forKey: SelectedThemeKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // 2
        let sharedApplication = UIApplication.sharedApplication()
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        
        //apply theme to nav
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().barTintColor = UIColor.clearColor()
       
        UINavigationBar.appearance().shadowImage = UIImage()
       //let navBgImage:UIImage = UIImage(named: "navBackground")!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 10, 0, 40), resizingMode: UIImageResizingMode.Stretch)
        
       UINavigationBar.appearance().setBackgroundImage(theme.navigationBackgroundImage, forBarMetrics: .Default)
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
        
        //tab bar theme
  
        UITabBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().backgroundImage = theme.tabBarBackgroundImage
       // UITabBar.appearance().backgroundColor = UIColor.clearColor()
        
        //transparent uibar
        //UITabBar.appearance().barTintColor = UIColor.clearColor()
       // UITabBar.appearance().backgroundImage = UIImage()
       // UITabBar.appearance().shadowImage = UIImage()
        
        //let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.imageWithRenderingMode(.AlwaysTemplate)
       // let tabResizableIndicator = tabIndicator?.resizableImageWithCapInsets(UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
       // UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
        
        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.imageWithRenderingMode(.AlwaysOriginal)
        let tabResizableIndicator = tabIndicator?.resizableImageWithCapInsets(UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
        
        let controlBackground = UIImage(named: "controlBackground")?
            .imageWithRenderingMode(.AlwaysTemplate)
            .resizableImageWithCapInsets(UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?
            .imageWithRenderingMode(.AlwaysTemplate)
            .resizableImageWithCapInsets(UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        
        UISegmentedControl.appearance().setBackgroundImage(controlBackground, forState: .Normal, barMetrics: .Default)
        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, forState: .Selected, barMetrics: .Default)
        
        
    }

    //end of ThemeManager
}
 