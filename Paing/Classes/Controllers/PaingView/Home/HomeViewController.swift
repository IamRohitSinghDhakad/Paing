//
//  HomeViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit
import Koloda
import SDWebImage
import iOSDropDown

private var numberOfCards: Int = 5

class HomeViewController: UIViewController {
    
    @IBOutlet var swipeView: KolodaView!
    @IBOutlet var subVwFilter: UIView!
    
    //SubVwOutlets
    @IBOutlet var tfSelectGenderSubVw: DropDown!
    @IBOutlet var tfMinimuAgeSubVw: UITextField!
    @IBOutlet var tfMaximumAgeSubVw: UITextField!
    @IBOutlet var vwFourSubVw: UIView!
    @IBOutlet var vwThreeSubVw: UIView!
    @IBOutlet var vwTwoSubVw: UIView!
    @IBOutlet var vwoneSubvw: UIView!
    @IBOutlet var vwPaisSubVw: UIView!
    @IBOutlet var vwProvinciaSubVw: UIView!
    @IBOutlet var vwMunicipioSubVw: UIView!
    @IBOutlet var btnChatSUbVw: UIButton!
    @IBOutlet var btnRelationSubVw: UIButton!
    @IBOutlet var btnAmistaSubVw: UIButton!
    @IBOutlet var btnRelacionIntima: UIButton!
    
    
    var arrUsers = [HomeModel]()
    var dictSampleData = [String:Any]()
    var strCountry = ""
    var strState = ""
    var strCity = ""
    var limit = 5
    var offset = 0
    
    var isSelectedOne = Bool()
    var isSelectedTwo = Bool()
    var isSelectedThree = Bool()
    var isSelectedFour = Bool()
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDropDown()
        self.subVwFilter.isHidden = true
        swipeView.dataSource = self
        swipeView.delegate = self
        
        self.tfMinimuAgeSubVw.delegate = self
        self.tfMaximumAgeSubVw.delegate = self
        self.tfSelectGenderSubVw.delegate = self
        
        self.vwoneSubvw.borderColor = UIColor.lightGray
        self.vwTwoSubVw.borderColor = UIColor.lightGray
        self.vwThreeSubVw.borderColor = UIColor.lightGray
        self.vwFourSubVw.borderColor = UIColor.lightGray
        
        //        for dataa in dictSampleData{
        //            let obj = HomeModel.init(dict: dataa)
        //        }
        
