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

class NewFeedViewController: UIViewController,StoryboardScene {

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
    
    
    var player:AVPlayer?
    var playerViewController: AVPlayerViewController!
    var playerLayer : AVPlayerLayer!
    
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
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDeleteVideo(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profilePic = feed.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
        }
        
        self.lblUserName.text = feed.strName
        self.lblAgeGender.text = feed.strGender + "," + feed.strAge
        self.lblLikeCount.text = feed.strLikeCount
        self.lblCommentCount.text = feed.strCommentCount
        
        DispatchQueue.main.async {
            self.initializeFeed()
        }
        
//        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
//            self?.player?.seek(to: CMTime.zero)
//            self?.player?.play()
//        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
         player?.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(feed!, index!)
        player?.play()
    }
    
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    
    fileprivate func initializeFeed() {
        let url = URL(string:feed.strVideoUrl)
        player = AVPlayer(url: url!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.vwPlayerContainer.bounds
        self.vwPlayerContainer.layer.addSublayer(playerLayer)
        isPlaying ? play() : nil
        
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
