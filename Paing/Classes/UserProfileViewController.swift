//
//  UserProfileViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 22/05/21.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet var vwPhotosDigonal: UIView!
    @IBOutlet var vwVideoDigonal: UIView!
    @IBOutlet var vwAboutDigonal: UIView!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var imgVwBtnSelected: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgVwBtnSelected.image = #imageLiteral(resourceName: "one_blue")
        
      //  self.vwPhotosDigonal.draw(<#T##rect: CGRect##CGRect#>)
        // Do any additional setup after loading the view.
    }
    

  
    @IBAction func btnPhoto(_ sender: Any) {
        self.imgVwBtnSelected.image = #imageLiteral(resourceName: "one_blue")
    }
    @IBAction func btnVideo(_ sender: Any) {
        self.imgVwBtnSelected.image = #imageLiteral(resourceName: "two_blue")
    }
    @IBAction func btnAboutUs(_ sender: Any) {
        self.imgVwBtnSelected.image = #imageLiteral(resourceName: "thr_blue")
    }
    
}


class CustomViewFirst: UIView {

// Only override draw() if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
override func draw(_ rect: CGRect) {
   // Drawing code
   // Get Height and Width
   let layerHeight = layer.frame.height
   let layerWidth = layer.frame.width
   // Create Path
   let bezierPath = UIBezierPath()
   //  Points
   let pointA = CGPoint(x: layerWidth, y: 0) // bottom left corner
   let pointB = CGPoint(x: layerWidth, y: 0) // top middle
   let pointC = CGPoint(x: 0, y: layerHeight) // top right corner
   let pointD = CGPoint(x: 0, y:0) // bottom right corner
   // Draw the path
   bezierPath.move(to: pointA)
   bezierPath.addLine(to: pointB)
   bezierPath.addLine(to: pointC)
   bezierPath.addLine(to: pointD)
   bezierPath.close()
   // Mask to Path
   let shapeLayer = CAShapeLayer()
   shapeLayer.path = bezierPath.cgPath
   layer.mask = shapeLayer
  }
}


class CustomViewCenter: UIView {

// Only override draw() if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
override func draw(_ rect: CGRect) {
   // Drawing code
   // Get Height and Width
   let layerHeight = layer.frame.height
   let layerWidth = layer.frame.width
   // Create Path
   let bezierPath = UIBezierPath()
   //  Points
   let pointA = CGPoint(x: -20, y: 60) // bottom left corner
   let pointB = CGPoint(x: 40, y: 0) // top middle
   let pointC = CGPoint(x: layerWidth, y: 0) // top right corner
   let pointD = CGPoint(x: layerWidth, y:layerHeight) // bottom right corner
   // Draw the path
   bezierPath.move(to: pointA)
   bezierPath.addLine(to: pointB)
   bezierPath.addLine(to: pointC)
   bezierPath.addLine(to: pointD)
   bezierPath.close()
   // Mask to Path
   let shapeLayer = CAShapeLayer()
   shapeLayer.path = bezierPath.cgPath
   layer.mask = shapeLayer
  }
}

class CustomViewLast: UIView {

// Only override draw() if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
override func draw(_ rect: CGRect) {
   // Drawing code
   // Get Height and Width
   let layerHeight = layer.frame.height
   let layerWidth = layer.frame.width
   // Create Path
   let bezierPath = UIBezierPath()
   //  Points
   let pointA = CGPoint(x: -20, y: 60) // bottom left corner
   let pointB = CGPoint(x: 40, y: 0) // top middle
   let pointC = CGPoint(x: layerWidth, y: 0) // top right corner
   let pointD = CGPoint(x: layerWidth, y:layerHeight) // bottom right corner
   // Draw the path
   bezierPath.move(to: pointA)
   bezierPath.addLine(to: pointB)
   bezierPath.addLine(to: pointC)
   bezierPath.addLine(to: pointD)
   bezierPath.close()
   // Mask to Path
   let shapeLayer = CAShapeLayer()
   shapeLayer.path = bezierPath.cgPath
   layer.mask = shapeLayer
  }
}
