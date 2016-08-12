//
//  RegisterViewController.swift
//  FoodTracker
//
//  Created by 村井謙太 on 2016/08/12.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
import RealmSwift

class RegisterViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func register(sender: AnyObject) {
        let parameters = [
            "name": self.nameField.text ?? "",
            "email": self.emailField.text ?? "",
            "password": self.passwordField.text ?? "",
            ]
        Alamofire
            .request(.POST, "http://localhost:3002/api/auth/", parameters: parameters)
            .responseJSON { response in
                if response.response!.statusCode == 200 {
                    let headers = response.response!.allHeaderFields
                    let headersJson = JSON(headers)
                    
                    let session = Mapper<Session>().map(headersJson.dictionaryObject)!
                    
                    let bodyJson = JSON(response.result.value!)["data"]
                    session.setValue(bodyJson["email"].stringValue, forKey: "email")
                    
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
