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

/*
 "account_holder_name" = "";
 "account_no" = "";
 address = "";
 age = "";
 "allow_city" = 0;
 "allow_country" = 0;
 "allow_sex" = "";
 "allow_state" = 0;
 "bank_name" = "";
 blocked = 0;
 "branch_name" = "";
 "category_id" = "";
 "chat_status" = "";
 "chat_time" = "0000-00-00 00:00:00";
 cinema = "";
 city = Barcelona;
 code = "";
 "commission_base" = 0;
 country = "Espa\U00f1a";
 distance = "67 Kms";
 dob = "1994-08-14";
 document = "";
 email = "vaneverbo2013@gmail.com";
 "email_verified" = 1;
 entrydt = "2021-05-01 19:11:35";
 "expiry_date" = "2130-11-06 22:17:01";
 eye = "";
 "fssai_image" = "";
 "fssai_no" = "";
 "gst_image" = "";
 "gst_no" = "";
 "gumasta_image" = "";
 "gumasta_no" = "";
 hair = "";
 height = "";
 "highlight_info" = "";
 "ifsc_code" = "";
 lat = "";
 liked = 0;
 likes = 1;
 lon = "";
 "looking_for" = "";
 "membership_id" = 2;
 mobile = "";
 "mobile_verified" = 0;
 music = "";
 name = " Vanesa";
 otp = "";
 "over_commission" = 0;
 password = e2cbbe82;
 "payment_email" = "";
 rating = "3.0";
 "register_id" = "";
 "rel_status" = "";
 sex = Female;
 "shipping_time" = 0;
 "short_bio" = "";
 skin = "";
 "social_id" = "";
 "social_type" = "";
 sport = "";
 state = Barcelona;
 status = 1;
 "sub_category_id" = "";
 "swift_code" = "";
 type = user;
 "under_commission" = 0;
 "user_id" = 10;
 "user_image" = "http://ambitious.in.net/Shubham/paing/uploads/user/5170IMG_1619887546723.png";
 visible = 0;
 work = "";
 */
