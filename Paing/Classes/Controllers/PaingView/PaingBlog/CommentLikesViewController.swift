//
//  CommentLikesViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 03/06/21.
//

import UIKit

class CommentLikesViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblMsgText: UILabel!
    @IBOutlet var lblCommentCount: UILabel!
    @IBOutlet var lblLikeCount: UILabel!
    @IBOutlet var imgVwLike: UIImageView!
    
    @IBOutlet var tblComments: UITableView!
    @IBOutlet var tblLikes: UITableView!
    @IBOutlet var vwLikeSubVw: UIView!
    @IBOutlet var lblLikeSubVwCount: UILabel!
    @IBOutlet var btnDeleteComment: UIButton!
    @IBOutlet var lblAgeGender: UILabel!
    
    @IBOutlet var txtVwChat: SZTextView!
    @IBOutlet var hgtConsMaximum: NSLayoutConstraint!
    @IBOutlet var hgtConsMinimum: NSLayoutConstraint!
    @IBOutlet var btnSendTextMessage: UIButton!
    
    //Variables
    
    let txtViewCommentMaxHeight: CGFloat = 100
    let txtViewCommentMinHeight: CGFloat = 34
    
    var arrBlogList = [BlogListModel]()
    var arrComment = [CommentDataModel]()
    var arrLike = [LikedDataModel]()
    var arrSelectdIDFor = [Int]()
    
    var objUserData = BlogListModel(dict: [:])
    
    var strBlogID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblLikes.delegate = self
        self.tblLikes.dataSource = self
        
        self.tblComments.delegate = self
        self.tblComments.dataSource = self
        
        self.txtVwChat.delegate = self
        self.txtVwChat.delegate = self
        
        self.vwLikeSubVw.isHidden = true
        self.btnDeleteComment.isHidden = true
    
        self.setupUserData()
        
        self.call_GetBlogList(strUserID: objAppShareData.UserDetail.strUserId)
        
        // Do any additional setup after loading the view.
    }
    
    func setupUserData(){
        
        let profilePic = objUserData.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
        }
        
        self.lblUserName.text = objUserData.strName
        
        let emojiString  = objUserData.strBlogText.decodeEmoji
        self.lblMsgText.text = emojiString
        
        if objUserData.strGender == "Male"{
            self.lblAgeGender.text = "Hombre, \(objUserData.strAge)"
        }else{
            self.lblAgeGender.text = "Mujer, \(objUserData.strAge)"
        }
        
        
        if objUserData.strLikeStatus == "1"{
            self.imgVwLike.image = #imageLiteral(resourceName: "like")
        }else{
            self.imgVwLike.image = #imageLiteral(resourceName: "emptyHeart")
        }
        
        if objUserData.strLikeCount == ""{
            self.lblLikeCount.text = "(0)"
        }else{
            self.lblLikeCount.text = "(\(objUserData.strLikeCount))"
        }
        
        if objUserData.strCommentCount == ""{
            self.lblCommentCount.text = "(0)"
        }else{
            self.lblCommentCount.text = "(\(objUserData.strCommentCount))"
        }
        
    }
    
    @IBAction func btnOnprofile(_ sender: Any) {
        
        let userID = self.objUserData.strBlogUserID
        if objAppShareData.UserDetail.strUserId == userID{
        }else{
            let vc = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
            vc?.userID = userID
            self.navigationController?.pushViewController(vc!, animated: true)
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
                self.sendMessageNew(strBlogID: self.objUserData.strBlogId, strUserID: objAppShareData.UserDetail.strUserId)
            }
            if self.txtVwChat.text.count > 0{
                self.txtVwChat.isScrollEnabled = false
                
            }else{
                self.txtVwChat.isScrollEnabled = false
            }
        }
        
    }
    
    @IBAction func btnOpenLikeSubVw(_ sender: Any) {
        self.vwLikeSubVw.isHidden = false
    }
    
    @IBAction func btnCloseLikeSubVw(_ sender: Any) {
        self.vwLikeSubVw.isHidden = true
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
    @IBAction func btnDeleteComment(_ sender: Any) {
        let filtered = self.arrComment.filter { $0.isSelected == true }
        if filtered.count > 0{
            var arrID = [String]()
            for data in filtered{
                arrID.append(data.strCommentID)
            }
            let allSelectedID = arrID.joined(separator: ",")
            if allSelectedID != ""{
                self.call_DeleteBlogComment(strCommentID: allSelectedID)
            }
        }
    }
    
}

