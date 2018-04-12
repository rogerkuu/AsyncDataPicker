//
//  ViewController.swift
//  TestAsyncDataPicker
//
//  Created by Mianji GU on 2018/4/12.
//  Copyright © 2018年 Mianji GU. All rights reserved.
//

import UIKit
import AsyncDataPicker

class ViewController: UIViewController {
    @IBOutlet weak var colorValueField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectColorAction(_ sender: UIButton) {
        let picker = AsyncDataPicker(numberOfComponents: 2, title: "Color")
        picker.configDataProvider {[unowned self] (component, parentID, receiver) in
            if component == 0 {
                receiver(self.loadColorTypeFromServerOrLocal())
            } else if component == 1 {
                receiver(self.loadColorDataFromServerOrLocal(typeID: parentID))
            }
        }
        picker.dataSelectedAction {[unowned self] (item) in
            guard let selectedData = item[1] else {
                return
            }
            self.colorValueField.text = selectedData.pickerItemName
        }
        picker.show()
    }
}

// MARK: - test data
extension ViewController {
    private func loadColorTypeFromServerOrLocal() -> [AsyncDataPickerModel] {
        var typeArray = [AsyncDataPickerModel]()
        
        let redColor = AsyncDataPickerModel()
        redColor.code = "w"
        redColor.name = "Warm"
        redColor.id = "1"
        typeArray.append(redColor)
        
        let greenColor = AsyncDataPickerModel()
        greenColor.code = "c"
        greenColor.name = "Cool"
        greenColor.id = "2"
        typeArray.append(greenColor)
        
        return typeArray
    }
    
    private func loadColorDataFromServerOrLocal(typeID: String) -> [AsyncDataPickerModel] {
        var colorArray = [AsyncDataPickerModel]()
        if typeID == "1" {
            let redColor = AsyncDataPickerModel()
            redColor.code = "r"
            redColor.name = "red"
            redColor.id = "1"
            colorArray.append(redColor)
            
            let greenColor = AsyncDataPickerModel()
            greenColor.code = "o"
            greenColor.name = "orange"
            greenColor.id = "2"
            colorArray.append(greenColor)
            
            let blueColor = AsyncDataPickerModel()
            blueColor.code = "y"
            blueColor.name = "yellow"
            blueColor.id = "3"
            colorArray.append(blueColor)
        } else if typeID == "2" {
            let redColor = AsyncDataPickerModel()
            redColor.code = "b"
            redColor.name = "blue"
            redColor.id = "1"
            colorArray.append(redColor)
            
            let greenColor = AsyncDataPickerModel()
            greenColor.code = "g"
            greenColor.name = "green"
            greenColor.id = "2"
            colorArray.append(greenColor)
            
            let blueColor = AsyncDataPickerModel()
            blueColor.code = "lp"
            blueColor.name = "light purple"
            blueColor.id = "3"
            colorArray.append(blueColor)
        }
        
        return colorArray
    }
}
