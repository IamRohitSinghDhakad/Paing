//
//  HomeViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit
import Koloda
import SDWebImage

private var numberOfCards: Int = 5

class HomeViewController: UIViewController {
    
    @IBOutlet var swipeView: KolodaView!
    @IBOutlet var subVwFilter: UIView!
    
    var arrUsers = [HomeModel]()
    var dictSampleData = [String:Any]()
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subVwFilter.isHidden = true
        swipeView.dataSource = self
        swipeView.delegate = self
        
        //        for dataa in dictSampleData{
        //            let obj = HomeModel.init(dict: dataa)
        //        }
        self.call_GetUsers()
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        // Do any additional setup after loading the view.
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
                overlay.lblAge.text = objCard.strAge
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
    
    
    
}
