//
//  AuthHelper.swift
//  FoodTracker
//
//  Created by 村井謙太 on 2016/08/13.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import Foundation
import RealmSwift

class SessionHelper {
    static func currentUser() -> Session? {
        let realm = try! Realm()
        return realm.objects(Session).first
    }
    
    static func authHeaders() -> [String: String]? {
        let realm = try! Realm()
        if let currentUser = realm.objects(Session).first {
            return currentUser.sessionParams()
        } else {
            return nil
        }
    }
}