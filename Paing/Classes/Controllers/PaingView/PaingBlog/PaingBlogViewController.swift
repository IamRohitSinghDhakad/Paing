//
//  PaingBlogViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class PaingBlogViewController: UIViewController {
    
    //MARK: - Override Methods
    @IBOutlet var tblBlogs: UITableView!
    @IBOutlet var btnPostPublicBlogs: UIButton!
    @IBOutlet var btnMyBlogs: UIButton!
    
    @IBOutlet var subVw: UIView!
    @IBOutlet var imgVwUserSubVw: UIImageView!
    @IBOutlet var lblUserNameSubVw: UILabel!
    @IBOutlet var lblAgeGenderSubVw: UILabel!
    @IBOutlet var txtVwCommentSubVw: SZTextView!
    
    var arrBlogList = [BlogListModel]()
    var isComingFromEdit = Bool()
    var editBlogId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblBlogs.delegate = self
        self.tblBlogs.dataSource = self
        // Do any additional setup after loading the view.
        self.txtVwCommentSubVw.delegate = self
        self.subVw.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.call_GetBlogList(strUserID: objAppShareData.UserDetail.strUserId)
    }
    
    //SUbVwAction
    @IBAction func btnCloseSubVw(_ sender: Any) {
        self.subVw.isHidden = true
        self.txtVwCommentSubVw.text = ""
    }
    
    @IBAction func btnSendBlogSubVw(_ sender: Any) {
        self.txtVwCommentSubVw.text = self.txtVwCommentSubVw.text.trim()
        if ((self.txtVwCommentSubVw.text?.isEmpty) != nil){
            
            let strText = self.txtVwCommentSubVw.text!.encodeEmoji
            if self.isComingFromEdit{
                self.call_EditBlog(strUserID: objAppShareData.UserDetail.strUserId, strText: strText, strBlogID: self.editBlogId)
            }else{
                self.call_AddBlog(strUserID: objAppShareData.UserDetail.strUserId, strText: strText)
            }
            
        }
        
    }
    
    
    //MARK: - Action Methods
    @IBAction func actionSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func actionBtnMyBlogs(_ sender: Any) {
        self.pushVc(viewConterlerId: "MyBlogViewController")
    }
    
    @IBAction func actionBtnPublicBlogs(_ sender: Any) {
        
        let filtert = self.arrBlogList.filter({$0.strBlogUserID == objAppShareData.UserDetail.strUserId})
        
        if filtert.count > 1{
            objAlert.showAlert(message: "Solo puedes publicar 2 blogs en 24 horas.", title: "Alert", controller: self)
        }else{
            self.txtVwCommentSubVw.text = ""
            let profilePic = objAppShareData.UserDetail.strProfilePicture
            if profilePic != "" {
                let url = URL(string: profilePic)
                self.imgVwUserSubVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
            }
            
            self.lblUserNameSubVw.text = objAppShareData.UserDetail.strUserName
            
            if objAppShareData.UserDetail.strGender == "Male"{
                self.lblAgeGenderSubVw.text = "Hombre, \(objAppShareData.UserDetail.strAge)"
            }else{
                self.lblAgeGenderSubVw.text = "Mujer, \(objAppShareData.UserDetail.strAge)"
            }
            
            self.subVw.isHidden = false
        }
    }
}

//Edit Blog Action Sheet
extension PaingBlogViewController{
    //MARK:- Cell Btn Edit Blog Action
    @objc func btnEditBlog(sender: UIButton){
        self.editBlogId = self.arrBlogList[sender.tag].strBlogId
        self.openActionSheet(index: sender.tag)
    }
    
    
    func openActionSheet(index:Int){
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Editar", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
            self.isComingFromEdit = true
            self.editBlogId = self.arrBlogList[index].strBlogId
            
            self.subVw.isHidden = false
            let strText = self.arrBlogList[index].strBlogText.decodeEmoji
            self.txtVwCommentSubVw.text = strText
            let profilePic = self.arrBlogList[index].strUserImage
            if profilePic != "" {
                let url = URL(string: profilePic)
                self.imgVwUserSubVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
            }
            
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Borrar", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
            let strBlogID = self.arrBlogList[index].strBlogId
            self.call_DeleteBlog(strUserID: objAppShareData.UserDetail.strUserId, blogID: strBlogID)
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: { (action) -> Void in
            
        }))
        self.present(actionsheet, animated: true, completion: nil)
    }
}

//UITextView Delegates
extension PaingBlogViewController:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newText = textView.text!
        newText.removeAll { (character) -> Bool in
            return character == " " || character == "\n"
        }

        return (newText.count + text.count) <= 150
    }
}