        self.call_GetUsers()
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        // Do any additional setup after loading the view.
    }
    
    func setDropDown(){

        self.tfSelectGenderSubVw.optionArray = ["Hombre", "Mujer", "Hombre y Mujer"]

        self.tfSelectGenderSubVw.didSelect{(selectedText , index ,id) in
        self.tfSelectGenderSubVw.text = selectedText
        }
    }
    
    //MARK: - Action Methods SubVw
    @IBAction func actionSelectPais(_ sender: Any) {
        self.clearColorAndValues()
        self.vwPaisSubVw.borderColor =  UIColor.init(named: "AppSkyBlue")
        self.strCountry = objAppShareData.UserDetail.strCountry
    }
    @IBAction func actionSelectProvincia(_ sender: Any) {
        self.clearColorAndValues()
        self.vwProvinciaSubVw.borderColor =  UIColor.init(named: "AppSkyBlue")
        self.strState = objAppShareData.UserDetail.strState
    }
    @IBAction func actionSelectMunicipio(_ sender: Any) {
        self.clearColorAndValues()
        self.vwMunicipioSubVw.borderColor =  UIColor.init(named: "AppSkyBlue")
        self.strCity = objAppShareData.UserDetail.strCity
    }
    
    @IBAction func actionChatSubVw(_ sender: Any) {
        //self.tfPassword.isSecureTextEntry ? false : true
        //self.vwoneSubvw.borderColor  =  self.vwoneSubvw.borderColor ? UIColor.init(named: "AppSkyBlue") : UIColor.lightGray
        
        if self.self.vwoneSubvw.borderColor == UIColor.lightGray{
            self.self.vwoneSubvw.borderColor = UIColor.init(named: "AppSkyBlue")
            self.isSelectedOne = true
        }else{
            self.self.vwoneSubvw.borderColor = UIColor.lightGray
            self.isSelectedOne = false
        }
    }
    @IBAction func actionRelacion(_ sender: Any) {
        //self.vwTwoSubVw.borderColor =  (self.vwTwoSubVw.borderColor != nil) ? UIColor.init(named: "AppSkyBlue") : UIColor.lightGray
        if self.self.vwTwoSubVw.borderColor == UIColor.lightGray{
            self.self.vwTwoSubVw.borderColor = UIColor.init(named: "AppSkyBlue")
            self.isSelectedTwo = true
        }else{
            self.self.vwTwoSubVw.borderColor = UIColor.lightGray
            self.isSelectedTwo = false
        }
    }
    @IBAction func actionSelectAmistad(_ sender: Any) {
        //self.vwThreeSubVw.borderColor =  (self.vwThreeSubVw.borderColor != nil) ? UIColor.init(named: "AppSkyBlue") : UIColor.lightGray
        if self.self.vwThreeSubVw.borderColor == UIColor.lightGray{
            self.self.vwThreeSubVw.borderColor = UIColor.init(named: "AppSkyBlue")
            self.isSelectedThree = true
        }else{
            self.self.vwThreeSubVw.borderColor = UIColor.lightGray
            self.isSelectedThree = false
        }
    }
    @IBAction func actionSelectRelacionintima(_ sender: Any) {
       // self.vwFourSubVw.borderColor =  (self.vwFourSubVw.borderColor != nil) ? UIColor.init(named: "AppSkyBlue") : UIColor.lightGray
        if self.self.vwFourSubVw.borderColor == UIColor.lightGray{
            self.self.vwFourSubVw.borderColor = UIColor.init(named: "AppSkyBlue")
            self.isSelectedFour = true
        }else{
            self.self.vwFourSubVw.borderColor = UIColor.lightGray
            self.isSelectedFour = false
        }
    }
    @IBAction func btnApplySubVw(_ sender: Any) {
        self.call_GetFilteredUsers(strOffset: 0)
    }
    
    func clearColorAndValues(){
        self.strCountry = ""
        self.strState = ""
        self.strCity = ""
        
        self.vwPaisSubVw.borderColor = UIColor.lightGray
        self.vwProvinciaSubVw.borderColor = UIColor.lightGray
        self.vwMunicipioSubVw.borderColor = UIColor.lightGray
    }
    
    //MARK: - Action Methods
    
    @IBAction func actionSideMenu(_ sender: Any) {
        self.subVwFilter.fadeOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.subVwFilter.isHidden = true
        }
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func actionOpenFilterView(_ sender: Any) {
        
        //( self.subVwFilter.isHidden) : self.subVwFilter.fadeIn() ? self.subVwFilter.fadeOut()
        
        if self.subVwFilter.isHidden{
            self.subVwFilter.isHidden = false
            self.subVwFilter.fadeIn()
        }else{
            self.subVwFilter.fadeOut()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.subVwFilter.isHidden = true
            }
            
        }
    }
    
    @IBAction func actionBtnLeftSwipe(_ sender: Any) {
        swipeView.swipe(.left)
    }
    @IBAction func actionBtnRightSwipe(_ sender: Any) {
        swipeView.swipe(.right)
        
    }
    
    @IBAction func actionBtnChatBox(_ sender: Any) {
       print(swipeView.currentCardIndex)
        let userID = self.arrUsers[swipeView.currentCardIndex]
    }
    
    @IBAction func actionBtnProfile(_ sender: Any) {
        print(swipeView.currentCardIndex)
        let userID = self.arrUsers[swipeView.currentCardIndex]
    }
}

// MARK: KolodaViewDelegate

extension HomeViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        print("Run out of cards")
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        pushVc(viewConterlerId: "DetailViewController")
        //  UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }
    
}


// MARK: KolodaViewDataSource

extension HomeViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return arrUsers.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        if let overlay = OverlayViewCard.createMyClassView() {
            print(index)
            overlay.tag = index
            
