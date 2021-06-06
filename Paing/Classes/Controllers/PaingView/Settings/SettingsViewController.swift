//
//  SettingsViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let settingOptions: [String] = ["Información básica", "Compartir aplicación", "Aviso legal", "Política de privacidad","Condiciones de uso", "Cookies", "Contáctenos", "Configuración", "Ayuda", "Cerrar Sesión"]
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: - Action Methods
    @IBAction func actionSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        let row = indexPath.row
        cell.settingLbl.text = self.settingOptions[row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row

        
        switch row {
        case 0:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
            vc.isComingFrom = "Basic Information"
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            self.pushVc(viewConterlerId: "ShareAppViewController")
        case 2:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            vc.strType = "Aviso legal"
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            vc.strType = "Política de privacidad"
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            vc.strType = "Condiciones de uso"
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            vc.strType = "Cookies"
            self.navigationController?.pushViewController(vc, animated: true)
        case 6:
            self.pushVc(viewConterlerId: "ContactUsViewController")
       //     let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
        //    vc.strType = "Contáctenos"
        //    self.navigationController?.pushViewController(vc, animated: true)
        case 7:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            vc.strType = "Configuración"
            self.navigationController?.pushViewController(vc, animated: true)
        case 8:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            vc.strType = "Ayuda"
            self.navigationController?.pushViewController(vc, animated: true)
            
        case self.settingOptions.count - 1:
            objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "si", title: "Cerrar Sesión", message: "¿Quieres cerrar sesión??", controller: self) {
                self.call_WSLogout(strUserID: objAppShareData.UserDetail.strUserId)
            }
        default:
            break
        }
        
//        if (row == 0) {
//            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "BasicInformationViewController") as! BasicInformationViewController
////            let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingNavigation") as! UINavigationController
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        else if (row == (self.settingOptions.count - 1)) {
//            objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: "Sign off", message: "Do you want to log out?", controller: self) {
//                AppSharedData.sharedObject().signOut()
//            }
//        }
    }
    
}

extension SettingsViewController{
    
    //MARK:- Call WebService
    
    func call_WSLogout(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":strUserID,
                        ]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_Logout, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                
                AppSharedData.sharedObject().signOut()
                
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
