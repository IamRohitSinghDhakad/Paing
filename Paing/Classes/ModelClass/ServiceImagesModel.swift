//
//  ServiceImagesModel.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 25/04/21.
//

import UIKit

class ServiceImagesModel: NSObject {
    
    var strImageUrl :String = ""
    var strUser_id :String = ""
    var strUser_image_id :String = ""
    
    
    init(dict : [String:Any]) {
        
        if let image = dict["file"] as? String{
            self.strImageUrl = image
        }
        if let userID = dict["user_id"] as? String{
            self.strUser_id = userID
        }else if let userID = dict["user_id"] as? Int{
            self.strUser_id = "\(userID)"
        }
        if let user_image_id = dict["user_image_id"] as? String{
            self.strUser_image_id = user_image_id
        }else if let user_image_id = dict["user_image_id"] as? Int{
            self.strUser_image_id = "\(user_image_id)"
        }
    }


}
