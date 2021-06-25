//
//  FavoriteViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 05/06/21.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet var tblFavorite: UITableView!
    
    var arrFavList = [FavoriteModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblFavorite.delegate = self
        self.tblFavorite.dataSource = self
        
        self.call_GetFavoriteList(strUserID: objAppShareData.UserDetail.strUserId)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
    
}

extension FavoriteViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFavList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell")as! FavoriteTableViewCell
        
        let obj = self.arrFavList[indexPath.row]
        
        let profilePic = obj.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
        }
        
        cell.lblUserName.text = obj.strName
        
        if obj.strGender == "Male"{
            cell.lblAgeGender.text = "\(obj.strAge) Años, Hombre"
        }else{
            cell.lblAgeGender.text = "\(obj.strAge) Años, Mujer"
        }
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(btnDeleteAction), for: .touchUpInside)
        
        cell.btnGoToProfile.tag = indexPath.row
        cell.btnGoToProfile.addTarget(self, action: #selector(btnGoToProfile), for: .touchUpInside)
        
        return cell
        
    }
    
    
    @objc func btnGoToProfile(sender: UIButton){
        print(sender.tag)
        
        let userID = self.arrFavList[sender.tag].strOpponentUserID
        if objAppShareData.UserDetail.strUserId == userID{
        }else{
            let vc = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
            vc?.userID = userID
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    @objc func btnDeleteAction(sender: UIButton){
        print(sender.tag)
        let id = self.arrFavList[sender.tag].strOpponentUserID
        self.call_MarkUserFavorite(strMyUserID: objAppShareData.UserDetail.strUserId, strAnotherUserID: id)
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
}


//Call WebService Favorite List

extension FavoriteViewController{
    
    func call_GetFavoriteList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_FavoriteList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    self.arrFavList.removeAll()
                    for dictdata in arrData{
                        let obj = FavoriteModel.init(dict: dictdata)
                        self.arrFavList.append(obj)
                    }
                    self.tblFavorite.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.arrFavList.removeAll()
                    self.tblFavorite.reloadData()
                    self.tblFavorite.displayBackgroundText(text: "No tienes perfiles favoritos")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }

    //UnFavorite
    // MARK:- Mark User Favorite
    
    func call_MarkUserFavorite(strMyUserID:String,strAnotherUserID:String) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
      
        
        let parameter = ["user_id" : objAppShareData.UserDetail.strUserId,
                         "id" : strAnotherUserID,
                         "liked" : "0"] as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_SaveInFavorite, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                self.call_GetFavoriteList(strUserID: strMyUserID)
                
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


