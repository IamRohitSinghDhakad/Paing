//
//  ChatViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class ChatViewController: UIViewController {
    
    //MARK: - Override Methods
    @IBOutlet var tblMessage: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tblMessage.delegate = self
        self.tblMessage.dataSource = self
        
        
    }
    
    //MARK: - Action Methods
    
    @IBAction func actionSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
}


extension ChatViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell")as! MessageTableViewCell
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
}
