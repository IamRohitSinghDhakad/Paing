//
//  WelcomeViewController.swift
//  Paing
//
//  Created by Akshada on 23/05/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwFooter: UIView!
    
    var isAnimated: Bool = false
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.vwHeader.frame = CGRect(x: self.vwHeader.frame.origin.x, y: -(UIScreen.main.bounds.size.height/2), width: self.vwHeader.frame.size.width, height: self.vwHeader.frame.size.height)
        self.vwFooter.frame = CGRect(x: -(UIScreen.main.bounds.size.width/2), y: self.vwFooter.frame.origin.y, width: self.vwFooter.frame.size.width, height: self.vwFooter.frame.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isAnimated {
            isAnimated = true
            moveHeaderDown()
        }
    }
    
    //MARK: - Animation Methods
    
    func moveHeaderDown() {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveLinear], animations: {
            self.vwHeader.frame = CGRect(x: self.vwHeader.frame.origin.x, y: 0, width: self.vwHeader.frame.size.width, height: self.vwHeader.frame.size.height)
            self.vwFooter.frame = CGRect(x: 0, y: self.vwFooter.frame.origin.y, width: self.vwFooter.frame.size.width, height: self.vwFooter.frame.size.height)
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: 1, delay: 0.0, options: [.curveEaseIn], animations: {
                    self.vwHeader.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
                }) { (finished) in
                    UIView.animate(withDuration: 1, animations: {
                        self.vwHeader.transform = CGAffineTransform.identity
                    })
                }
            }
        }
    }
    
    //MARK: - Action Methods
    
    @IBAction func actionLoginWithFB(_ sender: Any) {
        
    }
    
    @IBAction func actionLoginWithGmail(_ sender: Any) {
        
    }
    
    @IBAction func actionLoginWithEmail(_ sender: Any) {
        pushVc(viewConterlerId: "LoginViewController")
    }
    
    @IBAction func actionGoToRegistration(_ sender: Any) {
       pushVc(viewConterlerId: "RegistrationViewController")
   //     let vc = (self.authStoryboard.instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController)!
     //   self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
