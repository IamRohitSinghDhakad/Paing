//
//  NotificationViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class NotificationViewController: UIViewController {
    
    //MARK: - Override Methods
    @IBOutlet var vwDelete: UIView!
    @IBOutlet var tblVwNotification: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblVwNotification.delegate = self
        self.tblVwNotification.dataSource = self
        // Do any additional setup after loading the view.
        self.vwDelete.isHidden = true
    }
    
    //MARK: - Action Methods
    
    @IBAction func actionSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
}

//MARK:- UitableviewDelegate and DataSorce
extension NotificationViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell")as! NotificationTableViewCell
        
        cell.imgVw.image = #imageLiteral(resourceName: "logo")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.vwDelete.isHidden = false
    }
    
    
}
