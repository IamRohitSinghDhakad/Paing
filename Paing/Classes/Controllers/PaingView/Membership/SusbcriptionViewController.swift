//
//  SusbcriptionViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 18/06/21.
//

import UIKit

class SusbcriptionViewController: UIViewController {

    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var vwContainFirstPlan: UIView!
    @IBOutlet var vwContainSecondPlan: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let profilePic = objAppShareData.UserDetail.strProfilePicture
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo_square"))
        }
        
    }
    
    
    @IBAction func btnPlanFirstSelect(_ sender: Any) {
        self.vwContainFirstPlan.borderColor = UIColor.init(named: "AppSkyBlue")
        self.vwContainSecondPlan.borderColor = UIColor.lightGray
    }
    
    @IBAction func btnPlanSecondSelect(_ sender: Any) {
        self.vwContainSecondPlan.borderColor = UIColor.init(named: "AppSkyBlue")
        self.vwContainFirstPlan.borderColor = UIColor.lightGray
    }
    
    @IBAction func btnPlanPurchased(_ sender: Any) {
        
    }
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
}
