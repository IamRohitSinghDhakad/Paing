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
    init(menuName: String, menuImageName: String) {
        self.menuName = menuName
        self.menuImageName = menuImageName
    }
}

class Preferences {
    static let shared = Preferences()
    var enableTransitionAnimation = false
}

class AppSideMenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectionMenuTrailingConstraint: NSLayoutConstraint!
    
    private let menus: [SideMenuOptions] = [SideMenuOptions(menuName: "Home", menuImageName: "Home"),
                                    SideMenuOptions(menuName: "Profile", menuImageName: "Profile"),
                                    SideMenuOptions(menuName: "Chat", menuImageName: "Chat"),
                                    SideMenuOptions(menuName: "Membership", menuImageName: "Membership"),
                                    SideMenuOptions(menuName: "Blocked", menuImageName: "Blocked"),
                                    SideMenuOptions(menuName: "Notification", menuImageName: "Notification"),
                                    SideMenuOptions(menuName: "Settings", menuImageName: "Settings"),
                                    SideMenuOptions(menuName: "Paing Blog", menuImageName: "PaingBlog"),
                                    SideMenuOptions(menuName: "Exit Session", menuImageName: "Logout")]
    
    
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
        cell.menuImage.image = UIImage(named: menus[row].menuImageName)
        cell.menuName.text = menus[row].menuName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if row == 8 {
            sideMenuController?.hideMenu()
            
            objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: "Sign off", message: "Do you want to log out?", controller: self) {
                AppSharedData.sharedObject().signOut()
            }
            
        }
        else {
            sideMenuController?.setContentViewController(with: "\(row)", animated: Preferences.shared.enableTransitionAnimation)
            sideMenuController?.hideMenu()
            
            if let identifier = sideMenuController?.currentCacheIdentifier() {
                print("[Example] View Controller Cache Identifier: \(identifier)")
            }
        }
    }
}