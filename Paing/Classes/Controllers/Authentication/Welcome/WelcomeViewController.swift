//
//  WelcomeViewController.swift
//  Paing
//
//  Created by Akshada on 23/05/21.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices


struct SocialLoginParameter {
    //    Call<ResponseBody> socialsignup(@Query("name") String name,
    //    @Query("email") String email,
    //    @Query("social_id") String social_id,
    //    @Query("social_type") String social_type,
    //    @Query("register_id") String register_id);
    var name: String = ""
    var email: String = ""
    var social_id: String = ""
    var social_type: String = ""
    var register_id: String = ""
    
}

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwFooter: UIView!
    @IBOutlet var vwSub: UIView!
    
    
    var isAnimated: Bool = false
    var isAccepted = ""
    
    let loginManager = LoginManager()
    var isFBLogin : Bool {
        get {
            if let token = AccessToken.current, !token.isExpired {
                // User is logged in, do work such as go to next view controller.
                return true
            }
            return false
        }
    }
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.vwSub.isHidden = true
        self.vwHeader.frame = CGRect(x: self.vwHeader.frame.origin.x, y: -(UIScreen.main.bounds.size.height/2), width: self.vwHeader.frame.size.width, height: self.vwHeader.frame.size.height)
        self.vwFooter.frame = CGRect(x: -(UIScreen.main.bounds.size.width/2), y: self.vwFooter.frame.origin.y, width: self.vwFooter.frame.size.width, height: self.vwFooter.frame.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let isCheck = UserDefaults.standard.value(forKey: "isPolicyCheck")as? String{
            isAccepted = isCheck
        }else{
            isAccepted = "0"
        }
        
        self.vwSub.isHidden = true
        if !isAnimated {
            isAnimated = true
            moveHeaderDown()
        }
    }
    
    //MARK: - Animation Methods
    
    func moveHeaderDown() {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveLinear], animations: {
            self.vwHeader.frame = CGRect(x: self.vwHeader.frame.origin.x, y: 0, width: self.vwHeader.frame.size.width, height: self.vwHeader.frame.size.height)
            self.vwFooter.frame = CGRect(x: 0, y: self.vwFooter.frame.origin.y, width: self.vwFooter.frame.size.width, height: self.vwFooter.frame.size.height)
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: 1, delay: 0.0, options: [.curveEaseIn], animations: {
                    self.vwHeader.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
                }) { (finished) in
                    UIView.animate(withDuration: 1, animations: {
                        self.vwHeader.transform = CGAffineTransform.identity
                    })
                }
            }
        }
    }
    
    //MARK: - Action Methods
    
    @IBAction func actionLoginWithFB(_ sender: Any) {
        
        if isAccepted == "1"{
            
            if !objWebServiceManager.isNetworkAvailable(){
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
                return
            }
            if let accessToken = AccessToken.current, !accessToken.isExpired {
                // User is logged in, do work such as go to next view controller.
                self.getFBUserDetails()
            }
            else {
                // Access token not available -- user already logged out
                // Perform log in
                loginManager.logIn(permissions: [Permission.publicProfile.name, Permission.email.name], from: self) { (result, error) in
                    // Check for error
                    guard error == nil else {
                        // Error occurred
                        return
                    }
                    
                    // Check for cancel
                    guard let result = result, !result.isCancelled else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        // Successfully logged in
                        print("Result: \(result)\n\nError: \(error)\n\n")
                        self.getFBUserDetails()
                    }
                    
                }
            }
        }else{
            self.pushVc(viewConterlerId: "AcceptTermsViewController")
        }
      
    }
    
    @IBAction func actionLoginWithGmail(_ sender: Any) {
        
        if isAccepted == "1"{
            
            GIDSignIn.sharedInstance().presentingViewController = self
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().signIn()
            
        }else{
            self.pushVc(viewConterlerId: "AcceptTermsViewController")
        }
        
       
    }
    
    @IBAction func actionSignInApple(_ sender: Any) {
        self.view.endEditing(true)
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            //  authorizationController.delegate = self
            // Create an authorization controller with the given requests.
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }

    }
    
    
    @IBAction func actionLoginWithEmail(_ sender: Any) {
        
        if isAccepted == "1"{
            pushVc(viewConterlerId: "LoginViewController")
        }else{
            self.pushVc(viewConterlerId: "AcceptTermsViewController")
        }
        
    }
    
    @IBAction func actionGoToRegistration(_ sender: Any) {
        
        if isAccepted == "1"{
            self.pushVc(viewConterlerId: "RegistrationViewController")
        }else{
            self.pushVc(viewConterlerId: "AcceptTermsViewController")
        }
        
        
        //     let vc = (self.authStoryboard.instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController)!
        //   self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionDismissVerifyEmailPopup(_ sender: Any) {
        self.vwSub.isHidden = true
    }
    
}

