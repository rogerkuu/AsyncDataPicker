//
//  AsyncDataPickerModel.swift
//  AsyncDataPicker
//
//  Created by Mianji GU on 2018/3/28.
//  Copyright © 2018年 Mianji GU. All rights reserved.
//

import UIKit

public class AsyncDataPickerModel: NSObject, AsyncDataPickerItemProtocol {
    public var parentID: String = ""
    public var id: String = ""
    public var name: String = ""
    public var code: String = ""
    
    public var pickerItemParentID: String { return parentID }
    public var pickerItemID: String { return id }
    public var pickerItemName: String { return name }
    public var pickerItemCode: String { return code }
}
