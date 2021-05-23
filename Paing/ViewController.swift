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
                
                self.imgVwAnimation.shake()
                // Repeat animation to bottom to top
               // self.bottom()
            }
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
}
