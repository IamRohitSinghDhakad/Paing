//
//  CategoryModel.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 24/04/21.
//

import UIKit

class CategoryModel: NSObject {

    //Currency Conversion
    var strCategoryName :String = ""
    var strCategoryID  = Int()
    var strCategoryImage :String = ""
    var strCategoryStatus :String = ""
    
    
    
    init(dict : [String:Any]) {
        
        if let categoryID = dict["category_id"] as? String{
            self.strCategoryID = Int(categoryID) ?? 0
        }else if let categoryID = dict["category_id"] as? Int{
            self.strCategoryID = categoryID
        }
        
        if let catImage = dict["category_image"] as? String{
            self.strCategoryImage = catImage
        }
        if let name = dict["category_name"] as? String{
            self.strCategoryName = name
        }
        if let status = dict["status"] as? String{
            self.strCategoryStatus = status
        }
        
        
    }
}


class SubCategoryModel: NSObject {

    //Currency Conversion
    var strSubCategoryName :String = ""
    var strSubCategoryID = Int()
    var strSubCategoryImage :String = ""
    var strSubCategoryStatus :String = ""
    var strCategoryName :String = ""
    var strCategoryID :String = ""
    
    
    init(dict : [String:Any]) {
        
        if let categoryID = dict["category_id"] as? String{
            self.strCategoryID = categoryID
        }else  if let categoryID = dict["category_id"] as? Int{
            self.strCategoryID = "\(categoryID)"
        }
        
        if let catName = dict["category_name"] as? String{
            self.strCategoryName = catName
        }
        
        if let categoryID = dict["sub_category_id"] as? String{
            self.strSubCategoryID = Int(categoryID) ?? 0
        }else if let categoryID = dict["sub_category_id"] as? Int{
            self.strSubCategoryID = categoryID
        }
        
        if let name = dict["sub_category_name"] as? String{
            self.strSubCategoryName = name
        }
        
    }
}
