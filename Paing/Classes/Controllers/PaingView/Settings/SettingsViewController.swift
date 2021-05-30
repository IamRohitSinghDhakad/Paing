//
//  SettingsViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let settingOptions: [String] = ["Basic information", "Share application", "Legal Warning", "Privacy Policy","Terms of use", "Cookies", "Contact Us", "Setting", "Help", "Sign Off"]
    
    /*
     case "ContactUs 6":
         self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Contact")
     case "Privacy 3":
         self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Privacy")
     case "Suggestion 2":
         self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Suggestions")
     case "ReportProfile":
         self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Report%20profile")
     case "LegalWarning 2":
         self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Legal%20warning")
     case "Terms&Service 4":
         self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Terms%20of%20use")
     case "Cookies 5":
         self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Cookies")
     case "Help 8":
         self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Help")
     case "Settings 7":
         self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/setting")
     case "PricacyPolicy 3":
     **/
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
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            vc.strType = "Privacy"
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            vc.strType = "Suggestion"
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            vc.strType = "PricacyPolicy"
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            vc.strType = "Terms&Service"
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            vc.strType = "Cookies"
            self.navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            vc.strType = "ContactUs"
            self.navigationController?.pushViewController(vc, animated: true)
        case 7:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            vc.strType = "Settings"
            self.navigationController?.pushViewController(vc, animated: true)
        case 8:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            vc.strType = "Help"
            self.navigationController?.pushViewController(vc, animated: true)
            
        case self.settingOptions.count - 1:
            objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: "Sign off", message: "Do you want to log out?", controller: self) {
                AppSharedData.sharedObject().signOut()
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
