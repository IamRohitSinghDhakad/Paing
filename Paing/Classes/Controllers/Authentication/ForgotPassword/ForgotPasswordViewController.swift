//
//  ForgotPasswordViewController.swift
//  Paing
//
//  Created by Akshada on 23/05/21.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: - Action Methods
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionResetPassword(_ sender: Any) {
    }
    
    
}
