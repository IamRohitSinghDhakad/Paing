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
    
    
    var arrBlogList = [BlogListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblBlogs.delegate = self
        self.tblBlogs.dataSource = self
        // Do any additional setup after loading the view.
        
        self.call_GetBlogList(strUserID: objAppShareData.UserDetail.strUserId)
    }
    
    //MARK: - Action Methods
    @IBAction func actionSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func actionBtnMyBlogs(_ sender: Any) {
        
    }
    
    @IBAction func actionBtnPublicBlogs(_ sender: Any) {
    }
    
}


extension PaingBlogViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBlogList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblBlogs.dequeueReusableCell(withIdentifier: "PaingBlogTableViewCell")as! PaingBlogTableViewCell
        
        let obj = self.arrBlogList[indexPath.row]
        
        let profilePic = obj.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
        }
        
        cell.lblUserName.text = obj.strName
        cell.lblMessage.text = obj.strBlogText
        
        if obj.strGender == "Male"{
            cell.lblAge.text = "Hombre, \(obj.strAge)"
        }else{
            cell.lblAge.text = "Mujer, \(obj.strAge)"
        }
        
        if obj.strLikeCount == ""{
            cell.lblLikeCount.text = "(0)"
        }else{
            cell.lblLikeCount.text = "(\(obj.strLikeCount)"
        }
        
        if obj.strCommentCount == ""{
            cell.lblCommentCount.text = "(0)"
        }else{
            cell.lblCommentCount.text = "(\(obj.strCommentCount)"
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}


//MARK:- Call Webservice Blog List
extension PaingBlogViewController{
    
    func call_GetBlogList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getBlogList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    
                    for dictdata in arrData{
                        let obj = BlogListModel.init(dict: dictdata)
                        self.arrBlogList.append(obj)
                    }
                    
                    self.tblBlogs.reloadData()
                }
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
