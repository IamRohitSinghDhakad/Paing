//
//  BlockModel.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 02/06/21.
//

import UIKit

class BlockModel: NSObject {
    
    var strName : String = ""
    var strAge : String = ""
    var strDob : String = ""
    var strGender : String = ""
    var strChatId : String = ""
    var strUserImage : String = ""
    
    init(dict : [String:Any]) {
        
        
        if let notification_id = dict["name"] as? String{
            self.strName = notification_id
        }
        
        if let user_image = dict["user_image"] as? String{
            self.strUserImage = user_image
        }
        
        if let sex = dict["sex"] as? String{
            self.strGender = sex
        }
        
        if let age = dict["age"] as? String{
            self.strAge = age
        }
        
        if let dob = dict["dob"] as? String{
            self.strDob = dob
        }
        
        if let notification_id = dict["name"] as? String{
            self.strChatId = notification_id
        }else  if let notification_id = dict["name"] as? Int{
            self.strChatId = "\(notification_id)"
        }
        
    }
    
}
