//
//  WebServiceHelper.swift
//  Somi
//
//  Created by Paras on 24/03/21.
//

import Foundation
import UIKit


//http://ambitious.in.net/Shubham/paing/index.php/api/get_profile?user_id=2
let BASE_URL = "http://ambitious.in.net/Shubham/paing/index.php/api/"

struct WsUrl{
    
    static let url_SignUp  = BASE_URL + "signup?"
    static let url_SocialLogin  = BASE_URL + "social_login"
    static let url_getSubCategory = BASE_URL + "get_sub_category?"
    static let url_Login  = BASE_URL + "login"
    static let url_getCountry = BASE_URL + "get_country"
    static let url_getStates = BASE_URL + "get_state?"
    static let url_getCity = BASE_URL + "get_city?"
    static let url_completeProfile = BASE_URL + "complete_profile"
    static let url_forgotPassword = BASE_URL + "forgot_password"
    static let url_GetUserList = BASE_URL + "get_users"
    
    static let url_GetUserImage = BASE_URL + "get_user_image"
    static let url_getUserProfile  = BASE_URL + "get_profile"
    static let url_getNotification  = BASE_URL + "get_notification"
    static let url_getConversationList = BASE_URL + "get_conversation"
    static let url_getBlockList = BASE_URL + "blocked_list"
    static let url_getBlockUnblock = BASE_URL + "block_in_user"
    static let url_getBlogList = BASE_URL + "get_blog?"
    static let url_AddBlogInList = BASE_URL + "add_blog"
    static let url_DeleteBlogInList = BASE_URL + "delete_blog"
    static let url_addBlogComment = BASE_URL + "blog_comment"
    static let url_likeBlog = BASE_URL + "blog_like"
    static let url_getChatList = BASE_URL + "get_chat"
    static let url_insertChat = BASE_URL + "insert_chat"
    static let url_ForgotPassword  = BASE_URL + "forgot_password"
    static let url_DeleteNotification = BASE_URL + "delete_notification?"
    static let url_deleteChatSingleMessage = BASE_URL + "delete_chat_message?"
    static let url_clearConversation = BASE_URL + "clear_conversation"
    static let url_DeleteBlogComment = BASE_URL + "blog_comment_delete?"
    static let url_SaveInFavorite = BASE_URL + "save_in_favorite"
    static let url_LikeUserImage = BASE_URL + "like_user_image"
    static let url_BlockInUser = BASE_URL + "block_in_user"
    static let url_FavoriteList = BASE_URL + "favorite_list"
    static let url_AddUserImage = BASE_URL + "add_user_image"
    static let url_DeleteUserImage = BASE_URL + "delete_user_image"

}

//Api Header

struct WsHeader {

    //Login

    static let deviceId = "Device-Id"

    static let deviceType = "Device-Type"

    static let deviceTimeZone = "Device-Timezone"

    static let ContentType = "Content-Type"

}



//Api parameters

struct WsParam {

    

    //static let itunesSharedSecret : String = "c736cf14764344a5913c8c1"

    //Signup

    static let dialCode = "dialCode"

    static let contactNumber = "contactNumber"

    static let code = "code"

    static let deviceToken = "deviceToken"

    static let deviceType = "deviceType"

    static let firstName = "firstName"

    static let lastName = "lastName"

    static let email = "email"

    static let driverImage = "driverImage"

    static let isSignup = "isSignup"

    static let licenceImage = "licenceImage"

    static let socialId = "socialId"

    static let socialType = "socialType"

    static let imageUrl = "image_url"

    static let invitationId = "invitationId"

    static let status = "status"

    static let companyId = "companyId"

    static let vehicleId = "vehicleId"

    static let type = "type"

    static let bookingId = "bookingId"

    static let location = "location"

    static let latitude = "latitude"

    static let longitude = "longitude"

    static let currentdate_time = "current_date_time"

}



//Api check for params

struct WsParamsType {

    static let PathVariable = "Path Variable"

    static let QueryParams = "Query Params"

}
