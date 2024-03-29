//
//  ChatViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class ChatViewController: UIViewController {
    
    //MARK: - Override Methods
    @IBOutlet var tblMessage: UITableView!
    
    var arrMessageList = [ConversationListModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tblMessage.delegate = self
        self.tblMessage.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.arrMessageList.removeAll()
        self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId)
    }
    
    //MARK: - Action Methods
    @IBAction func actionSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
}

//MARK:- Uitablevie datasource and delegates
extension ChatViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMessageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell")as! MessageTableViewCell
        
        let obj = self.arrMessageList[indexPath.row]
        
        cell.lblUserName.text = obj.strName
        
        if obj.strLastMsg != ""{
            let emojiString  = obj.strLastMsg.decodeEmoji
            cell.lblMessage.text = emojiString
            //cell.lblMessage.text = obj.strLastMsg
        }else{
            cell.lblMessage.text = "Image"
        }
        
        let profilePic = obj.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
        }
        
        if obj.strTimeAgo.contains("hours"){
            let strTxt = obj.strTimeAgo.split(separator: " ")
            cell.lblTime.text = "Hace \(strTxt[0]) horas"
        }else if obj.strTimeAgo.contains("minutes"){
            let strTxt = obj.strTimeAgo.split(separator: " ")
            cell.lblTime.text = "Hace \(strTxt[0]) minutos"
        }else if obj.strTimeAgo.contains("seconds"){
            let strTxt = obj.strTimeAgo.split(separator: " ")
            cell.lblTime.text = "Hace \(strTxt[0]) segundos"
        }else{
            let strTxt = obj.strTimeAgo.split(separator: " ")
            cell.lblTime.text = "Hace \(strTxt[0]) dias"
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewController")as! ChatDetailViewController
        vc.strUserName = self.arrMessageList[indexPath.row].strName
        vc.strUserImage = self.arrMessageList[indexPath.row].strUserImage
        vc.strSenderID = self.arrMessageList[indexPath.row].strSenderID
        vc.isBlocked = self.arrMessageList[indexPath.row].strIsBlocked
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
}

//MARK:- Call Webservice Chat List
extension ChatViewController{
    
    func call_GetChatList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["receiver_id":strUserID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getConversationList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    self.arrMessageList.removeAll()
                    for dictdata in arrData{
                        let obj = ConversationListModel.init(dict: dictdata)
                        self.arrMessageList.append(obj)
                    }
                    
                    self.arrMessageList.reverse()
                    
                    if self.arrMessageList.count == 0{
                        self.tblMessage.displayBackgroundText(text: "No tienes mensajes")
                    }else{
                        self.tblMessage.displayBackgroundText(text: "")
                    }
                    
                    self.tblMessage.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.tblMessage.reloadData()
                    self.tblMessage.displayBackgroundText(text: "No tienes mensajes")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}
