//
//  Firebase.swift
//  SimpleChatRoom
//
//  Created by Dinh Quang Hieu on 1/23/18.
//  Copyright © 2018 Dinh Quang Hieu. All rights reserved.
//

import UIKit
import Firebase

class Firebase {
   
    static let auth: Auth = Auth.auth()
    static let database: DatabaseReference = Database.database().reference()
    static let storage: StorageReference = Storage.storage().reference()
    
}
