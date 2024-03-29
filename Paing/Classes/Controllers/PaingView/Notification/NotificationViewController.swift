//
//  NotificationViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class NotificationViewController: UIViewController {
    
    //MARK: - Override Methods
    @IBOutlet var vwDelete: UIView!
    @IBOutlet var tblVwNotification: UITableView!
    
    var arrNotifications = [NotificationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblVwNotification.delegate = self
        self.tblVwNotification.dataSource = self
        // Do any additional setup after loading the view.
        self.vwDelete.isHidden = true
        
        //Refresh Counter
        UserDefaults.standard.setValue(0, forKey: "badge")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.call_GetNotification(strUserId: objAppShareData.UserDetail.strUserId)
    }
    
    //MARK: - Action Methods
    
    @IBAction func actionSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func actionDeleteNotification(_ sender: Any) {
        let filtered = self.arrNotifications.filter { $0.isSelected == true }
        if filtered.count > 0{
            var arrID = [String]()
            for data in filtered{
                arrID.append(data.strNotificationID)
            }
             let allSelectedID = arrID.joined(separator: ",")
            if allSelectedID != ""{
                self.call_DeleteNotification(strNotificationID: allSelectedID)
            }
        }
    }
    
}

//MARK:- UitableviewDelegate and DataSorce
extension NotificationViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell")as! NotificationTableViewCell
        
        let obj = self.arrNotifications[indexPath.row]
        
        let profilePic = obj.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo_square"))
        }
        
        if obj.strType == "video"{
            cell.lblMsg.text = obj.strName + " le gustó tu video."
        }else if obj.strType == "Sticker"{
            cell.lblMsg.text = obj.strName + " te envía un duende."
        }else if obj.strType == "image"{
            if obj.strNotificationTitle.contains("sent an Image") {
                cell.lblMsg.text = obj.strName + " te envió una imagen"
            } else {
                cell.lblMsg.text = obj.strName + " le gustó tu foto."
            }
        }else if obj.strType == "profile_like" {
            cell.lblMsg.text = obj.strName + " le gustó tu perfil."
        }else if obj.strType == "Text"{
            cell.lblMsg.text = obj.strName + " te envió un mensaje"
        }else if obj.strType == "Image" {
            cell.lblMsg.text = obj.strName + " te envió una imagen"
        }else if obj.strType == "Liked" {
            cell.lblMsg.text = obj.strName + " te Agregó a favoritos."
        }else if obj.strType == "image_like" {
            cell.lblMsg.text = obj.strName + " le gustó tu foto."
        }else if obj.strType == "blog_like" {
            cell.lblMsg.text = obj.strName + " le gustó tu blog"
        }else if obj.strType == "blog_comment" {
            cell.lblMsg.text = obj.strName + " comentó en su blog"
        }else if obj.strType == "admin"{
            cell.lblMsg.text =  obj.strNotificationTitle + " \(obj.strNotificationAdmin)."
        }else if obj.strType == "video_like"{
            cell.lblMsg.text = obj.strName + " le gustó tu VideoTop"
        }else if obj.strType == "video_comment"{
            cell.lblMsg.text = obj.strName  + " comentó en su VideoTop"
        }else{
            cell.lblMsg.text = obj.strName + " te Agregó a favoritos."
        }
        
        if obj.isSelected{
            cell.imgVwCheckUncheck.image = UIImage.init(named: "select")
        }else{
            cell.imgVwCheckUncheck.image = UIImage.init(named: "tic_unselect")
        }
        let filtered = self.arrNotifications.filter { $0.isSelected == true }
        if filtered.count > 0{
            self.vwDelete.isHidden = false
        }else{
            self.vwDelete.isHidden = true
        }
        
        cell.btnCheckUncheck.tag = indexPath.row
        cell.btnCheckUncheck.addTarget(self, action: #selector(btnCheckUncheckAction), for: .touchUpInside)
        
        cell.btnOpenProfile.tag = indexPath.row
        cell.btnOpenProfile.addTarget(self, action: #selector(btnGoToProfile), for: .touchUpInside)
        
      
        return cell
    }
    

    @objc func btnGoToProfile(sender: UIButton){
        print(sender.tag)
        let obj = self.arrNotifications[sender.tag]
        if obj.strType == "admin"{
            
        }else{
            let userID = self.arrNotifications[sender.tag].strUserID
            if objAppShareData.UserDetail.strUserId == userID{
            }else{
                let vc = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
                vc?.userID = userID
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
    

    @objc func btnCheckUncheckAction(sender: UIButton){
        let obj = self.arrNotifications[sender.tag]
        if obj.isSelected == true{
            obj.isSelected = false
        }else{
            obj.isSelected = true
        }
        self.tblVwNotification.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let obj = self.arrNotifications[indexPath.row]
//        if obj.isSelected == true{
//            obj.isSelected = false
//        }else{
//            obj.isSelected = true
//        }
//        self.tblVwNotification.reloadData()
    }
}


extension NotificationViewController{
    
    func call_GetNotification(strUserId:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserId]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getNotification, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    self.arrNotifications.removeAll()
                    
                    for dictdata in arrData{
                        let obj = NotificationModel.init(dict: dictdata)
                        self.arrNotifications.append(obj)
                    }
                    self.tblVwNotification.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.tblVwNotification.displayBackgroundText(text: "Aún no tienes ninguna notificación")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
                
               // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    //Delete Notification
    
    func call_DeleteNotification(strNotificationID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["notification_id":strNotificationID,"user_id":objAppShareData.UserDetail.strUserId]as [String:Any]
        
        print(parameter)
        objWebServiceManager.requestGet(strURL: WsUrl.url_DeleteNotification, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                self.call_GetNotification(strUserId: objAppShareData.UserDetail.strUserId)
                
//                if let arrData  = response["result"] as? [[String:Any]]{
//                    for dictdata in arrData{
//                        let obj = NotificationModel.init(dict: dictdata)
//                        self.arrNotifications.append(obj)
//                    }
//                    self.tblVwNotification.reloadData()
//                }
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
