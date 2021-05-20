//
//  Extensions.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/03/21.
//

import Foundation
import UIKit

extension UserDefaults {
    enum Keys {
        
        static let strVenderId = "udid"
        
        static let strAccessToken = "access_token"
        
        static let AuthToken = "AuthToken"
        
        static let userID = "userID"
        
        static let userType = "userType"
        
    }
}

extension UIViewController : UITextFieldDelegate  {
    
    
    func SetBackGroundImageAtViewAndImageName(ImageName: NSString, view: UIView)
    {
        
       UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: ImageName as String)?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    
    
    
     //>>>>>>>>>>>>>>>>>>>>>>>>>>> Hide Keyboard <<<<<<<<<<<<<<<<<<<<<<<<<<
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
     //>>>>>>>>>>>>>>>>>>>>>>>>>>> Validate Emailid <<<<<<<<<<<<<<<<<<<<<<<<<<
    
    func isValidEmail(stringValue: String) ->Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: stringValue)
    }
    
     //>>>>>>>>>>>>>>>>>>>>>>>>>>> Dismiss ViewController <<<<<<<<<<<<<<<<<<<<<<<<<<
    func onBackPressed() {
        
        if let navigation = self.navigationController
            
        {
            navigation.popViewController(animated: true)
        }
            
        else
            
        {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
     //>>>>>>>>>>>>>>>>>>>>>>>>>>> Present ViewController <<<<<<<<<<<<<<<<<<<<<<<<<<
    
    func presentVC(viewConterlerId : String)     {
           
           let vc = self.storyboard?.instantiateViewController(withIdentifier: viewConterlerId)
           self.present(vc!, animated: true, completion: nil)
           
       }
    
     //>>>>>>>>>>>>>>>>>>>>>>>>>>> Push ViewController <<<<<<<<<<<<<<<<<<<<<<<<<<
    
    func pushVc(viewConterlerId:String){
        
        let vc = storyboard?.instantiateViewController(withIdentifier: viewConterlerId)
        navigationController?.pushViewController(vc!,
                                                 animated: true)
        
    }
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>> Show Alert With Single Button <<<<<<<<<<<<<<<<<<<<<<<<<<
    
    func showAlertWithSingleButton(Title: String, Message: String)  {
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)

        
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        //Ok action
                                       // self.present(alert, animated: true, completion: nil)
                                       
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
     //>>>>>>>>>>>>>>>>>>>>>>>>>>> Show Alert With Multi Button <<<<<<<<<<<<<<<<<<<<<<<<<<
    
    func showAlertWithMultiButton(Title: String, Message: String)  {
           
           let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)

           alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
               //Cancel Action
            self.present(alert, animated: true, completion: nil)
           }))
           alert.addAction(UIAlertAction(title: "Ok",
                                         style: UIAlertAction.Style.destructive,
                                         handler: {(_: UIAlertAction!) in
                                           //ok action
                                            self.present(alert, animated: true, completion: nil)
           }))
           self.present(alert, animated: true, completion: nil)
       }
    


//Mark:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Check string Null <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    func isStringNullValue(strValues: String) -> Bool {
        var isNull:Bool = true
        
        if strValues == nil || strValues == "(null)" || strValues == "<null>"  || strValues == "" {
            isNull = true
        }
        else
        {
            isNull = false
        }
        // strValues.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines
        return isNull
    }
    
    func isValid(_ object:AnyObject!) -> Bool
    {
        if let _:AnyObject = object
        {
            return true
        }

        return false
    }
}

  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Convert Way64 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
extension String {
    
     func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}


//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> show Activity Indicator <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
/*
extension UIActivityIndicatorView {
    convenience init(activityIndicatorStyle: UIActivityIndicatorView.Style, color: UIColor, placeInTheCenterOf parentView: UIView) {
        self(style: activityIndicatorStyle)
        center = parentView.center
        self.color = color
        parentView.addSubview(self)
    }
}
 */

extension UITextField {
func setIconLeftSide(_ image: UIImage) {
   let iconView = UIImageView(frame:
                  CGRect(x: 10, y: 5, width: 20, height: 20))
   iconView.image = image
   let iconContainerView: UIView = UIView(frame:
                  CGRect(x: 20, y: 0, width: 30, height: 30))
   iconContainerView.addSubview(iconView)
   leftView = iconContainerView
   leftViewMode = .always
}
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UILabel {//Write this extension after close brackets of your class
    func lblFunction() {
        numberOfLines = 0
        lineBreakMode = .byWordWrapping//If you want word wraping
        //OR
      //  lineBreakMode = .byCharWrapping//If you want character wraping
    }
}

extension UIView{
    func viewShadowHeader() {
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 1.0
        self.layer.shadowColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
    }
    
    func viewShadowHeaderWithCorner(corner:CGFloat) {
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 1.0
        self.layer.cornerRadius = corner
        self.layer.shadowColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
    }
}


//extension UIView {
//
//    @IBInspectable var shadow: Bool {
//        get {
//            return layer.shadowOpacity > 0.0
//        }
//        set {
//            if newValue == true {
//                self.addShadow()
//            }
//        }
//    }
//
//    @IBInspectable var cornerRadius: CGFloat {
//        get {
//            return self.layer.cornerRadius
//        }
//        set {
//            self.layer.cornerRadius = newValue
//
//            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
//            if shadow == false {
//                self.layer.masksToBounds = true
//            }
//        }
//    }
//
//
//    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
//               shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
//               shadowOpacity: Float = 0.4,
//               shadowRadius: CGFloat = 3.0) {
//        layer.shadowColor = shadowColor
//        layer.shadowOffset = shadowOffset
//        layer.shadowOpacity = shadowOpacity
//        layer.shadowRadius = shadowRadius
//    }
//}


//@IBDesignable class RoundedView: UIView {
//    
//    @IBInspectable var cornerRadiuss: CGFloat = 0.0
//    @IBInspectable var borderColor: UIColor = UIColor.black
//    @IBInspectable var borderWidth: CGFloat = 0.5
//    private var customBackgroundColor = UIColor.white
//    override var backgroundColor: UIColor?{
//        didSet {
//            customBackgroundColor = backgroundColor!
//            super.backgroundColor = UIColor.clear
//        }
//    }
//    
//    func setup() {
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize.zero
//        layer.shadowRadius = 5.0
//        layer.shadowOpacity = 0.5
//        super.backgroundColor = UIColor.clear
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.setup()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.setup()
//    }
//    
//    override func draw(_ rect: CGRect) {
//        customBackgroundColor.setFill()
//        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadiuss ?? 0).fill()
//        
//        let borderRect = bounds.insetBy(dx: borderWidth/2, dy: borderWidth/2)
//        let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadiuss - borderWidth/2)
//        borderColor.setStroke()
//        borderPath.lineWidth = borderWidth
//        borderPath.stroke()
//        
//        // whatever else you need drawn
//    }
//}


extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


