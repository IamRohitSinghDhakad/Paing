//
//  ChatDetailViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 31/05/21.
//

import UIKit

class ChatDetailViewController: UIViewController {

    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var tblChat: UITableView!
    @IBOutlet var txtVwChat: SZTextView!
    @IBOutlet var hgtConsMaximum: NSLayoutConstraint!
    @IBOutlet var hgtConsMinimum: NSLayoutConstraint!
    @IBOutlet var btnSendTextMessage: UIButton!
    
    
    let txtViewCommentMaxHeight: CGFloat = 100
    let txtViewCommentMinHeight: CGFloat = 34
    
    
    var arrChatMessages = [ChatDetailModel]()
    
    var strUserName = ""
    var strUserImage = ""
    var strSenderID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblChat.delegate = self
        self.tblChat.dataSource = self
        self.txtVwChat.delegate = self
        
        self.lblUserName.text = strUserName
        
        let profilePic = self.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
        }
        
        self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId, strSenderID: self.strSenderID)
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
        
    }
    
    @IBAction func btnSendMessage(_ sender: Any) {
        if (txtVwChat.text?.isEmpty)!{
            
            self.txtVwChat.text = "."
            self.txtVwChat.text = self.txtVwChat.text.trimmingCharacters(in: .whitespacesAndNewlines)
            self.txtVwChat.isScrollEnabled = false
            self.txtVwChat.frame.size.height = self.txtViewCommentMinHeight
            self.txtVwChat.text = ""
            
            if self.txtVwChat.text.count > 0{
                
                self.txtVwChat.isScrollEnabled = false
                
            }else{
                self.txtVwChat.isScrollEnabled = false
            }
            
        }else{
            
         
            self.txtVwChat.frame.size.height = self.txtViewCommentMinHeight
            DispatchQueue.main.async {
                let text  = self.txtVwChat.text.encodeEmoji
                self.sendMessageNew(strText: text)
            }
            if self.txtVwChat.text.count > 0{
                self.txtVwChat.isScrollEnabled = false
                
            }else{
                self.txtVwChat.isScrollEnabled = false
            }
        }
        
    }
    
    /*
     if self.txtVwChat.text == ""{
         
     }else{
       //  self.offset = 0
         self.txtVwChat.frame.size.height = self.txtViewCommentMinHeight
         self.sendMessageNew()
     }
     **/
    
    @IBAction func btnOnDeleteChat(_ sender: Any) {
        self.tblChat.reloadData()
    }
}

//MARK:- UItextViewHeightManage
extension ChatDetailViewController: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 300
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
          if self.txtVwChat.text == "\n"{
              self.txtVwChat.resignFirstResponder()
          }
          else{
          }
          return true
      }
      
      
      func textViewDidChange(_ textView: UITextView)
      {
          if self.txtVwChat.contentSize.height >= self.txtViewCommentMaxHeight
          {
              self.txtVwChat.isScrollEnabled = true
          }
          else
          {
              self.txtVwChat.frame.size.height = self.txtVwChat.contentSize.height
              self.txtVwChat.isScrollEnabled = false
          }
      }
      
    
    
    func sendMessageNew(strText:String){
        self.txtVwChat.isScrollEnabled = false
        self.txtVwChat.contentSize.height = self.txtViewCommentMinHeight
        self.txtVwChat.text = self.txtVwChat.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.txtVwChat.text == "" {
           // AppSharedClass.shared.showAlert(title: "Alert", message: "Please enter some text", view: self)
            return
        }else{
            self.call_SendTextMessageOnly(strReceiverID: objAppShareData.UserDetail.strUserId, strSenderID: self.strSenderID, strText: strText)
           //asd self.call_WSSendMessage(strSenderID: self.getSenderID, strMessage: self.txtVwChat.text)
        }
        self.txtVwChat.text = ""
    }
    
}


//MARK:- UITableView Delegate and DataSource
extension ChatDetailViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrChatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblChat.dequeueReusableCell(withIdentifier: "ChatDetailTVCell")as! ChatDetailTVCell
        
        let obj = self.arrChatMessages[indexPath.row]
        
        
        if obj.strImageUrl != ""{
            if obj.strReceiverID == objAppShareData.UserDetail.strUserId{
                cell.vwMyMsg.isHidden = true
                cell.vwOpponent.isHidden = true
                cell.vwOpponentImage.isHidden = true
                cell.vwMyImage.isHidden = false
            }else{
                cell.vwMyMsg.isHidden = true
                cell.vwOpponent.isHidden = true
                cell.vwOpponentImage.isHidden = false
                cell.vwMyImage.isHidden = true
            }
        }else{
            if obj.strReceiverID == objAppShareData.UserDetail.strUserId{
                cell.vwOpponentImage.isHidden = true
                cell.vwMyImage.isHidden = true
                cell.vwMyMsg.isHidden = false
                cell.lblMyMsg.text = obj.strOpponentChatMessage
                cell.lblMyMsgTime.text = obj.strOpponentChatTime
                cell.vwOpponent.isHidden = true
            }else{
                cell.vwOpponentImage.isHidden = true
                cell.vwMyImage.isHidden = true
                cell.lblOpponentMsg.text = obj.strOpponentChatMessage
                cell.lblopponentMsgTime.text = obj.strOpponentChatTime
                cell.vwOpponent.isHidden = false
                cell.vwMyMsg.isHidden = true
            }
        }
        
        
        cell.lblOpponentMsg.text = obj.strOpponentChatMessage
        cell.lblopponentMsgTime.text = obj.strOpponentChatTime
        
        
        
        return cell
    }
    
    
    func updateTableContentInset() {
        let numRows = self.tblChat.numberOfRows(inSection: 0)
        var contentInsetTop = self.tblChat.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tblChat.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
        self.tblChat.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
    }
    
}


//Get Chat List
//MARK:- Call Webservice Chat List
extension ChatDetailViewController{
    
    func call_GetChatList(strUserID:String, strSenderID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["receiver_id":strUserID,
                         "sender_id":strSenderID,
                         "chat_status":"online"]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getChatList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{
                        let obj = ChatDetailModel.init(dict: dictdata)
                        self.arrChatMessages.append(obj)
                    }
                
                    self.tblChat.reloadData()
                    self.updateTableContentInset()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.tblChat.displayBackgroundText(text: "ningún record fue encontrado")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
 
    
    //MARK:- Send Text message Only
    
    func call_SendTextMessageOnly(strReceiverID:String, strSenderID:String, strText:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["receiver_id":strReceiverID,
                         "sender_id":strSenderID,
                         "type":"Text",
                         "chat_message":strText]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_insertChat, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
             
                
            }else{
                objWebServiceManager.hideIndicator()
               // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
           
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }

    
   }
    
}
