//
//  BasicInformationViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    //MARK: - Override Methods
    @IBOutlet var tblContactUs: UITableView!
    
    var arrOptions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblContactUs.delegate = self
        self.tblContactUs.dataSource = self
        
        self.arrOptions = ["Contacto","Privacidad", "Sugerencias", "Denunciar perfil"]
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    //MARK: - Action Methods
}


extension ContactUsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell")as! SettingsTableViewCell
        
        cell.settingLbl.text = self.arrOptions[indexPath.row]

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
             let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
             vc.strType = "Contáctenos"
             self.navigationController?.pushViewController(vc, animated: true)
        case 1:
             let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
             vc.strType = "Privacidad"
             self.navigationController?.pushViewController(vc, animated: true)
        case 2:
             let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
             vc.strType = "Sugerencias"
             self.navigationController?.pushViewController(vc, animated: true)
        case 3:
             let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
             vc.strType = "Denunciar perfil"
             self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
    
    
    
    
    
}
