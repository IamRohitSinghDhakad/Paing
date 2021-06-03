//
//  BlockedViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class BlockedViewController: UIViewController {
    
    
    @IBOutlet var tblBlockList: UITableView!
    
    
    var arrBlocklist = [BlockModel]()
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblBlockList.delegate = self
        self.tblBlockList.dataSource = self

        self.call_GetBlockList(strUserID: objAppShareData.UserDetail.strUserId)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Action Methods
    @IBAction func actionSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    
}

//MARK:- Uitablevie datasource and delegates
extension BlockedViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrBlocklist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockListTableViewCell")as! BlockListTableViewCell
        
        let obj = self.arrBlocklist[indexPath.row]
        
        cell.lblUsername.text = obj.strName
        
        cell.lblOtherDetails.text = "\(obj.strAge) Años,\(obj.strGender)"
        
        let profilePic = obj.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
        }
      
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let strBlockID = self.arrBlocklist[indexPath.row].strChatId
        let strName = self.arrBlocklist[indexPath.row].strName
        
        objAlert.showAlertCallBack(alertLeftBtn: "no", alertRightBtn: "sí", title: "Alerta", message: "¿Quieres desbloquear a \(strName)?", controller: self) {
            self.call_GetUnblockUser(strUserID: objAppShareData.UserDetail.strUserId, strBLockerID: strBlockID, indexPath: indexPath.row)
        }
    }
    
}



//MARK:- Call Webservice Block List
extension BlockedViewController{
    
    func call_GetBlockList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getBlockList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{
                        let obj = BlockModel.init(dict: dictdata)
                        self.arrBlocklist.append(obj)
                    }
                    
                    self.tblBlockList.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.tblBlockList.displayBackgroundText(text: "ningún record fue encontrado")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    //UnblockUser
    
    func call_GetUnblockUser(strUserID:String,strBLockerID:String,indexPath:Int){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID,
                         "id":strBLockerID]as [String:Any]
        
        print(parameter)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getBlockUnblock, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                self.arrBlocklist.remove(at: indexPath)
                
                if let arrData  = response["result"] as? [[String:Any]]{
                }
                
                if self.arrBlocklist.count == 0{
                    self.tblBlockList.displayBackgroundText(text: "ningún record fue encontrado")
                }else{
                    self.tblBlockList.displayBackgroundText(text: "")
                }
                
                self.tblBlockList.reloadData()
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.tblBlockList.displayBackgroundText(text: "ningún record fue encontrado")
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
