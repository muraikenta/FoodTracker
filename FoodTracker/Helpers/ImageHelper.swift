//
//  File.swift
//  FoodTracker
//
//  Created by 村井謙太 on 2016/08/13.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Alamofire

class ImageHelper {
    
    static func loadImageFromUrl(url: String, view: UIImageView) {
        let url = NSURL(string: url)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) in
            if let data = responseData {
                dispatch_async(dispatch_get_main_queue(), {
                    view.image = UIImage(data: data)
                })
            }
        }
        
        task.resume()
    }
    
//    static func upload(apiEndpoint: String) {
//        if let imageURL = info[UIImagePickerControllerReferenceURL]
//        Alamofire.upload(.PUT, url + "/api/Image/" + id, file: imageURL).responseString {
//            _, _, result in
//            print("Success: \(result.isSuccess)")
//            print("Response String: \(result.value)")
//        }
//        Alamofire.upload(
//            .POST,
//            apiEndpoint,
//            multipartFormData: { multipartFormData in
//                multipartFormData.appendBodyPart(fileURL: fileURL, name: "image")
//            },
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .Success(let upload, _, _):
//                    upload.responseJSON { response in
//                        debugPrint(response)
//                    }
//                case .Failure(let encodingError):
//                    print(encodingError)
//                }
//            }
//        )
//        
//    }
}