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
import Dollar

class LoginViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var emailFileld: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func afterLogin() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = mainStoryboard.instantiateViewControllerWithIdentifier("TabBarController")
        self.presentViewController(tabBarController, animated: true, completion: nil)
    }
    
    // MARK: Actions
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
                    let headerJson = JSON(headers)
                    let bodyJson = JSON(response.result.value!)["data"]
                    let sessionParams = $.merge(headerJson.dictionaryObject!, bodyJson.dictionaryObject!)

                    let session = Mapper<Session>().map(sessionParams)!
                    
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(session)
                    }
                    
                    self.afterLogin()
                } else {
                    let alertController = UIAlertController(title: "メールアドレスまたはパスワードが違います", message: "", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(action)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
    }

}
