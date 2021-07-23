//
//  VideoPreviewCollectionViewCell.swift
//  Paing
//
//  Created by Paras on 23/07/21.
//

import UIKit

class VideoPreviewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnLikeVideo: UIButton!
    @IBOutlet weak var btnCommentVideo: UIButton!
    @IBOutlet weak var btnMenuVideo: UIButton!
    @IBOutlet weak var vwVideoPreview: UIView!
    
    
    override func awakeFromNib() {
        
    }
    
}
