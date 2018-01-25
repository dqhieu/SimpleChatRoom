//
//  TextTableViewCell.swift
//  SimpleChatRoom
//
//  Created by Dinh Quang Hieu on 1/22/18.
//  Copyright © 2018 Dinh Quang Hieu. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblMessage: UILabel!

    func setup(message: Message) {
        self.lblUsername.attributedText = NSAttributedString(string: message.user.username, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)])
        self.lblMessage.text = message.text
    }
    
}
