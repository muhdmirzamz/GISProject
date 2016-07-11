//
//  BattleViewController2.swift
//  GISProject
//
//  Created by iOS on 11/7/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

protocol BattleProtocol {
    func backtoMap()
}

class BattleViewController2: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var monsterHealthBar: UIProgressView!
    @IBOutlet var monsterHealthLabel: UILabel!
    @IBOutlet var textfield: UITextField!
    @IBOutlet var userCardSwitch: UISwitch!
    @IBOutlet var calculatedDamageLabel: UILabel!
    @IBOutlet var attackButton: UIButton!
    
    // to change the annotation location after killing monster
    var selectedAnnotation: LocationModel?
    
    var pickerView: UIPickerView?
    
    var delegate: BattleProtocol?
    var battle: Battle?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.battle = Battle()
        
        self.monsterHealthLabel.text = "\(String(self.battle!.getMonsterHealth()))/1"
        
        self.pickerView = UIPickerView()
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        
        self.textfield.inputView = self.pickerView
        self.textfield.text = String(self.battle!.getAmountOfCardsToUse())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
