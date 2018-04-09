//
//  AsyncDataPickerItemProtocol.swift
//  AsyncDataPicker
//
//  Created by Mianji GU on 2018/3/28.
//  Copyright © 2018年 Mianji GU. All rights reserved.
//

import Foundation

public protocol AsyncDataPickerItemProtocol {
    var pickerItemParentID: String { get }
    var pickerItemID: String { get }
    var pickerItemName: String { get }
    var pickerItemCode: String { get }
}
