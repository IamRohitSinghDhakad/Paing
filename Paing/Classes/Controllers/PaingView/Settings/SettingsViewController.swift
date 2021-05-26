//
//  SettingsViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let settingOptions: [String] = ["Basic information", "Share application", "Legal Warning", "Privacy Policy","Terms of use", "Cookies", "Contact Us", "Setting", "Help", "Sign Off"]
    
    
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
        if (row == 0) {
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "BasicInformationViewController") as! BasicInformationViewController
//            let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingNavigation") as! UINavigationController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (row == (self.settingOptions.count - 1)) {
            objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: "Sign off", message: "Do you want to log out?", controller: self) {
                AppSharedData.sharedObject().signOut()
            }
        }
    }
    
}
