//
//  PaingBlogViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class PaingBlogViewController: UIViewController {
    
    //MARK: - Override Methods
    @IBOutlet var tblBlogs: UITableView!
    @IBOutlet var btnPostPublicBlogs: UIButton!
    @IBOutlet var btnMyBlogs: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblBlogs.delegate = self
        self.tblBlogs.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Action Methods
    @IBAction func actionSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func actionBtnMyBlogs(_ sender: Any) {
        
    }
    
    @IBAction func actionBtnPublicBlogs(_ sender: Any) {
    }
    
}


extension PaingBlogViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblBlogs.dequeueReusableCell(withIdentifier: "PaingBlogTableViewCell")as! PaingBlogTableViewCell
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
