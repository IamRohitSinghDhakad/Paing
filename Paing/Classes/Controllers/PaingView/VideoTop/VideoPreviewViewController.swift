//
//  VideoPreviewViewController.swift
//  Paing
//
//  Created by Paras on 23/07/21.
//

import UIKit
import AVKit

class VideoPreviewViewController: UIViewController {
    
    
    @IBOutlet weak var cvVideo: UICollectionView!
    
    let margin: CGFloat = 0
    var arrayVideoCollection: [BlogListModel] = []
    
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    var playerLayer : AVPlayerLayer!
    private var playerItemBufferEmptyObserver: NSKeyValueObservation?
    private var playerItemBufferKeepUpObserver: NSKeyValueObservation?
    private var playerItemBufferFullObserver: NSKeyValueObservation?
    
    var isComeFirstTym: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cvVideo.delegate = self
        self.cvVideo.dataSource = self
        
        guard let collectionView = self.cvVideo, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

            flowLayout.minimumInteritemSpacing = margin
            flowLayout.minimumLineSpacing = margin
            flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK: - Collection Methods

extension VideoPreviewViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayVideoCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
     //   self.stopPlayer()
        
        let cell = self.cvVideo.dequeueReusableCell(withReuseIdentifier: "VideoPreviewCollectionViewCell", for: indexPath) as! VideoPreviewCollectionViewCell
 
        let obj = self.arrayVideoCollection[indexPath.row]
        
