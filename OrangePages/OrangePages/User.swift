//
//  User.swift
//  OrangePages
//
//  Created by Ufuk Türközü on 28.04.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit

class User {
    let id: String
    var name: String
    var image: String?
    var email: String
    var phone: String?
    var info: String?
    var favorites: [String] = []
    
    init(id: String = UUID().uuidString, name: String, image: String?, email: String, phone: String?, info: String?, favorites: [String]) {
        self.id = id
        self.name = name
        self.image = image
        self.email = email
        self.phone = phone
        self.info = info
        self.favorites = favorites
    }
    
    init(from dictionary: [String: Any?]) {
        self.id = dictionary["id"] as! String
        self.name = dictionary["name"] as! String
        self.image = dictionary["image"] as? String
        self.email = dictionary["email"] as! String
        self.phone = dictionary["phone"] as? String
        self.info = dictionary["info"] as? String
        self.favorites = dictionary["favorites"] as! [String]
    }
    
    func dictionary() -> [String : Any] {
        return ["id": id, "name": name, "image": image as Any, "email": email, "phone": phone as Any, "info": info as Any, "favorites": favorites as Any]
    }
}
