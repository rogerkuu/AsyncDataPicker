//
//  AsyncDataPickerHeaderCell.swift
//  AsyncDataPicker
//
//  Created by Mianji GU on 2018/3/28.
//  Copyright © 2018年 Mianji GU. All rights reserved.
//

import UIKit

class AsyncDataPickerHeaderCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    var model: AsyncDataPickerItemProtocol? {
        didSet {
            if let text = model?.pickerItemName, !text.isEmpty {
                titleLabel.text = text
            } else {
                titleLabel.text = AsyncDataPickerAttribute.defaultComponentTitle
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