extension PaingBlogViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBlogList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblBlogs.dequeueReusableCell(withIdentifier: "PaingBlogTableViewCell")as! PaingBlogTableViewCell
        
        let obj = self.arrBlogList[indexPath.row]
        
        if obj.strBlogUserID == objAppShareData.UserDetail.strUserId{
            cell.btnMenuDot.isHidden = false
            cell.imgVwThreeDot.isHidden = false
        }else{
            cell.btnMenuDot.isHidden = true
            cell.imgVwThreeDot.isHidden = true
        }
        
        let profilePic = obj.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
        }
        
        cell.lblUserName.text = obj.strName
        
        let emojiString  = obj.strBlogText.decodeEmoji
        cell.lblMessage.text = emojiString
        
        if obj.strGender == "Male"{
            cell.lblAge.text = "Hombre, \(obj.strAge)"
        }else{
            cell.lblAge.text = "Mujer, \(obj.strAge)"
        }
        
        if obj.strLikeCount == ""{
            cell.lblLikeCount.text = "(0)"
        }else{
            cell.lblLikeCount.text = "(\(obj.strLikeCount))"
        }
        
        if obj.strCommentCount == ""{
            cell.lblCommentCount.text = "(0)"
        }else{
            cell.lblCommentCount.text = "(\(obj.strCommentCount))"
        }
        print(obj.strLikeStatus)
        if obj.strLikeStatus == "0"{
            cell.imgVwLike.image = #imageLiteral(resourceName: "heart")
        }else{
            cell.imgVwLike.image = #imageLiteral(resourceName: "fav")
        }
        
        cell.btnMenuDot.tag = indexPath.row
        cell.btnMenuDot.addTarget(self, action: #selector(btnEditBlog), for: .touchUpInside)
        
        cell.btnOnProfile.tag = indexPath.row
        cell.btnOnProfile.addTarget(self, action: #selector(btnGoToProfile), for: .touchUpInside)
        
        cell.btnComment.tag = indexPath.row
        cell.btnComment.addTarget(self, action: #selector(btnCommentAction), for: .touchUpInside)
        
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(btnLikeAction), for: .touchUpInside)
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    @objc func btnGoToProfile(sender: UIButton){
        print(sender.tag)
        
        let userID = self.arrBlogList[sender.tag].strBlogUserID
        if objAppShareData.UserDetail.strUserId == userID{
        }else{
            let vc = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
            vc?.userID = userID
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    
    @objc func btnCommentAction(sender: UIButton){
        print(sender.tag)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentLikesViewController")as! CommentLikesViewController
        vc.objUserData = self.arrBlogList[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnLikeAction(sender: UIButton){
        print(sender.tag)
        let strBlogID = self.arrBlogList[sender.tag].strBlogId
        self.call_LikeBlog(strUserID: objAppShareData.UserDetail.strUserId, blogID: strBlogID)
    }
    
    
}


//MARK:- Call Webservice Blog List
extension PaingBlogViewController{
    
    //================ Get Blog =================//
    
    func call_GetBlogList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["my_id":strUserID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getBlogList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            self.subVw.isHidden = true
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    self.arrBlogList.removeAll()
                    for dictdata in arrData{
                        let obj = BlogListModel.init(dict: dictdata)
                        self.arrBlogList.append(obj)
                    }
                    
                    if self.arrBlogList.count == 0{
                        self.tblBlogs.displayBackgroundText(text: "no tienes blogs")
                    }else{
                        self.tblBlogs.displayBackgroundText(text: "")
                    }
                    
                    
                    self.tblBlogs.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.tblBlogs.displayBackgroundText(text: "no tienes blogs")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    //================ ADD Blog ================//
    
    func call_AddBlog(strUserID:String, strText:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID,
                         "text":strText]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_AddBlogInList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                self.call_GetBlogList(strUserID: strUserID)
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.tblBlogs.displayBackgroundText(text: "ningún record fue encontrado")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    //=============== Edit Blog ==============//
    func call_EditBlog(strUserID:String, strText:String, strBlogID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["blog_id":strBlogID,
                         "text":strText]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_AddBlogInList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{

                self.call_GetBlogList(strUserID: strUserID)
                
                
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.tblBlogs.displayBackgroundText(text: "ningún record fue encontrado")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    //===============  Delete Blog =============//
     func call_DeleteBlog(strUserID:String, blogID:String){
         
         if !objWebServiceManager.isNetworkAvailable(){
             objWebServiceManager.hideIndicator()
             objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
             return
         }
         
         objWebServiceManager.showIndicator()
         
         let parameter = ["user_id":strUserID,
                          "blog_id":blogID]as [String:Any]
         
         
         objWebServiceManager.requestGet(strURL: WsUrl.url_DeleteBlogInList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
             objWebServiceManager.hideIndicator()
             let status = (response["status"] as? Int)
             let message = (response["message"] as? String)
             
             print(response)
             
             if status == MessageConstant.k_StatusCode{

                 self.call_GetBlogList(strUserID: strUserID)
                 
             }else{
                 objWebServiceManager.hideIndicator()
                 
                 if (response["result"]as? String) != nil{
                     self.tblBlogs.displayBackgroundText(text: "!no tienes blogs")
                 }else{
                     objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                 }
             }
         } failure: { (Error) in
             print(Error)
             objWebServiceManager.hideIndicator()
         }
     }
    
    //=================== Like Blog ==================//
    func call_LikeBlog(strUserID:String, blogID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID,
                         "blog_id":blogID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_likeBlog, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{

                self.call_GetBlogList(strUserID: strUserID)
                
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.tblBlogs.displayBackgroundText(text: "ningún record fue encontrado")
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





extension String {
    var decodeEmoji: String{
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
}

extension String {
    var encodeEmoji: String{
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
            return encodeStr as String
        }
        return self
    }
}
