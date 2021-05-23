//
//  ChatViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class ChatViewController: UIViewController {
    
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
