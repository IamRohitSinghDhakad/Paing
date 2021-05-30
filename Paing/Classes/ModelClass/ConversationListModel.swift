//
//  ConversationListModel.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 31/05/21.
//

import UIKit

class ConversationListModel: NSObject {
    
    var strUserImage :String = ""
    var strChatID :String = ""
    var strName: String = ""
    var strLastMsg: String = ""
    var strTimeAgo : String = ""
    
    init(dict : [String:Any]) {
        
        
        if let notification_id = dict["notification_id"] as? String{
            self.strChatID = notification_id
        }else if let notification_id = dict["notification_id"] as? Int{
            self.strChatID = "\(notification_id)"
        }
        
        if let user_image = dict["user_image"] as? String{
            self.strUserImage = user_image
        }
        
        if let name = dict["name"] as? String{
            self.strName = name
        }
        
        if let last_message = dict["last_message"] as? String{
            self.strLastMsg = last_message
        }
        
        if let time_ago = dict["time_ago"] as? String{
            self.strTimeAgo = time_ago
        }
        
    }
}
