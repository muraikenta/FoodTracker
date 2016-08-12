//
//  User.swift
//  FoodTracker
//
//  Created by 村井謙太 on 2016/08/08.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class Session: Object, Mappable {
//    dynamic var id = 0
    dynamic var name: String?
    dynamic var email: String?
    dynamic var uid: String!
    dynamic var client: String!
    dynamic var token: String!
    
//    dynamic var image: String?
    
    required convenience init?(_ map: Map) {
        self.init()
        self.mapping(map)
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
        uid <- map["Uid"]
        client <- map["Client"]
        token <- map["Access-Token"]
    }
}
