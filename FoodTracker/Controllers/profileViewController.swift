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

class profileViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let currentUser = realm.objects(Session).first!

        self.nameLabel.text = currentUser.name
        if let imageUrl = currentUser.image {
            ImageHelper.loadImageFromUrl(imageUrl, view: userImage)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let imageURL = info[UIImagePickerControllerReferenceURL]
        {
            let imagePicked = info[UIImagePickerControllerOriginalImage] as! UIImage
            let imagePickedData: NSData = UIImageJPEGRepresentation(imagePicked, 0.3)!
            Alamofire.upload(
                .PATCH,
                "http://localhost:3002/api/sessions/update_image",
                headers: AuthHelper.authHeaders(),
                multipartFormData: { multipartFormData in
                    multipartFormData.appendBodyPart(data: imagePickedData, name: "binary")
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
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
