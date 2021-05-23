//
//  ViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 20/05/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imgVwAnimation: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        imgVwAnimation.backgroundColor = UIColor.blue
        //self.view.addSubview(imgVwAnimation)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Up()


    }
    @IBAction func btnNext(_ sender: Any) {
        self.pushVc(viewConterlerId: "UserProfileViewController")
    }
    
    func bottom()  {

        UIView.animate(withDuration: 3.0, delay: 0.2, options: [.curveEaseInOut], animations: {
         //   self.imgVwAnimation.frame = CGRect(x: 0, y: 500.0, width: 300.0, height: 300.0)
        }) { (finished) in
            if finished {
                // Repeat animation from bottom to top
                //self.Up()
            }
        }
    }

    func Up()  {

        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseIn], animations: {
            self.imgVwAnimation.frame = CGRect(x: UIScreen.main.bounds.size.width*0.2, y: 0, width: 250, height: 250)
          //  self.imgVwAnimation.frame = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
        }) { (finished) in
            if finished {
                self.imgVwAnimation.tilt()
                // Repeat animation to bottom to top
               // self.bottom()
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.goToNextController()
                }
            }
        }

    }
    
    func goToNextController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if AppSharedData.sharedObject().isLoggedIn {
            let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
//            let navController = UINavigationController(rootViewController: vc)
            appDelegate.window?.rootViewController = vc
        }
        else {
            let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController)!
            let navController = UINavigationController(rootViewController: vc)
            appDelegate.window?.rootViewController = navController
        }
    }

}

extension UIView {
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func tilt() {
        /// Plus Animation Duration
        let plusAnimationDuration : TimeInterval = 0.05
        /// Minus Animation Duration
        let minusAnimationDuration : TimeInterval = 0.05
        /// Zero Animation Duration
        let zeroAnimationDuration : TimeInterval = 0.05
        
        /// Plus Degree
        let degrees : CGFloat = 10.0
        /// Minus Degree
        let minusDegree : CGFloat = -10.0
        /// Zero Degree
        let zeroDegree : CGFloat = 0
        
        let plusRadian : CGFloat = degrees * CGFloat((Double.pi/180))
        let minusRadian : CGFloat = minusDegree * CGFloat((Double.pi/180))
        let zeroRadian : CGFloat = zeroDegree * CGFloat((Double.pi/180))
        
        /// First Animation To make View Goes clockwise
        UIView.animate(withDuration: plusAnimationDuration, animations: {
            self.transform = CGAffineTransform(rotationAngle: plusRadian)
        }) { (success) in
            /// Second Animation to make view go antiClockWise
            UIView.animate(withDuration: minusAnimationDuration, animations: {
                self.transform = CGAffineTransform(rotationAngle: minusRadian)
            }) { (success) in
                /// Second Animation to make view go antiClockWise
                UIView.animate(withDuration: zeroAnimationDuration, animations: {
                    self.transform = CGAffineTransform(rotationAngle: zeroRadian)
                })
            }
        }
    }
}
