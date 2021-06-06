//
//  LoginViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Override Methods
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var btnHideShowPassword: UIButton!
    @IBOutlet var subVw: UIView!
    @IBOutlet var lblTitleSubVw: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tfEmail.delegate = self
        self.tfPassword.delegate = self
        
        self.subVw.isHidden = true
        
    }
    
    //MARK: - Action Methods
    @IBAction func btnActionValidationSubVw(_ sender: Any) {
        self.subVw.isHidden = true
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        self.validateForSignUp()
    }
    
    @IBAction func actionForgotPassword(_ sender: Any) {
        pushVc(viewConterlerId: "ForgotPasswordViewController")
    }
    
    @IBAction func actionRegistration(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionShowPassword(_ sender: Any) {
        self.tfPassword.isSecureTextEntry = self.tfPassword.isSecureTextEntry ? false : true
    }
    
    @IBAction func actionDismissEmailVerificationPopup(_ sender: Any) {
        self.subVw.isHidden = true
    }
    
    
}

//MARK:- Validations
extension LoginViewController{
    // TextField delegate method
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfEmail{
            self.tfPassword.becomeFirstResponder()
            self.tfEmail.resignFirstResponder()
        }
        else if textField == self.tfPassword{
            self.tfPassword.resignFirstResponder()
        }
        return true
        
    }
    
}

extension LoginViewController{
    
    //MARK:- All Validations
    func validateForSignUp(){
        self.view.endEditing(true)
        self.tfEmail.text = self.tfEmail.text!.trim()
        self.tfPassword.text = self.tfPassword.text!.trim()
        if (tfEmail.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }else if !objValidationManager.validateEmail(with: tfEmail.text!){
            objAlert.showAlert(message: MessageConstant.ValidEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfPassword.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankPassword, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else{
            self.call_WsLogin()
        }
    }
}


//MARK:- Call Webservice

extension LoginViewController{
    
    func call_WsLogin(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["username":self.tfEmail.text!,
                         "password":self.tfPassword.text!,
                         "ios_register_id":objAppShareData.strFirebaseToken]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_Login, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            //  print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                    let isEmailVerified = user_details["email_verified"] as! String
                    if isEmailVerified == "0" {
                        //Show Email Verification Popup
                        self.subVw.isHidden = false
                    }
                    else {
                        print(user_details)
                        objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                        objAppShareData.fetchUserInfoFromAppshareData()
                        self.pushVc(viewConterlerId: "DemoViewController")
                    }
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "Alert", controller: self)
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




