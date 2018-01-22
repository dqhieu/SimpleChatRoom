//
//  User.swift
//  SimpleChatRoom
//
//  Created by Dinh Quang Hieu on 1/22/18.
//  Copyright © 2018 Dinh Quang Hieu. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var email: String
    var username: String
    
    init(email: String) {
        self.email = email
        if let username = email.split(separator: "@").first {
            self.username = username
        } else {
            self.username = email
        }
    }
}
