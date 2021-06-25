//
//  ConversationListModel.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 31/05/21.
//

import UIKit

class ConversationListModel: NSObject {
    
    var strUserImage :String = ""
    var strChatStatus :String = ""
    var strName: String = ""
    var strLastMsg: String = ""
    var strTimeAgo : String = ""
    var strSenderID :String = ""
    var strIsBlocked : String = ""
    
    init(dict : [String:Any]) {
        
        
        if let chat_status = dict["chat_status"] as? String{
            self.strChatStatus = chat_status
        }
        
        if let sender_id = dict["sender_id"] as? String{
            self.strSenderID = sender_id
        }else if let sender_id = dict["sender_id"] as? Int{
            self.strSenderID = "\(sender_id)"
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
        
        if let blocked = dict["blocked"] as? String{
            self.strIsBlocked = blocked
        }else  if let blocked = dict["blocked"] as? Int{
            self.strIsBlocked = "\(blocked)"
        }
        
    }
}
