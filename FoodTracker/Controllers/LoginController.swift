//
//  LoginController.swift
//  FoodTracker
//
//  Created by 村井謙太 on 2016/08/05.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: Properties
    
    
    @IBAction func unwindToLogin(sender: UIStoryboardSegue) {
    }
    
    @IBAction func login(sender: UIButton) {
        let mealTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MealTableViewNavigator") as! UINavigationController
        self.presentViewController(mealTableViewController, animated: true, completion: nil)
    }

}
