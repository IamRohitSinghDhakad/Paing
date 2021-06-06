//
//  PreviewPhotoVideoViewController.swift
//  Paing
//
//  Created by Akshada on 03/06/21.
//

import UIKit
import AVKit

class PreviewPhotoVideoViewController: UIViewController {
    
    @IBOutlet weak var vwPreview: UIView!
    @IBOutlet weak var imgVwPreview: UIImageView!
    
    var asset: UserImageModel?
    
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    //MARK: - Setup
    func setupView() {
        if let userImgModel = self.asset {
            self.getThumbImg(model: userImgModel)
            if userImgModel.strType == "video" {
//                self.imgVwPreview.isHidden = true
                guard let url = URL(string: userImgModel.strFile) else {
                    return
                }
                // Create an AVPlayer, passing it the HTTP Live Streaming URL.
                self.player = AVPlayer(url: url)
                self.playerViewController = AVPlayerViewController()
                self.playerViewController.player = player
                present(self.playerViewController, animated: true) {
                    self.player.play()
                }
            }
            else {
//                self.imgVwPreview.isHidden = false
            }
            
        }
    }
    
    func getThumbImg(model: UserImageModel) {
        let placeholderImage = #imageLiteral(resourceName: "splashLogo")
        self.imgVwPreview.image = placeholderImage
        let fileURL = model.strFile
        if model.strType == "image" {
            if fileURL != "" {
                if let url = URL(string: fileURL) {
                    self.imgVwPreview.sd_setImage(with: url, placeholderImage: placeholderImage)
                }
            }
        }
        else if model.strType == "video" {
            if fileURL != "" {
                if let url = URL(string: fileURL) {
                    self.getThumbnailImageFromVideoUrl(url: url) { (img) in
                        if let thumbImg = img {
                            self.imgVwPreview.image = thumbImg
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Action Methods
    @IBAction func actionClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
