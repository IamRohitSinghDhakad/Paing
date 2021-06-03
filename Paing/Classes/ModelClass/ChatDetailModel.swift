//
//  ChatDetailModel.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 03/06/21.
//

import UIKit

class ChatDetailModel: NSObject {
    
    var strOpponentChatMessage : String = ""
    var strOpponentChatTime : String = ""
    var strReceiverID   : String = ""
    var strImageUrl   : String = ""
  
    
    init(dict : [String:Any]) {
       
        if let receiver_id = dict["receiver_id"] as? String{
            self.strReceiverID = receiver_id
        }else  if let receiver_id = dict["receiver_id"] as? String{
            self.strReceiverID = receiver_id
        }
        
        if let chat_image = dict["chat_image"] as? String{
            self.strImageUrl = chat_image
        }
        
        
        if let chat_message = dict["chat_message"] as? String{
            self.strOpponentChatMessage = chat_message
        }
        
        if let time_ago = dict["time_ago"] as? String{
            self.strOpponentChatTime = time_ago
        }
        
      
    }
    
}