        let profilePic = obj.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
        }
        
        cell.lblUserName.text = obj.strName
        
        print("Cell for row")
        
       // if self.isComeFirstTym{
            self.isComeFirstTym = false
            let url = URL(string:obj.strVideoUrl)
            self.player = AVPlayer(url: url!)
            DispatchQueue.main.async {
                self.playerLayer = AVPlayerLayer(player: self.player)
                self.playerLayer.frame = cell.vwVideoPreview.bounds
                self.playerLayer.videoGravity = .resizeAspect
                cell.vwVideoPreview.layer.addSublayer(self.playerLayer)
                self.player.play()
            }

            playerItemBufferEmptyObserver = self.player.currentItem?.observe(\AVPlayerItem.isPlaybackBufferEmpty, options: [.new]) { [weak self] (_, _) in
                guard self != nil else { return }
                objWebServiceManager.showIndicator()
            }

            playerItemBufferKeepUpObserver = self.player.currentItem?.observe(\AVPlayerItem.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] (_, _) in
                guard self != nil else { return }
                objWebServiceManager.hideIndicator()
            }

            playerItemBufferFullObserver = self.player.currentItem?.observe(\AVPlayerItem.isPlaybackBufferFull, options: [.new]) { [weak self] (_, _) in
                guard self != nil else { return }
                objWebServiceManager.hideIndicator()
         //   }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
      //  self.actionImageVideoSelect(index: row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 1   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((self.cvVideo.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: Int(self.cvVideo.bounds.height))
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//      //  if self.isComeFirstTym{
//          //  self.isComeFirstTym = false
//        let obj = self.arrayVideoCollection[indexPath.row]
//        let cell = self.cvVideo.dequeueReusableCell(withReuseIdentifier: "VideoPreviewCollectionViewCell", for: indexPath)as! VideoPreviewCollectionViewCell
//            let url = URL(string:obj.strVideoUrl)
//            self.player = AVPlayer(url: url!)
//            DispatchQueue.main.async {
//                self.playerLayer = AVPlayerLayer(player: self.player)
//                self.playerLayer.frame = cell.vwVideoPreview.bounds
//                cell.vwVideoPreview.layer.addSublayer(self.playerLayer)
//                self.player.play()
//            }
//
//            playerItemBufferEmptyObserver = self.player.currentItem?.observe(\AVPlayerItem.isPlaybackBufferEmpty, options: [.new]) { [weak self] (_, _) in
//                guard self != nil else { return }
//                objWebServiceManager.showIndicator()
//            }
//
//            playerItemBufferKeepUpObserver = self.player.currentItem?.observe(\AVPlayerItem.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] (_, _) in
//                guard self != nil else { return }
//                objWebServiceManager.hideIndicator()
//            }
//
//            playerItemBufferFullObserver = self.player.currentItem?.observe(\AVPlayerItem.isPlaybackBufferFull, options: [.new]) { [weak self] (_, _) in
//                guard self != nil else { return }
//                objWebServiceManager.hideIndicator()
//            }
//      //  }
//    }
    
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        
//        self.cvVideo.visibleCells.forEach { cell in
//            
//        }
//        
//        self.stopPlayer()
//    }
//    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//
//        for cell in self.cvVideo.visibleCells {
//            let indexPath = self.cvVideo.indexPath(for: cell)
//           // self.stopPlayer()
//           // self.cvVideo.reloadData()
//            let obj = self.arrayVideoCollection[indexPath!.row]
//            let cell = self.cvVideo.dequeueReusableCell(withReuseIdentifier: "VideoPreviewCollectionViewCell", for: indexPath!)as! VideoPreviewCollectionViewCell
//            let url = URL(string:obj.strVideoUrl)
//            self.player = AVPlayer(url: url!)
//            DispatchQueue.main.async {
//                self.playerLayer = AVPlayerLayer(player: self.player)
//                self.playerLayer.frame = cell.vwVideoPreview.bounds
//                cell.vwVideoPreview.layer.addSublayer(self.playerLayer)
//                self.player.play()
//            }
//
//            playerItemBufferEmptyObserver = self.player.currentItem?.observe(\AVPlayerItem.isPlaybackBufferEmpty, options: [.new]) { [weak self] (_, _) in
//                guard self != nil else { return }
//                objWebServiceManager.showIndicator()
//            }
//
//            playerItemBufferKeepUpObserver = self.player.currentItem?.observe(\AVPlayerItem.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] (_, _) in
//                guard self != nil else { return }
//                objWebServiceManager.hideIndicator()
//            }
//
//            playerItemBufferFullObserver = self.player.currentItem?.observe(\AVPlayerItem.isPlaybackBufferFull, options: [.new]) { [weak self] (_, _) in
//                guard self != nil else { return }
//                objWebServiceManager.hideIndicator()
//            }
//            print(indexPath!)
//        }
//    }
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        self.cvVideo.visibleCells.forEach { cell in
//            self.stopPlayer()  // TODO: write logic to stop the video before it begins scrolling
//        }
           
        
        
        
    //}

    
    func stopPlayer() {
        if let play = self.player {
            print("stopped")
            play.pause()
            self.player = nil
            print("player deallocated")
        } else {
            print("player was already deallocated")
        }
    }
    
}




//MARK:- Call Webservice Video Blogs
extension VideoPreviewViewController{
    
    func call_GetBlogList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["my_id":strUserID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getVideos, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                 //   self.arrBlogList.removeAll()
                    for dictdata in arrData{
                        
//                        let obj = BlogListModel.init(dict: dictdata)
//                        if objAppShareData.UserDetail.strUserId == obj.strBlogUserID{
//                            self.arrBlogList.append(obj)
//                        }else{
//                            //Do Nothing
//                        }
                        
                    }
                    
//                    if self.arrBlogList.count == 0{
//                        self.cvVideo.displayBackgroundText(text: "Aún no publicas ningún blog")
//                    }else{
//                        self.cvVideo.displayBackgroundText(text: "")
//                    }
                    
                    self.cvVideo.reloadData()
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
    
    //=============Add Blog =================//
    
    func call_AddBlog(strUserID:String, strText:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID,
                         "text":strText]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_AddBlogInList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                self.call_GetBlogList(strUserID: strUserID)
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                  //  self.tblBLogs.displayBackgroundText(text: "ningún record fue encontrado")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    //=============== Edit Blog ==============//
    func call_EditBlog(strUserID:String, strText:String, strBlogID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["blog_id":strBlogID,
                         "text":strText]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_AddBlogInList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{

                self.call_GetBlogList(strUserID: strUserID)
                
                
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                   // self.tblBLogs.displayBackgroundText(text: "ningún record fue encontrado")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
   //===============  Delete Blog =============//
    func call_DeleteBlog(strUserID:String, blogID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID,
                         "blog_id":blogID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_DeleteBlogInList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{

                self.call_GetBlogList(strUserID: strUserID)
                
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                 //   self.tblBLogs.displayBackgroundText(text: "Aún no publicas ningún blog")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    //=================== Like Blog ==================//
    func call_LikeBlog(strUserID:String, blogID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID,
                         "blog_id":blogID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_likeBlog, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{

                self.call_GetBlogList(strUserID: strUserID)
                
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                  //  self.tblBLogs.displayBackgroundText(text: "ningún record fue encontrado")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
}

