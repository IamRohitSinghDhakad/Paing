//
//  HomeModel.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 22/05/21.
//

import UIKit

class HomeModel: NSObject {
    
    
    var strName     :String = ""
    var strAge    :String = ""
    var strImageUrl :String = ""
    
    init(dict : [String:Any]) {
        
        if let name = dict["name"] as? String{
            self.strName = name
        }
        
        if let age = dict["age"] as? String{
            self.strAge = age
        }
        
        if let image = dict["user_image"] as? String{
            self.strImageUrl = image
        }
    }

}
