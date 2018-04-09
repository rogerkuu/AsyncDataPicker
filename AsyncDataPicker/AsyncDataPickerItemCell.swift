//
//  AsyncDataPickerItemCell.swift
//  AsyncDataPicker
//
//  Created by Mianji GU on 2018/3/28.
//  Copyright © 2018年 Mianji GU. All rights reserved.
//

import UIKit

class AsyncDataPickerItemCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var model: AsyncDataPickerItemProtocol? {
        didSet {
            if let text = model?.pickerItemName {
                titleLabel.text = text
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
