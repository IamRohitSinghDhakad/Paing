//
//  FavoriteModel.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 05/06/21.
//

import UIKit

class FavoriteModel: NSObject {
    
    var strName :String = ""
    var strUserImage :String = ""
    var strAge :String = ""
    var strOpponentUserID :String = ""
    var strGender :String = ""
    var strDOB : String = ""
    
    
    init(dict : [String : Any]) {
        
        
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
        }else if let age = dict["age"] as? Int{
            self.strAge = "\(age)"
        }
        
        if let dob = dict["dob"] as? String{
            self.strDOB = dob
        }
        
        if let user_id = dict["user_id"] as? String{
            self.strOpponentUserID = user_id
        }else  if let user_id = dict["user_id"] as? Int{
            self.strOpponentUserID = "\(user_id)"
        }
    }

}
