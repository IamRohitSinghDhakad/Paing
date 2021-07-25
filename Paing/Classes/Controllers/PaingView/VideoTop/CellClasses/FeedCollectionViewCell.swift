//
//  FeedCollectionViewCell.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 24/07/21.
//

import UIKit
import AVFoundation

class FeedCollectionViewCell: UICollectionViewCell {
 
    
    static let identifier = "FeedCollectionViewCell"
    
    var player : AVPlayer?
    var model : BlogListModel?
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.backgroundColor = .black
//        contentView.clipsToBounds = true
//    }
    
//    override class func awakeFromNib() {
//        <#code#>
//    }
    
    public func configure(with model: BlogListModel){
        
        self.model = model
        configureVideo()
   
    }
    
    
    private func configureVideo (){
        
        guard let model = model else{return}
        
        let profilePic = model.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
           // cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
        }
        
     //   cell.lblUserName.text = model.strName
        
        print("Cell for row")
        
       // if self.isComeFirstTym{
           
        let url = URL(string:model.strVideoUrl)
        self.player = AVPlayer(url: url!)
        
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = contentView.bounds
        contentView.layer.addSublayer(playerLayer)
        player?.play()
        

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
//         //   }
//        }
    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
}
