//
//  SignUpModel.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 25/03/21.
//

import UIKit

class SignUpModel: NSObject {

    var strName           : String = ""
    var strEmail          : String = ""
    var strPassword       : String = ""
    var strConfirmPassword : String = ""
    var strPhoneNo        : String = ""
    var strDialCode        : String = ""
    var strCountryCode    : String = ""
    var strDeviceToken    : String = ""
}

class userDetailModel: NSObject {
    var straAuthToken          : String = ""
    var strCountyCode          : String = ""
    var strCreateAt            : String = ""
    var strDeviceId            : String = ""
    var strDeviceTimeZone        : String = ""
    var strDeviceType          : String = ""
    var strDeviceToken           : String = ""
    
    var strEmail                : String = ""
    var strName                  : String = ""
    var strPassword             : String = ""
    var strPhoneDialCode        : String = ""
    var strPhoneNumber          : String = ""
    var strProfilePicture     : String = ""
    var strProfileTimeZone     : String = ""
    var strSocialId           : String = ""
    var strSocialType          : String = ""
    var strStatus            : String = ""
    var strUserId               : String = ""
    var strUserName             : String = ""
    var strUserMetaId             : String = ""
    var stronboarding_step        : String = ""
    var strphone_country_code       : String = ""
    var strStars                   : String = ""
    var strpushAlertStatus         : String = ""
    var strUserType         : String = ""
    var availableStars   :String = ""
    var strCategory      :String = ""
    var strSubCategory :String = ""
    var strCategoryID :String = ""
    var strSubCategoryID :String = ""
    
    var strlatitude :String = ""
    var strlongitude :String = ""
    var strAddress :String = ""
    var strDob    :String = ""
    var strGender    :String = ""
    
    //Currency Conversion
    var strUserCountryName :String = ""
    var strUserCurrency :String = ""
    var strUserCountryID :String = ""
    
    
    init(dict : [String:Any]) {
        
        if let username = dict["name"] as? String{
            self.strUserName = username
        }
        
        if let password = dict["password"] as? String{
            self.strPassword = password
        }
        
        if let name = dict["name"] as? String{
            self.strName = name
        }
        
        if let email = dict["email"] as? String{
            self.strEmail = email
        }
        
        if let address = dict["address"] as? String{
            self.strAddress = address
        }
        
        if let country_code = dict["country_code"] as? String{
            self.strCountyCode = country_code
        }
        
        if let country_id = dict["country_id"] as? String{
            self.strUserCountryID = country_id
        }
        
        if let country_name = dict["country_name"] as? String{
            self.strUserCountryName = country_name
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
        
 
        if let lat = dict["lat"] as? String{
            self.strlatitude = lat
        }else if let lat = dict["lat"] as? Int{
            self.strlatitude = "\(lat)"
        }
        
        if let long = dict["lon"] as? String{
            self.strlongitude = long
        }else if let long = dict["lon"] as? Int{
            self.strlongitude = "\(long)"
        }
        
        if let currency_code = dict["currency_code"] as? String{
            self.strUserCurrency = currency_code
        }
        
        if let phone_country_code = dict["phone_country_code"] as? String{
            self.strphone_country_code = phone_country_code
        }
        
        if let phone_number = dict["mobile"] as? String{
            self.strPhoneNumber = phone_number
        }else if let phone_number = dict["mobile"] as? Int{
            self.strPhoneNumber = "\(phone_number)"
        }
        
        if let dob = dict["dob"] as? String{
            self.strDob = dob
        }
        
        if let sex = dict["sex"] as? String{
            self.strGender = sex
        }
        
        
        
        if let profile_picture = dict["user_image"] as? String{
            self.strProfilePicture = profile_picture
        }
        
        if let phone_dial_code = dict["phone_dial_code"] as? String{
            self.strPhoneDialCode = phone_dial_code
        }
        
        if let social_id = dict["social_id"] as? String{
            self.strSocialId = social_id
        }
        if let social_type = dict["social_type"] as? String{
            self.strSocialType = social_type
        }
        
        
        if let onboarding_step = dict["onboarding_step"] as? String{
            self.stronboarding_step = onboarding_step
        }
        
        if let status = dict["status"] as? String{
            self.strStatus = status
        }
        
        if let created_at = dict["created_at"] as? String{
            self.strCreateAt = created_at
        }
        if let device_id = dict["device_id"] as? String{
            self.strDeviceId = device_id
        }
        
        if let device_timezone = dict["device_timezone"] as? String{
            self.strDeviceTimeZone = device_timezone
        }
        
        if let device_token = dict["device_token"] as? String{
            self.strDeviceToken = device_token
        }
        
        if let device_type = dict["device_type"] as? String{
            self.strDeviceType = device_type
        }
        
        if let auth_token = dict["auth_token"] as? String{
            self.straAuthToken = auth_token
            UserDefaults.standard.setValue(auth_token, forKey: objAppShareData.UserDetail.straAuthToken)
        }
        
//        if let dictCategories = dict["categories"]as? [String:Any]{
//            if let category = dictCategories["parent"]as? String{
//                self.strCategory = category
//            }
//            if let subCategory = dictCategories["name"]as? String{
//                self.strSubCategory = subCategory
//            }
//            if let categoryID = dictCategories["id"]as? String{
//                self.strSubCategoryID = categoryID
//            }else if let categoryID = dictCategories["id"]as? Int{
//                self.strSubCategoryID = String(categoryID)
//            }
//            if let categoryID = dictCategories["parentId"]as? String{
//                self.strCategoryID = categoryID
//            }else if let categoryID = dictCategories["parentId"]as? Int{
//                self.strCategoryID = String(categoryID)
//            }
//        }
        
        if let profile_timezone = dict["profile_timezone"] as? String{
            self.strProfileTimeZone = profile_timezone
        }
        
        if let userID = dict["user_id"] as? String{
            self.strUserId = userID
        }else if let userID = dict["user_id"] as? Int{
            self.strUserId = "\(userID)"
        }
        
        if let starPoints = dict["total"] as? String{
        self.strStars = starPoints
        }
               if let userType = dict["user_type"] as? String{
                  self.strUserType = userType
               }
               
               if let stars = dict["available"] as? String{
                   self.availableStars = stars
               }else if let stars = dict["available"] as? Int{
                   self.availableStars = "\(stars)"
               }else if let stars = dict["available"] as? Double{
                   self.availableStars = "\(stars)"
               }
               
               if let pushAlertStatus = dict["push_alert_status"] as? String{
                   self.strpushAlertStatus = pushAlertStatus
               }else  if let pushAlertStatus = dict["push_alert_status"] as? Int{
                   self.strpushAlertStatus = "\(pushAlertStatus)"
               }
               
        
    }
}
