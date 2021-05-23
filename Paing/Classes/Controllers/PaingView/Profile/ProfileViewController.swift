//
//  ProfileViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var vwPhotosDigonal: UIView!
    @IBOutlet var vwVideoDigonal: UIView!
    @IBOutlet var vwAboutDigonal: UIView!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var imgVwBtnSelected: UIImageView!
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imgVwBtnSelected.image = #imageLiteral(resourceName: "one_blue")
    }
    
    //MARK: - Action Methods
    
    @IBAction func btnPhoto(_ sender: Any) {
        self.imgVwBtnSelected.image = #imageLiteral(resourceName: "one_blue")
    }
    @IBAction func btnVideo(_ sender: Any) {
        self.imgVwBtnSelected.image = #imageLiteral(resourceName: "two_blue")
    }
    @IBAction func btnAboutUs(_ sender: Any) {
        self.imgVwBtnSelected.image = #imageLiteral(resourceName: "thr_blue")
    }
    
    @IBAction func actionSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
}
