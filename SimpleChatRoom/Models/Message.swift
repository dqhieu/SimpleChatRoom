//
//  Message.swift
//  SimpleChatRoom
//
//  Created by Dinh Quang Hieu on 1/22/18.
//  Copyright © 2018 Dinh Quang Hieu. All rights reserved.
//

import UIKit

class Message: NSObject {

    var user: User
    var text: String?
    var imageUrl: String?
    
    init(user: User, text: String? = nil, imageUrl: String? = nil) {
        self.user = user
        self.text = text
        self.imageUrl = imageUrl
    }
}
