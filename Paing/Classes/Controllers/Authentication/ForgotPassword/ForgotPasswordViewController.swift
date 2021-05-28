//
//  ForgotPasswordViewController.swift
//  Paing
//
//  Created by Akshada on 23/05/21.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    //MARK: - Override Methods
    @IBOutlet var tfEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: - Action Methods
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionResetPassword(_ sender: Any) {
        self.tfEmail.text = self.tfEmail.text?.trim()
        if self.tfEmail.text != ""{
            self.call_WsForgotPassword()
        }
    }
}

//MARK:- Call Webservice Forgot Password
extension ForgotPasswordViewController{
    
    func call_WsForgotPassword(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["email":self.tfEmail.text!]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_forgotPassword, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            var statusCode = Int()
            if let status = (response["status"] as? Int){
                statusCode = status
            }else  if let status = (response["status"] as? String){
                statusCode = Int(status)!
            }
            
            let message = (response["message"] as? String)
            print(response)
            if statusCode == MessageConstant.k_StatusCode{
                
                objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "Alert", message: message ?? "Your request sent succesfully.", controller: self) {
                    self.onBackPressed()
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
    
}
