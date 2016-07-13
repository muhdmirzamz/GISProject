//
//  WeatherMapViewController.swift
//  GISProject
//
//  Created by iOS on 12/7/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class GeoVisMapViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let localFilePath = NSBundle.mainBundle().URLForResource("heatmap", withExtension: "html")
        let myRequest = NSURLRequest(URL: localFilePath!)
        self.webView.loadRequest(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
