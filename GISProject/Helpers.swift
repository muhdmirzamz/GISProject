//
//  Helpers.swift
//  itp312-practestA
//
//  Created by KIM FOONG CHOW on 5/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Foundation

public class Helpers
{
    
    
    
    
    
    
    

    // Downloads the image using the specified URL and 
    // shows it on the imageView. If your imageView is
    // within a TableViewCell, make sure you pass in the
    // TableViewCell object too.
    //
    static func loadAndDisplayImage(cell: UITableViewCell!, imageView: UIImageView, url: String)
    {
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
        
        // Load the image from the given URL
        //
        let nurl = NSURL(string: url)
        var imageBinary : NSData?
        if nurl != nil
        {
            imageBinary = NSData(contentsOfURL: nurl!)
        }
        
        
        dispatch_async(dispatch_get_main_queue()) {
        
        // After retrieving the image data, we convert
        // it to an UIImage object. This is an update
        // to the User Interface.
        //
        var img : UIImage?
        if imageBinary != nil
        {
            img = UIImage(data: imageBinary!)
        }

        imageView.image = img
        
        // Tells the cell, if available, to re-layout itself.
        // This is an update to the User Interface.
        if cell != nil
        {
            cell.setNeedsLayout()
        }
            
        }
    }
        
        
    }
    
    
    
   

}


