//
//  CommentVideoViewController.swift
//  Paing
//
//  Created by Paras on 27/07/21.
//

import UIKit

class CommentVideoViewController: UIViewController,FeedFetchProtocol {
   
    
   
    

    //MARK:- IBOutlets
    @IBOutlet var tblComments: UITableView!
    @IBOutlet var btnDeleteComment: UIButton!
    @IBOutlet var txtVwChat: SZTextView!
    @IBOutlet var hgtConsMaximum: NSLayoutConstraint!
    @IBOutlet var hgtConsMinimum: NSLayoutConstraint!
    @IBOutlet var btnSendTextMessage: UIButton!
    
    
    let txtViewCommentMaxHeight: CGFloat = 100
    let txtViewCommentMinHeight: CGFloat = 34
    var arrComment = [CommentDataModel]()
    var isComingFrom: String?
   // var isComingFrom = ""
    var objUserData = BlogListModel(dict: [:])
    var index = Int()
    var objVC:FeedFetchDelegate?
    var delegate: FeedFetchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblComments.delegate = self
        self.tblComments.dataSource = self
        
        self.txtVwChat.delegate = self
        self.txtVwChat.delegate = self
        
        self.btnDeleteComment.isHidden = true
        
    }
    
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnDeleteComment(_ sender: Any) {
        let filtered = self.arrComment.filter { $0.isSelected == true }
        if filtered.count > 0{
            var arrID = [String]()
            for data in filtered{
                arrID.append(data.strVideoCommentID)
            }
            print(arrID)
            let allSelectedID = arrID.joined(separator: ",")
            if allSelectedID != ""{
                self.call_DeleteVideoBlogComment(strCommentID: allSelectedID)
            }
        }
    }
    

    @IBAction func btnOnSendComment(_ sender: Any) {
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
                self.sendMessageNew(strVideoID: self.objUserData.strVideoID, strUserID: objAppShareData.UserDetail.strUserId)
            }
            if self.txtVwChat.text.count > 0{
                self.txtVwChat.isScrollEnabled = false
                
            }else{
                self.txtVwChat.isScrollEnabled = false
            }
        }
        
    }
    
}



//MARK:- UItextViewHeightManage
extension CommentVideoViewController: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 150
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
      
    
    
    func sendMessageNew(strVideoID:String,strUserID:String){
        self.txtVwChat.isScrollEnabled = false
        self.txtVwChat.contentSize.height = self.txtViewCommentMinHeight
        self.txtVwChat.text = self.txtVwChat.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.txtVwChat.text == "" {
           // AppSharedClass.shared.showAlert(title: "Alert", message: "Please enter some text", view: self)
            return
        }else{
            let strText = self.txtVwChat.text!.encodeEmoji
            self.call_AddVideoComment(strVideoID: strVideoID, strUserID: strUserID, strComment: strText)
            
           //asd self.call_WSSendMessage(strSenderID: self.getSenderID, strMessage: self.txtVwChat.text)
        }
        self.txtVwChat.text = ""
    }
    
}


//MARK:- UITablewVie Delegate and DataSource
extension CommentVideoViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.arrComment.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentLikesTableViewCell")as! CommentLikesTableViewCell
            
            let obj = self.arrComment[indexPath.row]
            
            let profilePic = obj.strCommentUserImage
            if profilePic != "" {
                let url = URL(string: profilePic)
                cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
            }
            
            cell.lblMsgComment.text = obj.strComment.decodeEmoji
            
            if objUserData.strBlogUserID == objAppShareData.UserDetail.strUserId{
                if obj.isSelected == true{
                    cell.imgVwTick.image = #imageLiteral(resourceName: "select")
                }else{
                    cell.imgVwTick.image = #imageLiteral(resourceName: "tic_unselect")
                }
            }else{
                if obj.strCommentUserID == objAppShareData.UserDetail.strUserId{
                    if obj.isSelected == true{
                        cell.imgVwTick.image = #imageLiteral(resourceName: "select")
                    }else{
                        cell.imgVwTick.image = #imageLiteral(resourceName: "tic_unselect")
                    }
                }else{
                    cell.imgVwTick.image = nil
                }
            }
            
            let filtered = self.arrComment.filter { $0.isSelected == true }
           if filtered.count > 0{
               self.btnDeleteComment.isHidden = false
           }else{
               self.btnDeleteComment.isHidden = true
           }
            
            cell.btnOnProfile.tag = indexPath.row
            cell.btnOnProfile.addTarget(self, action: #selector(btnGoToProfile), for: .touchUpInside)
            
            return cell
            
        
    }
    
    @objc func btnGoToProfile(sender: UIButton){
        print(sender.tag)
        
//        let userID = self.arrComment[sender.tag].strCommentUserID
//        if objAppShareData.UserDetail.strUserId == userID{
//        }else{
//            let vc = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
//            vc?.userID = userID
//            self.navigationController?.pushViewController(vc!, animated: true)
//        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tblComments{
            
            let obj = self.arrComment[indexPath.row]
            
            if objUserData.strBlogUserID == objAppShareData.UserDetail.strUserId{
                if obj.isSelected == true{
                    obj.isSelected = false
                }else{
                    obj.isSelected = true
                }
            }else{
                if obj.strCommentUserID == objAppShareData.UserDetail.strUserId{
                    if obj.isSelected == true{
                        obj.isSelected = false
                    }else{
                        obj.isSelected = true
                    }
                }else{
            }
        }
        self.tblComments.reloadData()
        }
    }
    
    
}


extension CommentVideoViewController{
    //Add Comment
    func call_AddVideoComment(strVideoID:String, strUserID:String, strComment:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["comment":strComment,
                         "video_id":strVideoID,
                         "user_id":strUserID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_addVideoComment, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if message == "success"{
                    self.fetchFeeds()
                  //  self.call_GetBlogList(strUserID: strUserID)
                }else{
                    objAlert.showAlert(message: "Something went Wrong", title: "Alert", controller: self)
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    //Delete Notification
    func call_DeleteVideoBlogComment(strCommentID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["video_comment_id":strCommentID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_deleteVideoComment, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                self.btnDeleteComment.isHidden = true
                self.fetchFeeds()
              //  self.call_GetBlogList(strUserID: objAppShareData.UserDetail.strUserId)
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    func fetchFeeds() {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
          //  objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["my_id":objAppShareData.UserDetail.strUserId]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getVideos, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                 //   self.arrBlogList.removeAll()
                   var arrBlogList = [BlogListModel]()
                    for dictdata in arrData{
                        
                        let obj = BlogListModel.init(dict: dictdata)
                        if self.isComingFrom == "MyVideos"{
                            if objAppShareData.UserDetail.strUserId == obj.strBlogUserID{
                                arrBlogList.append(obj)
                            }else{
                                //Do Nothing
                            }
                        }else{
                            arrBlogList.append(obj)
                        }
                    }
                    
                    if arrData.count > 0{
                        
                        self.arrComment.removeAll()
                        
                        let newData = arrData[self.index]
                        
                        if let commentData = newData["comments_data"] as? [[String:Any]]{
                            for dictData in commentData{
                                let obj = CommentDataModel.init(dict: dictData)
                                self.arrComment.append(obj)
                            }
                        }
                        
                    }
                    

                    
                    self.objVC?.feedFetchService(self, didFetchFeeds: arrBlogList, withError: nil)
                    
                    self.tblComments.reloadData()
                  
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                  //  self.tblBLogs.displayBackgroundText(text: "Aún no publicas ningún blog")
                }else{
                   // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}
