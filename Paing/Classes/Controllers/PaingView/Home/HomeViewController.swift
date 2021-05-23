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
    
    var arrUsers = [HomeModel]()
    var dictSampleData = [String:Any]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        swipeView.dataSource = self
        swipeView.delegate = self
        
//        for dataa in dictSampleData{
//            let obj = HomeModel.init(dict: dataa)
//        }
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Action Methods
    
    @IBAction func actionSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
   
}

// MARK: KolodaViewDelegate

extension HomeViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//        let position = swipeView.currentCardIndex
//        for i in 1...4 {
//          dataSource.append(UIImage(named: "Card_like_\(i)")!)
//        }
//        swipeView.insertCardAtIndexRange(position..<position + 4, animated: true)
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
        let cell = koloda.viewForCard(at: index)as? OverLayCard
        
        let objCard = self.arrUsers[index]
        
        cell?.lblName.text = objCard.strName
        cell?.lblAge.text = objCard.strAge
      
        
        let profilePic = objCard.strImageUrl
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell?.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        
        return cell!
        
       // return UIImageView(image: dataSource[Int(index)])
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayViewCard", owner: self, options: nil)?[0] as? OverlayView
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print(index, direction)
    }
}


//MARK:- Call Webservice Get All Users
extension HomeViewController{
    
    
    
    
    
    
}