            if index < self.arrUsers.count {
                let objCard = self.arrUsers[index]
                overlay.lblName.text = objCard.strName
                overlay.lblAge.text = "\(objCard.strAge) Años"
                let profilePic = objCard.strImageUrl
                if profilePic != "" {
                    let url = URL(string: profilePic)
                    overlay.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
                }
            }
            return overlay
        }
        let myView = UIView.init()
        return myView
        
        //   let objCard = self.arrUsers[index]
        
        // print(objCard.strName)
        
        //        vw.lblName.text = objCard.strName
        //        vw.lblAge.text = objCard.strAge
        //
        //
        //        let profilePic = objCard.strImageUrl
        //        if profilePic != "" {
        //            let url = URL(string: profilePic)
        //            vw.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        //        }
        
        
        
        // return UIImageView(image: dataSource[Int(index)])
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return nil//Bundle.main.loadNibNamed("OverlayViewCard", owner: self, options: nil)?[0] as? OverlayView
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print(index, direction)
    }
}

//MARK:- Validation
extension HomeViewController{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.tfMinimuAgeSubVw  {
                let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
                if newLength >= 2 {
                    
                    let newstr = (textField.text ?? "") + string
                    if let value = Int(newstr), value > 18 {
                        self.tfMinimuAgeSubVw.text = ""
                      
                        objAlert.showAlert(message: "Age Maximum 18 only", title: "Alert", controller: self)
                        
                       // objAlert.showToast(message: "Age Maximum 18 only", font: UIFont.systemFont(ofSize: 12))
                      
                        return false
                    }else
                    {
                        return true
                    }
                } else {
                    return true
                }
            }
        else if textField == self.tfMaximumAgeSubVw  {
            let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
            if newLength >= 3 {
                let newstr = (textField.text ?? "") + string
                if let value = Int(newstr), value > 100 {
                    self.tfMaximumAgeSubVw.text = ""
                    
                    objAlert.showAlert(message: "Age Maximum 100 only", title: "Alert", controller: self)
                    
                    //objAlert.showToast(message: "Age Maximum 100 only", font: UIFont.systemFont(ofSize: 12))
                    
                    return false
                }else
                {
                    return true
                }
            } else {
                return true
            }
        }
            return true
    }
    
}


//MARK:- Call Webservice Get All Users
extension HomeViewController{
    
    
    func call_GetUsers(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":"1"]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetUserList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{
                        let obj = HomeModel.init(dict: dictdata)
                        self.arrUsers.append(obj)
                    }
                    self.swipeView.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    func call_GetFilteredUsers(strOffset:Int){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let ageRange = "\(self.tfMinimuAgeSubVw.text ?? "0") - \(self.tfMaximumAgeSubVw.text ?? "0")"
        var lookingFor = ""
        if isSelectedOne{
            lookingFor = (self.btnChatSUbVw.titleLabel?.text)!
        }
        if isSelectedTwo{
            lookingFor =  "\(lookingFor),\(self.btnRelationSubVw.titleLabel?.text! ?? "")"
        }
        if isSelectedThree{
            lookingFor =  "\(lookingFor),\(self.btnAmistaSubVw.titleLabel?.text! ?? "")"
        }
        if isSelectedFour{
            lookingFor =  "\(lookingFor),\(self.btnRelacionIntima.titleLabel?.text! ?? "")"
        }
        
        if lookingFor.hasPrefix(","){
            lookingFor.remove(at: lookingFor.startIndex)
        }
        print(lookingFor)
        
        
        let parameter = ["user_id":"1",
                         "age_range":ageRange,
                         "sex":self.tfSelectGenderSubVw.text!,
                         "country":self.strCountry,
                         "state":self.strState,
                         "city":self.strCity,
                         "looking_for":lookingFor,
                         "limit":self.limit,
                         "offset":offset]as [String:Any]
        
        print(parameter)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetUserList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            //total_rows
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    for dictdata in arrData{
                        let obj = HomeModel.init(dict: dictdata)
                        self.arrUsers.append(obj)
                    }
                    self.swipeView.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
}
