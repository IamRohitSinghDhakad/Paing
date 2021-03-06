//
//  AppSideMenuViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class SideMenuOptions: Codable {
    var menuName: String = ""
    var menuImageName: String = ""
    var menuSelectedImageName: String = ""
    init(menuName: String, menuImageName: String, menuSelectedImageName: String) {
        self.menuName = menuName
        self.menuImageName = menuImageName
        self.menuSelectedImageName = menuSelectedImageName
    }
}

class Preferences {
    static let shared = Preferences()
    var enableTransitionAnimation = false
}

class AppSideMenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectionMenuTrailingConstraint: NSLayoutConstraint!
    
    var selectedIndexpath = 0
    var strBadgeCount = ""
    
    private let menus: [SideMenuOptions] = [SideMenuOptions(menuName: "Inicio", menuImageName: "home", menuSelectedImageName: "home_selected"),
                                            SideMenuOptions(menuName: "Perfil", menuImageName: "user_sideMenu", menuSelectedImageName: "user_selected"),
                                            SideMenuOptions(menuName: "Chat", menuImageName: "chat", menuSelectedImageName: "chat_selected"),
                                            SideMenuOptions(menuName: "Afiliación", menuImageName: "icon_membership", menuSelectedImageName: "afilication_selected"),
                                            SideMenuOptions(menuName: "Bloqueados", menuImageName: "block_sideMenu", menuSelectedImageName: "lock_selected"),
                                            SideMenuOptions(menuName: "Notificación", menuImageName: "noti", menuSelectedImageName: "noti_selected"),
                                            SideMenuOptions(menuName: "Ajustes", menuImageName: "setting", menuSelectedImageName: "setting_selected"),
                                            SideMenuOptions(menuName: "Paing Blog", menuImageName: "blog Side_menu", menuSelectedImageName: "blog_selected"),
                                            SideMenuOptions(menuName: "Video Top", menuImageName: "top2", menuSelectedImageName: "top2"),
                                            SideMenuOptions(menuName: "Cerrar Sesión", menuImageName: "logout", menuSelectedImageName: "logout_selected")]
    
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureView()
        
        // Along with auto layout, these are the keys for enabling variable cell height
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        controllerMenuSetup()
    
        sideMenuController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("badge count update")
        
        self.tableView.updateRow(row: 5)
        
//        if let badgeCount = UserDefaults.standard.value(forKey: "badge")as? Int{
//            
//            if badgeCount != 0{
//                self.strBadgeCount = "\(badgeCount)"
//                print(badgeCount)
//                //cell.lblBadgeCount.isHidden = false
//                
//            }else{
//                print(badgeCount)
//                self.strBadgeCount = "\(badgeCount)"
//                //cell.lblBadgeCount.isHidden = true
//                self.tableView.updateRow(row: 5)
//            }
//        }else{
//            //cell.lblBadgeCount.isHidden = true
//           // self.tableView.updateRow(row: 5)
//        }

    }
    
    private func controllerMenuSetup() {
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "ContentNavigation")
        }, with: "0")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "ProfileNavigation")
        }, with: "1")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "ChatNavigation")
        }, with: "2")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "MembershipNavigation")
        }, with: "3")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "BlockedViewController")
        }, with: "4")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "NotificationNavigation")
        }, with: "5")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController")
        }, with: "6")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "PaingBlogViewController")
        }, with: "7")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "VideoTopNaviagttion")
        }, with: "8")
        
    }
    
    private func configureView() {
        SideMenuController.preferences.basic.menuWidth = view.frame.width * 0.4
        let sidemenuBasicConfiguration = SideMenuController.preferences.basic
        let showPlaceTableOnLeft = (sidemenuBasicConfiguration.position == .under) != (sidemenuBasicConfiguration.direction == .right)
        if showPlaceTableOnLeft {
            selectionMenuTrailingConstraint.constant = SideMenuController.preferences.basic.menuWidth - view.frame.width
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let sideMenuBasicConfiguration = SideMenuController.preferences.basic
        let showPlaceTableOnLeft = (sideMenuBasicConfiguration.position == .under) != (sideMenuBasicConfiguration.direction == .right)
        selectionMenuTrailingConstraint.constant = showPlaceTableOnLeft ? SideMenuController.preferences.basic.menuWidth - size.width : 0
        view.layoutIfNeeded()
    }
    
}

extension AppSideMenuViewController: SideMenuControllerDelegate {
    func sideMenuController(_ sideMenuController: SideMenuController,
                            animationControllerFrom fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasicTransitionAnimator(options: .transitionFlipFromLeft, duration: 0.6)
    }
    
    func sideMenuController(_ sideMenuController: SideMenuController, willShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller will show [\(viewController)]")
    }
    
    func sideMenuController(_ sideMenuController: SideMenuController, didShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller did show [\(viewController)]")
    }
    
    func sideMenuControllerWillHideMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu will hide")
    }
    
    func sideMenuControllerDidHideMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu did hide.")
    }
    
    func sideMenuControllerWillRevealMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu will reveal.")
    }
    
    func sideMenuControllerDidRevealMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu did reveal.")
    }
}

extension AppSideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    // swiftlint:disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppSideMenuTableViewCell", for: indexPath) as! AppSideMenuTableViewCell
        let row = indexPath.row
        if self.selectedIndexpath == indexPath.row{
            cell.menuImage.image = UIImage(named: menus[row].menuSelectedImageName)
        }else{
            cell.menuImage.image = UIImage(named: menus[row].menuImageName)
        }
        
        if row == 5{
            if let badgeCount = UserDefaults.standard.value(forKey: "badge")as? Int{
                print(badgeCount)
                if badgeCount != 0{
                    cell.lblBadgeCount.isHidden = false
                    cell.lblBadgeCount.text = "\(badgeCount)"
                }else{
                    cell.lblBadgeCount.isHidden = true
                }
            }else{
                cell.lblBadgeCount.isHidden = true
            }
        }else{
            cell.lblBadgeCount.isHidden = true
        }
        
        
        cell.menuName.text = menus[row].menuName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        self.selectedIndexpath = row
        
        if row == 9 {
            sideMenuController?.hideMenu()
            
            objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "si", title: "Cerrar Sesión", message: "¿Quieres cerrar sesión??", controller: self) {
                self.call_WSLogout(strUserID: objAppShareData.UserDetail.strUserId)
            }
            
        }
        else {
            sideMenuController?.setContentViewController(with: "\(row)", animated: Preferences.shared.enableTransitionAnimation)
            sideMenuController?.hideMenu()
            
            if let identifier = sideMenuController?.currentCacheIdentifier() {
                print("[Example] View Controller Cache Identifier: \(identifier)")
            }
        }
        
        self.tableView.reloadData()
    }
}

extension AppSideMenuViewController{
    
    //MARK:- Call WebService
    
    func call_WSLogout(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":strUserID,
                        ]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_Logout, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                
                AppSharedData.sharedObject().signOut()
                
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

extension UITableView
{
    func updateRow(row: Int, section: Int = 0)
    {
        let indexPath = IndexPath(row: row, section: section)
        
        self.beginUpdates()
        self.reloadRows(at: [indexPath], with: .automatic)
        self.endUpdates()
    }
    
}
