//
//  OverLayCard.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 22/05/21.
//

import UIKit
import Koloda

private let overlayRightImageName = "yesOverlayImage"
private let overlayLeftImageName = "noOverlayImage"

class OverlayViewCard: OverlayView {

    @IBOutlet var lblAge: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgVw: UIImageView!
    
    class func createMyClassView() -> OverlayViewCard? {
        let myClassNib = UINib(nibName: "OverlayViewCard", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as? OverlayViewCard
    }
    
//    @IBOutlet lazy var overlayImageView: UIImageView! = {
//        [unowned self] in
//        
//        var imageView = UIImageView(frame:self.bounds)//UIImageView(frame: self.bounds)
//        self.addSubview(imageView)
//        
//        return imageView
//        }()

    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left? :
                imgVw.image = UIImage(named: overlayLeftImageName)
            case .right? :
                imgVw.image = UIImage(named: overlayRightImageName)
            default:
                imgVw.image = nil
            }
        }
    }

  
}