//MARK: - FB Graph API

extension WelcomeViewController {
    func getFBUserDetails() {
        let request = GraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,first_name,last_name,picture.type(large),gender,birthday"], tokenString: AccessToken.current!.tokenString, version: Settings.graphAPIVersion, httpMethod: .get)
        request.start { (graphRequestConnection, result, error) in
            guard error == nil else {
                // Error occurred
                print("Process error: \(error!.localizedDescription)")
                objAlert.showAlert(message: error!.localizedDescription, title: "Alert", controller: self)
                return
            }
            if let userData = result as? [String:AnyObject] {
                print("User Data: \(userData)")
                if let name = userData["name"] as? String, let email = userData["email"] as? String, let social_id = userData["id"] as? String {
                    let social_type = "fb"
                    let register_id = objAppShareData.strFirebaseToken
                    var socialMediaParam = SocialLoginParameter()
                    socialMediaParam.name = name
                    socialMediaParam.email = email
                    socialMediaParam.social_id = social_id
                    socialMediaParam.social_type = social_type
                    socialMediaParam.register_id = register_id
                    self.call_WsSocialLogin(socialMediaParam: socialMediaParam)
                }
                
            }
        }
    }
}

//MARK: - Google Sign In Delegate

extension WelcomeViewController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
                objAlert.showAlert(message: "The user has not signed in before or they have since signed out.", title: "Alert", controller: self)
            } else {
                print("\(error.localizedDescription)")
                objAlert.showAlert(message: error.localizedDescription, title: "Alert", controller: self)
            }
            return
        }
        if let userdata = user {
            //            let idToken = userdata.authentication.idToken
            let social_type = "google"
            let register_id = objAppShareData.strFirebaseToken
            var socialMediaParam = SocialLoginParameter()
            socialMediaParam.name = userdata.profile.name
            socialMediaParam.email = userdata.profile.email
            socialMediaParam.social_id = userdata.userID
            socialMediaParam.social_type = social_type
            socialMediaParam.register_id = register_id
            self.call_WsSocialLogin(socialMediaParam: socialMediaParam)
        }
    }
}

//MARK:- Apple login
@available(iOS 13.0, *)
extension WelcomeViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            var socialMediaParam = SocialLoginParameter()
            var firstName = ""
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            _ = appleIDCredential.fullName
            if let email = appleIDCredential.email{
                socialMediaParam.email = email
            }
            if let givenName = appleIDCredential.fullName?.givenName{
                firstName = givenName
            }
            if let familyName = appleIDCredential.fullName?.familyName{
                socialMediaParam.name = firstName + " " + familyName
            }
            
            print(socialMediaParam.email)
            print(socialMediaParam.name)
            print(userIdentifier)
            
            socialMediaParam.social_id = userIdentifier
            socialMediaParam.social_type = "Apple"
            socialMediaParam.register_id = objAppShareData.strFirebaseToken
            
            self.call_WsSocialLogin(socialMediaParam: socialMediaParam)
            
            
        case let passwordCredential as ASPasswordCredential:
            
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                // self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
}

//MARK:- Call Webservice

extension WelcomeViewController{
    
    func call_WsSocialLogin(socialMediaParam: SocialLoginParameter){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        //        @POST("social_login")
        //            Call<ResponseBody> socialsignup(@Query("name") String name,
        //                                            @Query("email") String email,
        //                                            @Query("social_id") String social_id,
        //                                            @Query("social_type") String social_type,
        //                                            @Query("register_id") String register_id);
        
        let dicrParam = ["name": socialMediaParam.name, "email": socialMediaParam.email, "social_id": socialMediaParam.social_id, "social_type": socialMediaParam.social_type, "ios_register_id": socialMediaParam.register_id] as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_SocialLogin, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
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
                objWebServiceManager.hideIndicator()
                if let user_details  = response["result"] as? [String:Any] {
//                    let isEmailVerified = user_details["email_verified"] as! String
//                    if isEmailVerified == "0" {
//                        //Show Email Verification Popup
//                        self.vwSub.isHidden = false
//                    }
//                    else {
                        print(user_details)
                        objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                        objAppShareData.fetchUserInfoFromAppshareData()
                        self.pushVc(viewConterlerId: "DemoViewController")
//                    }
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
