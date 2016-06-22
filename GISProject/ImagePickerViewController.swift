//
//  ImagePickerViewController.swift
//  GISProject
//
//  Created by iOS on 22/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class ImagePickerViewController: ViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var PickerView: UIPickerView!
    @IBOutlet weak var buttonSelect: UIButton!
    
    var colour : String = ""
    let pickerData = ["Black","Blue","Green","Orange","Purple","Red"]
    override func viewDidLoad() {
        super.viewDidLoad()
        PickerView.dataSource = self
        PickerView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        colour = pickerData[row]
        pickerListener()
    }
    
    func pickerListener(){
        
        switch colour {
        case "Black" :
            imageView.image = UIImage(named: "ProfileBlack")
        case "Blue" :
            imageView.image = UIImage(named: "ProfileBlue")
        case "Green" :
            imageView.image = UIImage(named: "ProfileGreen")
        case "Orange" :
            imageView.image = UIImage(named: "ProfileOrange")
        case "Purple" :
            imageView.image = UIImage(named: "ProfilePurple")
        case "Red" :
            imageView.image = UIImage(named: "ProfileRed")
        default:
            imageView.image = UIImage(named: "ProfileBlack")
        }

    }
}
