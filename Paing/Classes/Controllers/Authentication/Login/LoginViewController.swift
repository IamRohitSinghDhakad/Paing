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
    
    @IBAction func actionLogin(_ sender: Any) {
        AppSharedData.sharedObject().isLoggedIn = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
//        let navController = UINavigationController(rootViewController: vc)
        appDelegate.window?.rootViewController = vc
    }
    
    
}
