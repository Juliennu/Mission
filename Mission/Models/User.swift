//
//  User.swift
//  Mission
//
//  Created by Juri Ohto on 2021/08/18.
//

import Foundation
import Firebase




class User {
    let email: String
    let createdAt: Timestamp
    
    var uid: String?
    
    init(dic: [String: Any]) {
        self.email = dic["email"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
