//
//  DetailsSubCategoryModel.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 09/05/21.
//

import UIKit

class DetailsSubCategoryModel: NSObject {
    
    /*
     area = "";
   
     city = "";
      = "2021-04-28";
      = "";
      = "Testing purposes only";
      = "testuser@gmail.com";
     entrydt = "2021-04-28 17:42:43";
      = "";
      = "";
     "fees_unit" = 0;
      = "";
     files = "";
     "" = "Semi-Furnished";
      = "Testing purposes only";
     image1 = "uploads/post/4732IMG_1619631706413.png";
     image2 = "uploads/post/6941IMG_1619631714175.png";
     image3 = "";
     "" = "";
      = "22.8167246";
     "" = Owner;
      = "Manglaya Sadak, Indore, Madhya Pradesh 453771, India";
     lon = "75.9255585";
     "" = "";
     "" = "";
     "" = "";
      = 9827864062;
      = Test;
     "" = "";
     "" = "";
     "" = Sell;
     "post_id" = 1;
      = 3000000;
      = "";
     rating = "0.0";
     remark = "";
      = 5;
      = 2000;
     status = "";
     "" = 47;
     "" = Duplex;
     "time_ago" = "1 week ago";
      = 8;
     type = "";
     "user_id" = 6;
     "user_image" = "http://ambitious.in.net/Shubham/tech/uploads/user/3039IMG_1619257809184.png";
     validity = "";
     "working_hour" = "";
     "working_hour_unit" = "";
     **/
    
    var strImageUrl :String = ""
    var strBaseUrl :String = ""
    var strUser_id :String = ""
    var strPrice :String = ""
    var strLocation :String = ""
    var strImageURL1 :String = ""
    var strImageURL2 :String = ""
    var strImageURL3 :String = ""
    var strCategoryID :String = ""
    var strCategory :String = ""
    var strSubCategoryID :String = ""
    var strSubCategory :String = ""
    var strDate :String = ""
    var strDegree :String = ""
    var strDetail :String = ""
    var strEmail :String = ""
    var strExperience :String = ""
    var strFees :String = ""
    var strField :String = ""
    var strFurnishedStatus :String = ""
    var strHeading :String = ""
    var strLastJob :String = ""
    var strListedBy :String = ""
    var strLookingFor :String = ""
    
    var strMaxAmount :String = ""
    var strMinAmount :String = ""
    var strQualification :String = ""
    var strRoom :String = ""
    var strSize :String = ""
    var strToilet :String = ""
    var strWorkingHour :String = ""
    var strName :String = ""
    var strMobile :String = ""
    var strOfferDesription :String = ""
    var strPostFor :String = ""
    var strType :String = ""
    var strOfferedRole :String = ""
    var strLatitude :String = ""
    var strLongitude :String = ""
    var strRating :String = ""
    
    init(dict : [String:Any]) {
        
        if let base_url = dict["base_url"] as? String{
            self.strBaseUrl = base_url
        }
        
        if let user_image = dict["user_image"] as? String{
            self.strImageUrl = user_image
        }
        
        
        if let image1 = dict["image1"] as? String{
            self.strImageURL1 = image1
        }
        if let image2 = dict["image2"] as? String{
            self.strImageURL2 = image2
        }
        if let image3 = dict["image3"] as? String{
            self.strImageURL3 = image3
        }
        
        if let location = dict["location"] as? String{
            self.strLocation = location
        }
        
        if let date = dict["date"] as? String{
            self.strDate = date
        }
        
        if let degree = dict["degree"] as? String{
            self.strDegree = degree
        }
        
        if let degree = dict["detail"] as? String{
            self.strDetail = degree
        }
        
        if let degree = dict["email"] as? String{
            self.strEmail = degree
        }
                
        if let experience = dict["experience"] as? String{
            self.strExperience = experience
        }
        
        if let fees = dict["fees"] as? String{
            self.strFees = fees
        }
        
        if let field = dict["field"] as? String{
            self.strField = field
        }
        
        if let furnished_status = dict["furnished_status"] as? String{
            self.strFurnishedStatus = furnished_status
        }
        
        if let heading = dict["heading"] as? String{
            self.strHeading = heading
        }
        
        if let last_job = dict["last_job"] as? String{
            self.strLastJob = last_job
        }
        
        if let listed_by = dict["listed_by"] as? String{
            self.strListedBy = listed_by
        }
        
        if let looking_for = dict["looking_for"] as? String{
            self.strLookingFor = looking_for
        }
        
        
        if let max_amount = dict["max_amount"] as? String{
            self.strMaxAmount = max_amount
        }else if let max_amount = dict["max_amount"] as? Int{
            self.strMaxAmount = "\(max_amount)"
        }
        if let min_amount = dict["min_amount"] as? String{
            self.strMinAmount = min_amount
        }else if let min_amount = dict["min_amount"] as? Int{
            self.strMinAmount = "\(min_amount)"
        }
        if let mobile = dict["mobile"] as? String{
            self.strMobile = mobile
        }else if let mobile = dict["mobile"] as? Int{
            self.strMobile = "\(mobile)"
        }
        
        if let name = dict["name"] as? String{
            self.strName = name
        }
        
        if let offer_desc = dict["offer_desc"] as? String{
            self.strOfferDesription = offer_desc
        }
        if let offered_role = dict["offered_role"] as? String{
            self.strOfferedRole = offered_role
        }
        if let post_for = dict["post_for"] as? String{
            self.strPostFor = post_for
        }
        if let qualification = dict["qualification"] as? String{
            self.strQualification = qualification
        }
        if let rooms = dict["rooms"] as? String{
            self.strRoom = rooms
        }
        
        if let size = dict["size"] as? String{
            self.strSize = size
        }
        
        if let toilet = dict["toilet"] as? String{
            self.strToilet = toilet
        }
        
        if let working_hour = dict["working_hour"] as? String{
            self.strWorkingHour = working_hour
        }
        
        if let type = dict["type"] as? String{
            self.strType = type
        }
        
        if let sub_CategoryName = dict["sub_category_name"] as? String{
            self.strSubCategory = sub_CategoryName
        }
        
        if let sub_CategoryID = dict["sub_category_id"] as? String{
            self.strSubCategoryID = sub_CategoryID
        }else if let sub_CategoryID = dict["sub_category_id"] as? Int{
            self.strSubCategoryID = "\(sub_CategoryID)"
        }
        
        if let CategoryName = dict["category_name"] as? String{
            self.strCategory = CategoryName
        }
        
        if let CategoryID = dict["category_id"] as? String{
            self.strCategoryID = CategoryID
        }else if let CategoryID = dict["category_id"] as? Int{
            self.strCategoryID = "\(CategoryID)"
        }
        
        if let userID = dict["user_id"] as? String{
            self.strUser_id = userID
        }else if let userID = dict["user_id"] as? Int{
            self.strUser_id = "\(userID)"
        }
        if let price = dict["price"] as? String{
            self.strPrice = price
        }else if let price = dict["price"] as? Int{
            self.strPrice = "\(price)"
        }
        
        if let lat = dict["lat"] as? String{
            self.strLatitude = lat
        }else if let lat = dict["lat"] as? Int{
            self.strLatitude = "\(lat)"
        }
        
        if let lon = dict["lon"] as? String{
            self.strLongitude = lon
        }else if let lon = dict["lon"] as? Int{
            self.strLongitude = "\(lon)"
        }
        
        if let rating = dict["rating"] as? String{
            self.strRating = rating
        }else if let rating = dict["rating"] as? Int{
            self.strRating = "\(rating)"
        }
    }
}
