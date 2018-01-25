//
//  ImageTableViewCell.swift
//  SimpleChatRoom
//
//  Created by Dinh Quang Hieu on 1/22/18.
//  Copyright © 2018 Dinh Quang Hieu. All rights reserved.
//

import UIKit
import Kingfisher

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgViewPhoto: UIImageView!
    @IBOutlet weak var imgViewHeightConstraint: NSLayoutConstraint!
    
    func setup(message: Message) {
        self.imgViewHeightConstraint.constant = self.contentView.frame.width * 3.0 / 5.0
        self.lblUsername.attributedText = NSAttributedString(string: message.user.username, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)])
        if let url = URL(string: message.imageUrl!) {
            let resource = ImageResource(downloadURL: url, cacheKey: message.id)
            self.imgViewPhoto.kf.setImage(with: resource)
        }
    }
    
}
