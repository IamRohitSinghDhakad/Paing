//
//  BlogListModel.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 02/06/21.
//

import UIKit

class BlogListModel: NSObject {

    
    var strName : String = ""
    var strAge : String = ""
    var strDob : String = ""
    var strGender : String = ""
    var strBlogId : String = ""
    var strBlogUserID : String = ""
    var strUserImage : String = ""
    var strLikeCount : String = ""
    var strCommentCount :String = ""
    var strLikeStatus :String = ""
    var strBlogText :String = ""
    
    //CommentData
    var strComment : String = ""
    var strCommentID : String = ""
    var strCommentUserImage : String = ""
    
    //LikesData
    var strLikedName : String = ""
    var strLikeID : String = ""
    var strLikedUserImage : String = ""
    
    var arrLikedList = [LikedDataModel]()
    var arrCommentList = [CommentDataModel]()
    
    //Video Model
    var strVideoUrl : String = ""
    var strVideoID : String = ""
    
    
    init(dict : [String:Any]) {
        
        
        if let notification_id = dict["name"] as? String{
            self.strName = notification_id
        }
        
        if let user_image = dict["user_image"] as? String{
            self.strUserImage = user_image
        }
        
        if let sex = dict["sex"] as? String{
            self.strGender = sex
        }
        
        if let text = dict["text"] as? String{
            self.strBlogText = text
        }
        
        
        if let age = dict["age"] as? String{
            self.strAge = age
        }
        
        if let dob = dict["dob"] as? String{
            self.strDob = dob
        }
        
        
        //========XXX==========//
        
        if let video_id = dict["video_id"] as? String{
            self.strVideoID = video_id
        }else  if let video_id = dict["video_id"] as? Int{
            self.strVideoID = "\(video_id)"
        }
        
        if let video = dict["video"] as? String{
            self.strVideoUrl = "http://ambitious.in.net/Shubham/paing/" + video
        }
        
        //=======XXX===========//
        
        if let notification_id = dict["blog_id"] as? String{
            self.strBlogId = notification_id
        }else  if let notification_id = dict["blog_id"] as? Int{
            self.strBlogId = "\(notification_id)"
        }
        
        if let blogUserID = dict["user_id"] as? String{
            self.strBlogUserID = blogUserID
        }else  if let blogUserID = dict["user_id"] as? Int{
            self.strBlogUserID = "\(blogUserID)"
        }
        
        if let likes = dict["likes"] as? String{
            self.strLikeCount = likes
        }else  if let likes = dict["likes"] as? Int{
            self.strLikeCount = "\(likes)"
        }
        
        if let comments = dict["comments"] as? String{
            self.strCommentCount = comments
        }else  if let comments = dict["comments"] as? Int{
            self.strCommentCount = "\(comments)"
        }
        
        if let liked = dict["liked"] as? String{
            self.strLikeStatus = liked
        }else  if let liked = dict["liked"] as? Int{
            self.strLikeStatus = "\(liked)"
        }
        
        
        
        
        //Likes Data fetch
        if let arrComment = dict["likes_data"] as? [[String:Any]]{
            for data in arrComment{
                let obj = LikedDataModel.init(dict: data)
                self.strLikedName = obj.strLikedName
                self.strLikeID = obj.strLikedID
                self.strLikedUserImage = obj.strLikedUserImage
                
                self.arrLikedList.append(obj)
            }
        }
        
        
        //Comment Data fetch
        if let arrComment = dict["comments_data"] as? [[String:Any]]{
            for data in arrComment{
                let obj = CommentDataModel.init(dict: data)
                self.strComment = obj.strComment
                self.strCommentID = obj.strCommentID
                self.strCommentUserImage = obj.strCommentUserImage
                
                self.arrCommentList.append(obj)
            }
        }
    }
    
    
    
}

//Liked Model
class LikedDataModel : NSObject{
    
    var strLikedName :String = ""
    var strLikedID :String = ""
    var strLikedUserImage :String = ""
 
    init(dict : [String:Any]) {
        
        
        if let name = dict["name"] as? String{
            self.strLikedName = name
        }
        
        if let user_image = dict["user_image"] as? String{
            self.strLikedUserImage = user_image
        }
        
        if let blog_comment_id = dict["blog_like_id"] as? String{
            self.strLikedID = blog_comment_id
        }
    
    
    }
    
}


class CommentDataModel : NSObject{
    
    var strComment :String = ""
    var strCommentID :String = ""
    var strCommentUserImage :String = ""
    var strCommentUserID :String = ""
    var isSelected : Bool = false
    var strVideoCommentID :String = ""
 
    init(dict : [String:Any]) {
        
        
        if let comment = dict["comment"] as? String{
            self.strComment = comment
        }
        
        if let user_image = dict["user_image"] as? String{
            self.strCommentUserImage = user_image
        }
        
        if let blog_comment_id = dict["blog_comment_id"] as? String{
            self.strCommentID = blog_comment_id
        }
        
        if let video_comment_id = dict["video_comment_id"] as? String{
            self.strVideoCommentID = video_comment_id
        }
        
        
        
        if let user_id = dict["user_id"] as? String{
            self.strCommentUserID = user_id
        }else  if let user_id = dict["user_id"] as? String{
            self.strCommentUserID = user_id
        }
    
    
    }
    
}
