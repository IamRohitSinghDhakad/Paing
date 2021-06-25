//
//  AcceptTermsViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 14/06/21.
//

import UIKit

class AcceptTermsViewController: UIViewController {

    private let arrOptions: [String] = ["Política de privacidad","Condiciones de uso", "Cookies"]
    
    @IBOutlet var imgvwCheckUnCheck: UIImageView!
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgvwCheckUnCheck.image = #imageLiteral(resourceName: "Square")
        
        self.tblView.delegate = self
        self.tblView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCheckPrivacyPolicy(_ sender: Any) {
        
        if self.imgvwCheckUnCheck.image == #imageLiteral(resourceName: "Square"){
            
            self.imgvwCheckUnCheck.image = #imageLiteral(resourceName: "checked")
        }else{
            self.imgvwCheckUnCheck.image = #imageLiteral(resourceName: "Square")
        }
    }
    
    @IBAction func btnAcceptPrivacyPolicy(_ sender: Any) {
        
        if self.imgvwCheckUnCheck.image == #imageLiteral(resourceName: "checked"){
            
            UserDefaults.standard.setValue("1", forKey: "isPolicyCheck")
            self.onBackPressed()
            
        }else{
            
            objAlert.showAlert(message: "Acepte los Términos y Condiciones para continuar.", title: "", controller: self)
            
        }
        
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
}


extension AcceptTermsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AcceptTermsTableViewCell")as! AcceptTermsTableViewCell
        
        cell.lblTitle.text = self.arrOptions[indexPath.row]

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
             let vc = self.authStoryboard.instantiateViewController(withIdentifier: "ShowTermsAndPricavyViewController") as! ShowTermsAndPricavyViewController
             vc.strType = "Política de privacidad"
             self.navigationController?.pushViewController(vc, animated: true)
        case 1:
             let vc = self.authStoryboard.instantiateViewController(withIdentifier: "ShowTermsAndPricavyViewController") as! ShowTermsAndPricavyViewController
             vc.strType = "Condiciones de uso"
             self.navigationController?.pushViewController(vc, animated: true)
        case 2:
             let vc = self.authStoryboard.instantiateViewController(withIdentifier: "ShowTermsAndPricavyViewController") as! ShowTermsAndPricavyViewController
             vc.strType = "Cookies"
             self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
    
    
    
    
    
}
