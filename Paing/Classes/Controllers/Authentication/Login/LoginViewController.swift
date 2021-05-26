//
//  LoginViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: - Action Methods
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        AppSharedData.sharedObject().isLoggedIn = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
    
    @IBAction func actionForgotPassword(_ sender: Any) {
        pushVc(viewConterlerId: "ForgotPasswordViewController")
    }
    
    @IBAction func actionRegistration(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
