//
//  profileViewController.swift
//  FoodTracker
//
//  Created by 村井謙太 on 2016/08/13.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import WebImage

class profileViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser: Session? = SessionHelper.currentUser()
        self.nameLabel.text = currentUser!.name
        if let imageUrl = currentUser!.image {
            self.userImage.sd_setImageWithURL(NSURL(string: imageUrl))
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? NSURL
        {
            let imagePicked = info[UIImagePickerControllerOriginalImage] as! UIImage
            let imagePickedData: NSData!
            
            self.userImage.image = imagePicked
            
            if Regexp("(JPG|JPEG)").isMatch(imageURL.absoluteString) {
                imagePickedData = UIImageJPEGRepresentation(imagePicked, 0.3)!
            } else {
                imagePickedData = UIImagePNGRepresentation(imagePicked)
            }
            Alamofire.upload(
                .PATCH,
                "http://localhost:3002/api/sessions/update_image",
                headers: SessionHelper.authHeaders(),
                multipartFormData: { multipartFormData in
                    multipartFormData.appendBodyPart(data: imagePickedData, name: "binary")
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            let currentUser: Session? = SessionHelper.currentUser()
                            let realm = try! Realm()
                            try! realm.write {
                                currentUser?.image = JSON(response.result.value!)["image"].stringValue
                            }
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
                }
            )

        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
}
