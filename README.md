# AsyncDataPicker
A customizable picker view. You can provide data source asynchronously, not neccessary to get all data before the view show up.   

![screenshot](https://github.com/rogerkuu/AsyncDataPicker/blob/master/demo.gif)

## Requirements
It requires Xcode 9.0+ and Swift 4.0.

## Installation
AsyncDataPicker is available on CocoaPods. Simply add the following line to your podfile:
```Swift
pod 'AsyncDataPicker'
```

## Usage
AsyncDataPicker is very simple to use.
```Swift
// Create a new AsyncDataPicker
let picker = AsyncDataPicker(numberOfComponents: 2, title: "Color")
//config DataProvider. You should 
picker.configDataProvider {[unowned self] (component, parentID, receiver) in
    if component == 0 {
        // load first Component Data from network or local.
        let firstComponentData = self.loadFirstComponentData() 
        // all component data should adopt AsyncDataPickerItemProtocol
        receiver(firstComponentData) 
    } else if component == 1 {
        // load second Component Data from network or local.
        let secondComponentData = self.loadSecondComponentData(firstID: parentID) 
        receiver(secondComponentData)
    }
}
picker.dataSelectedAction {[unowned self] (item) in
    guard let selectedData = item[1] else {
        return
    }
    self.resultField.text = selectedData.pickerItemName
}
picker.show()
```

## Configurations

```Swift
AsyncDataPickerAttribute.normalTextColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
    
AsyncDataPickerAttribute.selectedTextColor = UIColor(red: 116/255.0, green: 191/255.0, blue: 58/255.0, alpha: 1.0)
    
AsyncDataPickerAttribute.separatorColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    
AsyncDataPickerAttribute.totalHeight = 341
    
AsyncDataPickerAttribute.titleHeight = 40
    
AsyncDataPickerAttribute.tabbarHeight = 40
    
AsyncDataPickerAttribute.defaultComponentTitle = "Select"
```

## License
 AsyncDataPicker is released under the MIT license. See LICENSE for details.
