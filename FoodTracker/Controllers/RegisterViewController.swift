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
import Dollar

class RegisterViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Meal(name: "hoge", photo: UIImage(), rating: 4)!
    }

    // MARK: Actions
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
                    let headerJson = JSON(headers)
                    let bodyJson = JSON(response.result.value!)["data"]
                    let sessionParams = $.merge(headerJson.dictionaryObject!, bodyJson.dictionaryObject!)
                    
                    let session = Mapper<Session>().map(sessionParams)!
                    
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(session)
                    }
                    
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabBarController = mainStoryboard.instantiateViewControllerWithIdentifier("TabBarController")
                    self.presentViewController(tabBarController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "メールアドレスまたはパスワードが違います", message: "", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(action)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }

    }

}
