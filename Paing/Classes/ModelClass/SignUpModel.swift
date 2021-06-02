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
  
   
    var strDeviceId            : String = ""
    var strDeviceTimeZone        : String = ""
    var strDeviceType          : String = ""
    var strDeviceToken           : String = ""
    
    var strEmail                : String = ""
    var strName                  : String = ""
    var strPassword             : String = ""
    var strPhoneNumber          : String = ""
    var strProfilePicture     : String = ""
    var strSocialId           : String = ""
    var strSocialType          : String = ""
    var strStatus            : String = ""
    var strUserId               : String = ""
    var strUserName             : String = ""
    
    var strlatitude :String = ""
    var strlongitude :String = ""
    var strAddress :String = ""
    var strDob    :String = ""
    var strGender    :String = ""
    var strCity      :String = ""
    var strState      :String = ""
    var strCountry      :String = ""
    var strLookingFor      :String = ""
    
    var strAboutMe :String = ""
    var strSpecialInstruction :String = ""
    var strHairColor :String = ""
    var strAllowSex :String = ""
    var strAllowCountry :String = ""
    var strAllowCity :String = ""
    var strAllowState :String = ""
    var strCinema :String = ""
    var strEye :String = ""
    var strHeight :String = ""
    var strMusic :String = ""
    var strSkinTone :String = ""
    var strSport :String = ""

    
    
    init(dict : [String:Any]) {
        
        if let userID = dict["user_id"] as? String{
            self.strUserId = userID
        }else if let userID = dict["user_id"] as? Int{
            self.strUserId = "\(userID)"
        }
        
        if let username = dict["name"] as? String{
            self.strUserName = username
        }
        
        if let password = dict["password"] as? String{
            self.strPassword = password
        }
        
        if let password = dict["short_bio"] as? String{
            self.strAboutMe = password
        }
      
        
        if let hairColor = dict["hair"] as? String{
            self.strHairColor = hairColor
        }
        
        if let skin = dict["skin"] as? String{
            self.strSkinTone = skin
        }
        
        if let sport = dict["sport"] as? String{
            self.strSport = sport
        }
        
        if let music = dict["music"] as? String{
            self.strMusic = music
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
        
        if let allow_sex = dict["allow_sex"] as? String{
            self.strAllowSex = allow_sex
        }else if let allow_sex = dict["allow_sex"] as? Int{
            self.strAllowSex = "\(allow_sex)"
        }
        
        if let allow_country = dict["allow_country"] as? String{
            self.strAllowCountry = allow_country
        }else if let allow_country = dict["allow_country"] as? Int{
            self.strAllowCountry = "\(allow_country)"
        }
        
        if let allow_city = dict["allow_city"] as? String{
            self.strAllowCity = allow_city
        }else if let allow_city = dict["allow_city"] as? Int{
            self.strAllowCity = "\(allow_city)"
        }
        
        if let allow_state = dict["allow_state"] as? String{
            self.strAllowState = allow_state
        }else if let allow_state = dict["allow_state"] as? Int{
            self.strAllowState = "\(allow_state)"
        }
        
        
        if let height = dict["height"] as? String{
            self.strHeight = height
        }
        
        
        if let looking_for = dict["looking_for"] as? String{
            self.strLookingFor = looking_for
        }
        
        if let cinema = dict["cinema"] as? String{
            self.strCinema = cinema
        }
        
        if let eye = dict["eye"] as? String{
            self.strEye = eye
        }
        
        if let highlight_info = dict["highlight_info"] as? String{
            self.strSpecialInstruction = highlight_info
        }
        
        
        
        
        if let country = dict["country"] as? String{
            self.strCountry = country
        }
        
        if let state = dict["state"] as? String{
            self.strState = state
        }
        
        if let city = dict["city"] as? String{
            self.strCity = city
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
        
        if let device_id = dict["device_id"] as? String{
            self.strDeviceId = device_id
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
    }
}
