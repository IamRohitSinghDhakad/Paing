//
//  NewFeedViewController.swift
//  Paing
//
//  Created by Paras on 26/07/21.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class NewFeedViewController: UIViewController,StoryboardScene,FeedFetchProtocol {
    static var sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var index: Int!
    fileprivate var feed: BlogListModel!
    fileprivate var isPlaying: Bool!
   
    @IBOutlet weak var vwPlayerContainer: UIView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAgeGender: UILabel!
    @IBOutlet weak var IMGVWLIKE: UIImageView!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var vwDelete: UIView!
    @IBOutlet var subVwLikes: UIView!
    @IBOutlet var tblLikes: UITableView!
    
    var player:AVPlayer?
    var playerViewController: AVPlayerViewController!
    var playerLayer : AVPlayerLayer!
    
    var objVC:FeedFetchDelegate?
    var isComingFrom: String?
   // var isComingFrom = ""
    var notifObservers = [NSObjectProtocol]()
    var delegate: FeedFetchDelegate?
    var arrLike = [LikedDataModel]()
    
    var createLayerSwitch = true
    var isComingFromLike:Bool?
    
    private var playerItemBufferEmptyObserver: NSKeyValueObservation?
    private var playerItemBufferKeepUpObserver: NSKeyValueObservation?
    private var playerItemBufferFullObserver: NSKeyValueObservation?
    
    static func instantiate(feed: BlogListModel, andIndex index: Int, isPlaying: Bool = false) -> UIViewController {
        let viewController = NewFeedViewController.instantiate()
        viewController.feed = feed
        viewController.index = index
        viewController.isPlaying = isPlaying
        return viewController
    }
    
    @IBAction func btnCloseLikeVw(_ sender: Any) {
        self.subVwLikes.isHidden = true
    }
    
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDeleteVideo(_ sender: Any) {
       // objAlert.showAlert(message: "¿Estás seguro de que deseas eliminar este video?", title: "", controller: self)
        objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "", message: "¿Estás seguro de que deseas eliminar este video?", controller: self) {
            self.call_wsDeleteFeeds(strVideoID: self.feed.strVideoID, strUserID: objAppShareData.UserDetail.strUserId)
        }
        
    }
    @IBAction func btnLikeVideo(_ sender: Any) {
        print(feed.strLikeStatus)
        if feed.strLikeStatus == "1"{
            self.subVwLikes.isHidden = false
        }else{
            self.isComingFromLike = true
            self.call_wsLikeFeeds(strVideoID: feed.strVideoID, strUserID: objAppShareData.UserDetail.strUserId)
        }
        
    }
    
    @IBAction func btnUserProfile(_ sender: Any) {
        
        if objAppShareData.UserDetail.strUserId == feed.strBlogUserID{
        }else{
            let vc = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
            vc?.userID = feed.strBlogUserID
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    
    @IBAction func btnCommentVideo(_ sender: Any) {
        player?.pause()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentVideoViewController")as! CommentVideoViewController
        vc.objUserData = feed
        vc.arrComment = feed.arrCommentList
        vc.objVC = self.objVC
        vc.index = self.index
        vc.isComingFrom = self.isComingFrom ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subVwLikes.isHidden = true
        playInLoop()
        self.arrLike = feed.arrLikedList
        self.tblLikes.delegate = self
        self.tblLikes.dataSource = self
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        for observer in notifObservers {
            NotificationCenter.default.removeObserver(observer)
        }
        notifObservers.removeAll()
         player?.pause()
        self.closePlayer()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setUserData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.initializeFeed()
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
           
        }
       
    }
    
    func playInLoop(){
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
    }
    
    func closePlayer(){
     if (createLayerSwitch == false) {
        self.player?.pause()
        self.player = nil
        self.playerLayer.removeFromSuperlayer()
     }
    }
    
    func setUserData(){
        let profilePic = feed.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
        }
        
        self.lblUserName.text = feed.strName
        
        if feed.strGender == "Male"{
            self.lblAgeGender.text = "Hombre, " + feed.strAge
        }else{
            self.lblAgeGender.text = "Mujer, " + feed.strAge
        }
        
        
        self.lblLikeCount.text = feed.strLikeCount
        self.lblCommentCount.text = feed.strCommentCount
        
        if feed.strLikeStatus == "1"{
            self.IMGVWLIKE.image = #imageLiteral(resourceName: "like")
        }else{
            self.IMGVWLIKE.image = #imageLiteral(resourceName: "like_white")
        }
        
        if feed.strBlogUserID == objAppShareData.UserDetail.strUserId{
            self.vwDelete.isHidden = false
        }else{
            self.vwDelete.isHidden = true
        }
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    
    fileprivate func initializeFeed() {
        let encodedStr = feed.strVideoUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        let url = URL(string:encodedStr)
        player = AVPlayer(url: url!)
        self.playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.vwPlayerContainer.bounds
        self.vwPlayerContainer.layer.addSublayer(playerLayer)
        player?.play()
        isPlaying ? play() : nil
        createLayerSwitch = false
        
        playerItemBufferEmptyObserver = self.player?.currentItem?.observe(\AVPlayerItem.isPlaybackBufferEmpty, options: [.new]) { [weak self] (_, _) in
            guard self != nil else { return }
            objWebServiceManager.showIndicator()
        }

        playerItemBufferKeepUpObserver = self.player?.currentItem?.observe(\AVPlayerItem.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] (_, _) in
            guard self != nil else { return }
            objWebServiceManager.hideIndicator()
        }

        playerItemBufferFullObserver = self.player?.currentItem?.observe(\AVPlayerItem.isPlaybackBufferFull, options: [.new]) { [weak self] (_, _) in
            guard self != nil else { return }
            objWebServiceManager.hideIndicator()
        }
    
    }

}


