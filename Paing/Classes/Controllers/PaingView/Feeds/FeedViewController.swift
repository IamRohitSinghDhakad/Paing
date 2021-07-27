//
//  FeedViewController.swift
//  Paing
//
//  Created by Paras on 26/07/21.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class FeedViewController: AVPlayerViewController, StoryboardScene {
    
    static var sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var index: Int!
    fileprivate var feed: BlogListModel!
    fileprivate var isPlaying: Bool!
   
    
    static func instantiate(feed: BlogListModel, andIndex index: Int, isPlaying: Bool = false) -> UIViewController {
        let viewController = FeedViewController.instantiate()
        viewController.feed = feed
        viewController.index = index
        viewController.isPlaying = isPlaying
        return viewController
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFeed()

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
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
        isPlaying ? play() : nil
    }
}


