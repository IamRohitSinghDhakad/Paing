//
//  NotificationModel.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 30/05/21.
//

import UIKit

class NotificationModel: NSObject {

    var strTime_ago    :String = ""
    var strType    :String = ""
    var strUserImage :String = ""
    var strUserID :String = ""
    var strNotificationTitle :String = ""
    var strNotificationID :String = ""
    var strName :String = ""
    var isSelected: Bool = false
    
    init(dict : [String:Any]) {
        
        
        if let notification_id = dict["notification_id"] as? String{
            self.strNotificationID = notification_id
        }else if let notification_id = dict["notification_id"] as? Int{
            self.strNotificationID = "\(notification_id)"
        }
        
        if let user_id = dict["notify_by"] as? String{
            self.strUserID = user_id
        }else if let user_id = dict["notify_by"] as? Int{
            self.strUserID = "\(user_id)"
        }
        
        if let type = dict["type"] as? String{
            self.strType = type
        }
        
        if let name = dict["name"] as? String{
            self.strName = name
        }
        
        if let user_image = dict["user_image"] as? String{
            self.strUserImage = user_image
        }
        
        if let notification_title = dict["notification_title"] as? String{
            self.strNotificationTitle = notification_title
        }
        
        if let time_ago = dict["time_ago"] as? String{
            self.strTime_ago = time_ago
        }
    }
}
