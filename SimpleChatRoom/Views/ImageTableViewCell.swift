//
//  ImageTableViewCell.swift
//  SimpleChatRoom
//
//  Created by Dinh Quang Hieu on 1/22/18.
//  Copyright © 2018 Dinh Quang Hieu. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgViewPhoto: UIImageView!
    @IBOutlet weak var imgViewHeightConstraint: NSLayoutConstraint!
    
    func setup() {
        self.imgViewHeightConstraint.constant = self.contentView.frame.width * 3.0 / 5.0
    }
    
}