//MARK:- UITablewVie Delegate and DataSource
extension NewFeedViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.arrLike.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTableViewCell")as! LikesTableViewCell
            
            let obj = self.arrLike[indexPath.row]
            
            let profilePic = obj.strLikedUserImage
            if profilePic != "" {
                let url = URL(string: profilePic)
                cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
            }
            
            cell.lblName.text = obj.strLikedName
            
            return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            
            let userID = self.arrLike[indexPath.row].strLikedID
            if objAppShareData.UserDetail.strUserId == userID{
            }else{
                let vc = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
                vc?.userID = userID
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
}


extension NewFeedViewController{
    
    func call_wsLikeFeeds(strVideoID:String,strUserID:String) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID,"video_id":strVideoID]as [String:Any]
       
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_likeVideo, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                //
                self.fetchFeeds()
                if self.isComingFromLike == true{
                    self.isComingFromLike = false
                    objAlert.showAlert(message: "¡Me gustó con éxito!", title: "", controller: self)
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                  //  self.tblBLogs.displayBackgroundText(text: "Aún no publicas ningún blog")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    //=================== Delete Video API ======>
    func call_wsDeleteFeeds(strVideoID:String,strUserID:String) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID,"video_id":strVideoID]as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_deleteVideo, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                self.navigationController?.popViewController(animated: true)
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                  //  self.tblBLogs.displayBackgroundText(text: "Aún no publicas ningún blog")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    //================== Update Feeds =======>>
    
    
    func fetchFeeds() {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
          //  objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
       // objWebServiceManager.showIndicator()
        
        let parameter = ["my_id":objAppShareData.UserDetail.strUserId]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getVideos, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                   var arrBlogList = [BlogListModel]()
                    for dictdata in arrData{
                        let obj = BlogListModel.init(dict: dictdata)
                        if self.isComingFrom == "MyVideos"{
                            if objAppShareData.UserDetail.strUserId == obj.strBlogUserID{
                                arrBlogList.append(obj)
                            }else{
                                //Do Nothing
                            }
                        }else{
                            arrBlogList.append(obj)
                        }
                    }
                    self.objVC?.feedFetchService(self, didFetchFeeds: arrBlogList, withError: nil)
                }
                
               
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                  //  self.tblBLogs.displayBackgroundText(text: "Aún no publicas ningún blog")
                }else{
                   // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
}
