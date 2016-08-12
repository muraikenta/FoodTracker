//
//  LoginController.swift
//  FoodTracker
//
//  Created by 村井謙太 on 2016/08/05.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
import RealmSwift

class LoginViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var emailFileld: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func unwindToLogin(sender: UIStoryboardSegue) {
    }
    
    @IBAction func login(sender: UIButton) {
        let parameters = [
            "email": self.emailFileld.text ?? "",
            "password": self.passwordField.text ?? "",
        ]
        Alamofire
            .request(.POST, "http://localhost:3002/api/auth/sign_in", parameters: parameters)
            .responseJSON { response in
                if response.response!.statusCode == 200 {
                    let headers = response.response!.allHeaderFields
                    let headersJson = JSON(headers)
                    let session = Mapper<Session>().map(headersJson.dictionaryObject)!
                    
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(session)
                    }
                    
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let mealTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MealTableViewNavigator") as! UINavigationController
                    self.presentViewController(mealTableViewController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "メールアドレスまたはパスワードが違います", message: "", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(action)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
    }

}