//MARK:- UItextViewHeightManage
extension CommentLikesViewController: UITextViewDelegate{
    
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
      
    
    
    func sendMessageNew(strBlogID:String,strUserID:String){
        self.txtVwChat.isScrollEnabled = false
        self.txtVwChat.contentSize.height = self.txtViewCommentMinHeight
        self.txtVwChat.text = self.txtVwChat.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.txtVwChat.text == "" {
           // AppSharedClass.shared.showAlert(title: "Alert", message: "Please enter some text", view: self)
            return
        }else{
            let strText = self.txtVwChat.text!.encodeEmoji
            self.call_AddBlogComment(strBlogID: strBlogID, strUserID: strUserID, strComment: strText)
            
           //asd self.call_WSSendMessage(strSenderID: self.getSenderID, strMessage: self.txtVwChat.text)
        }
        self.txtVwChat.text = ""
    }
    
}

//MARK:- UITablewVie Delegate and DataSource
extension CommentLikesViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblComments{
            return self.arrComment.count
        }else{
            return self.arrLike.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblComments{
            
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
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTableViewCell")as! LikesTableViewCell
            
            let obj = self.arrLike[indexPath.row]
            
            let profilePic = obj.strLikedUserImage
            if profilePic != "" {
                let url = URL(string: profilePic)
                cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
            }
            
            cell.lblName.text = obj.strLikedName
            
            return cell
        }
    }
    
    @objc func btnGoToProfile(sender: UIButton){
        print(sender.tag)
        
        let userID = self.arrComment[sender.tag].strCommentUserID
        if objAppShareData.UserDetail.strUserId == userID{
        }else{
            let vc = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
            vc?.userID = userID
            self.navigationController?.pushViewController(vc!, animated: true)
        }
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
        }else if tableView == self.tblLikes{
            
            let userID = self.arrLike[indexPath.row].strLikedID
            if objAppShareData.UserDetail.strUserId == userID{
            }else{
                let vc = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
                vc?.userID = userID
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
    
    
}


extension CommentLikesViewController{
    //Add Comment
    func call_AddBlogComment(strBlogID:String, strUserID:String, strComment:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["comment":strComment,
                         "blog_id":strBlogID,
                         "user_id":strUserID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_addBlogComment, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if message == "success"{
                    
                    self.call_GetBlogList(strUserID: strUserID)
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
    func call_DeleteBlogComment(strCommentID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["blog_comment_id":strCommentID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_DeleteBlogComment, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                self.call_GetBlogList(strUserID: objAppShareData.UserDetail.strUserId)
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}


//RefreshComments
//MARK:- Call Webservice Blog List
extension CommentLikesViewController{
    
    func call_GetBlogList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        //blog_id//my_id
        let parameter = ["my_id":strUserID,
                         "blog_id":self.objUserData.strBlogId]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getBlogList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    
                    if arrData.count > 0{
                        
                        self.arrComment.removeAll()
                        self.arrLike.removeAll()
                        
                        let newData = arrData[0]
                        
                        if let commentData = newData["comments_data"] as? [[String:Any]]{
                            for dictData in commentData{
                                let obj = CommentDataModel.init(dict: dictData)
                                self.arrComment.append(obj)
                            }
                        }
                        
                        self.lblCommentCount.text = "(\(self.arrComment.count))"
                        
                        if let commentData = newData["likes_data"] as? [[String:Any]]{
                            for dictData in commentData{
                                let obj = LikedDataModel.init(dict: dictData)
                                self.arrLike.append(obj)
                            }
                        }
                        
                    }else{
                        
                    }
                    
                    self.tblComments.reloadData()
                    self.tblLikes.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                   // self.tblBlogs.displayBackgroundText(text: "ningún record fue encontrado")
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

