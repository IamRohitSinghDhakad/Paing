//
//  MyBlogViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 03/06/21.
//

import UIKit


class MyBlogViewController: UIViewController {
    
    @IBOutlet var tblBLogs: UITableView!
    @IBOutlet var SubVw: UIView!
    @IBOutlet var btnCancelSubVw: UIButton!
    @IBOutlet var imgVwuser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblAgeGender: UILabel!
    @IBOutlet var txtVwComment: SZTextView!
    @IBOutlet var btnSubmit: UIButton!
    
    
    var arrBlogList = [BlogListModel]()
    var isComingFromEdit = Bool()
    var editBlogId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.tblBLogs.delegate = self
        self.tblBLogs.dataSource = self
        // Do any additional setup after loading the view.
        self.SubVw.isHidden = true
        self.call_GetBlogList(strUserID: objAppShareData.UserDetail.strUserId)
    }
    @IBAction func btnCloseSubVw(_ sender: Any) {
        self.txtVwComment.text = ""
        self.SubVw.isHidden = true
    }
    
    @IBAction func btnSubmitBlog(_ sender: Any) {
        
        if self.arrBlogList.count > 1{
            objAlert.showAlert(message: "Solo puedospublicar 2 blogs en 24 horas.", title: "Alert", controller: self)
        }else{
            if ((self.txtVwComment.text?.isEmpty) != nil){
                
                let strText = self.txtVwComment.text!.encodeEmoji
                if self.isComingFromEdit{
                    self.call_EditBlog(strUserID: objAppShareData.UserDetail.strUserId, strText: strText, strBlogID: self.editBlogId)
                }else{
                    self.call_AddBlog(strUserID: objAppShareData.UserDetail.strUserId, strText: strText)
                }
            }
        }
    }
    @IBAction func btnCancelSubVw(_ sender: Any) {
        self.SubVw.isHidden = true
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
        
    }
    
    @IBAction func btnAddMyBlog(_ sender: Any) {
        self.txtVwComment.text = ""
        let profilePic = objAppShareData.UserDetail.strProfilePicture
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwuser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
        }
        
        self.lblUserName.text = objAppShareData.UserDetail.strUserName
        
        if objAppShareData.UserDetail.strGender == "Male"{
            self.lblAgeGender.text = "Hombre, \(objAppShareData.UserDetail.strAge)"
        }else{
            self.lblAgeGender.text = "Mujer, \(objAppShareData.UserDetail.strAge)"
        }
        self.isComingFromEdit = false
        self.SubVw.isHidden = false
        
    }
    
}

//UITextView Delegates
extension MyBlogViewController:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newText = textView.text!
        newText.removeAll { (character) -> Bool in
            return character == " " || character == "\n"
        }

        return (newText.count + text.count) <= 150
    }
}

//MARK:- UitableVie Delegates and DataSource
extension MyBlogViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBlogList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblBLogs.dequeueReusableCell(withIdentifier: "PaingBlogTableViewCell")as! PaingBlogTableViewCell
        
        let obj = self.arrBlogList[indexPath.row]
        
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
        
        cell.btnComment.tag = indexPath.row
        cell.btnComment.addTarget(self, action: #selector(btnCommentAction), for: .touchUpInside)
        
        cell.btnMenuDot.tag = indexPath.row
        cell.btnMenuDot.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(btnLikeAction), for: .touchUpInside)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func btnCommentAction(sender: UIButton){
        print(sender.tag)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentLikesViewController")as! CommentLikesViewController
        vc.objUserData = self.arrBlogList[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func buttonSelected(sender: UIButton){
        print(sender.tag)
        
        self.openActionSheet(index: sender.tag)
    }
    
    @objc func btnLikeAction(sender: UIButton){
        print(sender.tag)
        let strBlogID = self.arrBlogList[sender.tag].strBlogId
        self.call_LikeBlog(strUserID: objAppShareData.UserDetail.strUserId, blogID: strBlogID)
    }
    
    func openActionSheet(index:Int){
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Editar", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
            self.isComingFromEdit = true
            self.editBlogId = self.arrBlogList[index].strBlogId
            
            self.SubVw.isHidden = false
            let strText = self.arrBlogList[index].strBlogText.decodeEmoji
            self.txtVwComment.text = strText
            let profilePic = self.arrBlogList[index].strUserImage
            if profilePic != "" {
                let url = URL(string: profilePic)
                self.imgVwuser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
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


//MARK:-
//MARK:- Call Webservice Add Blogs
extension MyBlogViewController{
    
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
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    self.arrBlogList.removeAll()
                    for dictdata in arrData{
                        
                        let obj = BlogListModel.init(dict: dictdata)
                        if objAppShareData.UserDetail.strUserId == obj.strBlogUserID{
                            self.arrBlogList.append(obj)
                        }else{
                            //Do Nothing
                        }
                        
                    }
                    
                    if self.arrBlogList.count == 0{
                        self.tblBLogs.displayBackgroundText(text: "ningún record fue encontrado")
                    }else{
                        self.tblBLogs.displayBackgroundText(text: "")
                    }
                    
                    self.tblBLogs.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.tblBLogs.displayBackgroundText(text: "ningún record fue encontrado")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    //=============Add Blog =================//
    
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
                    self.tblBLogs.displayBackgroundText(text: "ningún record fue encontrado")
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
                    self.tblBLogs.displayBackgroundText(text: "ningún record fue encontrado")
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
                    self.tblBLogs.displayBackgroundText(text: "ningún record fue encontrado")
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
                    self.tblBLogs.displayBackgroundText(text: "ningún record fue encontrado")
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
