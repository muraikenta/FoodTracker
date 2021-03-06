//
//  AppDelegate.swift
//  FoodTracker
//
//  Created by 村井謙太 on 2016/07/22.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let realm = try! Realm()
        if let currentUser = realm.objects(Session).first {
            Alamofire
                .request(.GET, "http://localhost:3002/api/auth/validate_token", parameters: currentUser.sessionParams())
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        switch response.response!.statusCode {
                        case 200:
                            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            self.window?.rootViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TabBarController")
                        case 401:
                            try! realm.write {
                                realm.delete(currentUser)
                            }
                        default:
                            print(response)
                        }
                    case .Failure(let error):
                        print(error)
                    }
                }
        }

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

