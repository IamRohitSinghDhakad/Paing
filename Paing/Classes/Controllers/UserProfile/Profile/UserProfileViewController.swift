//
//  UserProfileViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 22/05/21.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet var vwPhotosDigonal: UIView!
    @IBOutlet var vwVideoDigonal: UIView!
    @IBOutlet var vwAboutDigonal: UIView!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var imgVwBtnSelected: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var vwRelationStatus: UIView!
    @IBOutlet weak var btnRelationshipStatus: UIButton!
    @IBOutlet weak var vwAdd: UIView!
    @IBOutlet weak var vwFavorite: UIView!
    @IBOutlet weak var btnFavoriteProfile: UIButton!
    @IBOutlet weak var imgVwFavProfile: UIImageView!
    
    @IBOutlet weak var lblAboutUs: UILabel!
    
    @IBOutlet weak var vwAboutUs: UIView!
    @IBOutlet weak var collectionUserProfile: UICollectionView!
    @IBOutlet weak var vwBlockedUser: UIView!
    
    
    var selectedSegmentIndx: Int = 0
    var userID: String?
    var userProfileDetail : userDetailModel?
    var isComingFromChat = Bool()
    var arrayPhotoCollection: [UserImageModel] = []
    var arrayVideoCollection: [UserImageModel] = []
    let margin: CGFloat = 10
    var strValueChanges = Bool()
    
    //MARK: - Override Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpView()
//        self.imgVwBtnSelected.image = #imageLiteral(resourceName: "one_blue")
        if let user_id = userID {
            self.call_GetProfile(strUserID: user_id)
        }
    }
    
    //MARK: - Action Method
    
    @IBAction func actionBack(_ sender: Any) {
        
        if isComingFromChat{
            
            if self.strValueChanges{
                //Navigate To Home
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
                let navController = UINavigationController(rootViewController: vc)
                navController.isNavigationBarHidden = true
                appDelegate.window?.rootViewController = navController
               
            }else{
                self.navigationController?.popViewController(animated: true)
            }
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    @IBAction func actionBlock(_ sender: Any) {
        if let userInfo = self.userProfileDetail {
            let message = (userInfo.valBlockedStatus == 0) ? "¿Quieres bloquear a \(userInfo.strName) ?" : "¿Quieres desbloquear a \(userInfo.strName) ?"
            objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "si", title: "", message: message, controller: self) {
                self.call_BlockUnblockUser(strUserID: userInfo.strUserId)
            }
        }
    }
    
    @IBAction func btnPhoto(_ sender: Any) {
        self.selectedSegmentIndx = 0
        self.setSelectedSegment()
//        self.imgVwBtnSelected.image = #imageLiteral(resourceName: "one_blue")
    }
    @IBAction func btnVideo(_ sender: Any) {
        self.selectedSegmentIndx = 1
        self.setSelectedSegment()
//        self.imgVwBtnSelected.image = #imageLiteral(resourceName: "two_blue")
    }
    @IBAction func btnAboutUs(_ sender: Any) {
        self.selectedSegmentIndx = 2
        self.setSelectedSegment()
//        self.imgVwBtnSelected.image = #imageLiteral(resourceName: "thr_blue")
    }
    
    @IBAction func actionMessage(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatDetailViewController") as? ChatDetailViewController
        vc?.strUserName = self.userProfileDetail?.strUserName ?? ""
        vc?.strUserImage = self.userProfileDetail?.strProfilePicture ?? ""
        vc?.strSenderID = self.userProfileDetail?.strUserId ?? ""
        vc?.isBlocked = "\(self.userProfileDetail?.valBlockedStatus ?? 0)" 
       // vc?.isBlocked = self.userProfileDetail?.valBlockedStatus
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func actionFavorite(_ sender: Any) {
        if let userInfo = self.userProfileDetail {
            let message = (userInfo.valLikedStatus == 0) ? "Quieres agregar \(userInfo.strName) en tu lista de favoritos?" : "¿Quieres eliminar a \(userInfo.strName) de tu lista de favoritos?"
            objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "si", title: "", message: message, controller: self) {
                self.call_MarkUserFavorite()
            }
        }
        
    }
    
    @IBAction func actionFavPhotoVideo(_ sender: UIButton) {
        let row = sender.tag
        if self.selectedSegmentIndx == 0 {
            let imageObj = self.arrayPhotoCollection[row]
            self.call_MarkAssetFavorite(userImgModel: imageObj, index: row)
        }
        else if self.selectedSegmentIndx == 1 {
            let videoObj = self.arrayVideoCollection[row]
            self.call_MarkAssetFavorite(userImgModel: videoObj, index: row)
        }
    }
    
    //MARK: - Helper Methods
    
    func setUpView() {
        self.vwAboutUs.isHidden = true
        self.selectedSegmentIndx = 0
        self.setSelectedSegment()
        vwRelationStatus.isHidden = true
        
        guard let collectionView = self.collectionUserProfile, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

            flowLayout.minimumInteritemSpacing = margin
            flowLayout.minimumLineSpacing = margin
            flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
    func setSelectedSegment() {
        if self.selectedSegmentIndx == 0 {
            self.imgVwBtnSelected.image = #imageLiteral(resourceName: "one_blue")
            self.vwAboutUs.isHidden = true
        }
        else if self.selectedSegmentIndx == 1 {
            self.imgVwBtnSelected.image = #imageLiteral(resourceName: "two_blue")
            self.vwAboutUs.isHidden = true
        }
        else if self.selectedSegmentIndx == 2 {
            self.imgVwBtnSelected.image = #imageLiteral(resourceName: "thr_blue")
            self.vwAboutUs.isHidden = false
        }
        self.collectionUserProfile.reloadData()
    }
    
    func setBlockedUnblockedView(isBlocked: Bool) {
        self.vwAdd.isHidden = isBlocked ? true : false
        self.vwFavorite.isHidden = isBlocked ? true : false
        self.vwBlockedUser.isHidden = isBlocked ? false : true
    }
    
    //MARK: - Bind User Profile
    
    func bindUserProfile() {
        
        var finalText = ""
        if let userProfile = self.userProfileDetail {
            
           // self.strBlockStatus = "\(userProfile.valBlockedStatus)"
            
            let profilePic = userProfile.strProfilePicture
            if profilePic != "" {
                let url = URL(string: profilePic)
                self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
            }
            let locationArr = [userProfile.strCity, userProfile.strState, userProfile.strCountry].filter { !$0.trim().isEmpty }
            
            self.lblLocation.text = locationArr.joined(separator: ", ")
            self.lblUserName.text = userProfile.strName
            
            if userProfile.strGender == "Male"{
                //self.lblAboutUs.text = "Soy hombre"
                finalText = "Soy hombre"
            }else{
                // self.lblAboutUs.text = "Soy Mujer"
                finalText = "Soy Mujer"
            }
            
            if userProfile.strAge != ""{
                finalText = finalText + ", tengo \(userProfile.strAge) años"
            }else{
                if userProfile.strDob != ""{
                    let age = Date().calculateAgeFromDate(strDate: userProfile.strDob, strFormatter: "yyyy-MM-dd")
                    finalText = finalText + ", tengo \(age) años"
                }
            }
            
            if userProfile.strAboutMe != ""{
                
                finalText = finalText + ", \(userProfile.strAboutMe)"
            }
            
            if userProfile.strHairColor != ""{
                finalText =  finalText + ", tengo el pelo de color \(userProfile.strHairColor)"
            }
            
            if userProfile.strEye != "" {
                finalText = finalText + ", los ojos \(userProfile.strEye)"
            }
            
            if userProfile.strSkinTone != "" {
                finalText = finalText + ", y mi piel es \(userProfile.strSkinTone)"
            }
            
            if userProfile.strHeight != "" {
                let x = userProfile.strHeight
                let h = x.replacingOccurrences(of: ".", with: ",")
                finalText = finalText + ", mi altura es \(h) mts"
            }
            
            if userProfile.strMusic != "" {
                finalText = finalText + ", me gusta la música \(userProfile.strMusic)"
            }
            
            if userProfile.strSport != "" {
                finalText = finalText + ", el deporte de \(userProfile.strSport)"
            }
            
            if userProfile.strCinema != "" {
                finalText = finalText + ", y me gusta el cine de \(userProfile.strCinema)"
            }
            
            if userProfile.strSpecialInstruction != "" {
                finalText = finalText + ", \(userProfile.strSpecialInstruction)."
            }
            
            self.lblAboutUs.text = finalText
            
            self.btnRelationshipStatus.setTitle(userProfile.strRelStatus, for: .normal)
            self.vwRelationStatus.isHidden = (userProfile.strRelStatus == "") ?  true : false
            self.imgVwFavProfile.image = (userProfile.valLikedStatus == 0) ? UIImage(named: "emptyStar") : UIImage(named: "filledStar")
        }
    }
    
}

extension UserProfileViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.selectedSegmentIndx == 0 {
            return self.arrayPhotoCollection.count
        }
        else if self.selectedSegmentIndx == 1 {
            return self.arrayVideoCollection.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionUserProfile.dequeueReusableCell(withReuseIdentifier: "UserAssetsCollectionViewCell", for: indexPath) as! UserAssetsCollectionViewCell
        let row = indexPath.row
        cell.btnFavAsset.tag = row
        let imgLiked = UIImage(named: "heart")
        let imgNotLiked = UIImage(named: "emptyHeart")
        if self.selectedSegmentIndx == 0 {
            let imageObj = self.arrayPhotoCollection[row]
            cell.btnFavAsset.setImage((imageObj.valLiked == 1) ? imgLiked : imgNotLiked, for: .normal)
            let profilePic = imageObj.strFile
            if profilePic != "" {
                let url = URL(string: profilePic)
                cell.imgUserProfileAsset.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
            }
            else {
                cell.imgUserProfileAsset.image = UIImage(named: "splashLogo")
            }
            
        }
        else if self.selectedSegmentIndx == 1 {
            let videoObj = self.arrayVideoCollection[row]
            cell.btnFavAsset.setImage((videoObj.valLiked == 1) ? imgLiked : imgNotLiked, for: .normal)
            let profilePic = videoObj.strFile
            if profilePic != "" {
                let placeholderImage = #imageLiteral(resourceName: "splashLogo")
                cell.imgUserProfileAsset.image = placeholderImage
                if let url = URL(string: profilePic) {
                    self.getThumbnailImageFromVideoUrl(url: url) { (img) in
                        if self.selectedSegmentIndx == 1 {
                            if let thumbImg = img {
                                cell.imgUserProfileAsset.image = thumbImg
                            }
                            else {
                                cell.imgUserProfileAsset.image = placeholderImage
                            }
                        }
                    }
                }
            }
            else {
                cell.imgUserProfileAsset.image = UIImage(named: "splashLogo")
            }
        }
        else {
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let vc = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "PreviewPhotoVideoViewController") as? PreviewPhotoVideoViewController
        if self.selectedSegmentIndx == 0 {
            let imageObj = self.arrayPhotoCollection[row]
            vc?.asset = imageObj
        }
        else if self.selectedSegmentIndx == 1 {
            let videoObj = self.arrayVideoCollection[row]
            vc?.asset = videoObj
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 3   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((self.collectionUserProfile.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
    
}

extension UserProfileViewController {
    // MARK:- Get Profile
    
    func call_GetProfile(strUserID: String) {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id" : strUserID, "login_id" : objAppShareData.UserDetail.strUserId] as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getUserProfile, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            objWebServiceManager.hideIndicator()
            
            if status == MessageConstant.k_StatusCode{
                
                if let user_details  = response["result"] as? [String:Any] {
                    self.userProfileDetail = userDetailModel.init(dict: user_details)
                    self.bindUserProfile()
                    if self.userProfileDetail!.valBlockedStatus == 0 {
                        self.setBlockedUnblockedView(isBlocked: false)
                        self.call_GetUserImage(strUserID: strUserID)
                    }
                    else {
                        self.setBlockedUnblockedView(isBlocked: true)
                    }
                }
                else {
                    objWebServiceManager.hideIndicator()
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
    
    // MARK:- Mark User Favorite
    
    func call_MarkUserFavorite() {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
     //   objWebServiceManager.showIndicator()
        let likeToMark = self.userProfileDetail!.valLikedStatus == 0 ? 1 : 0
        
        let parameter = ["user_id" : objAppShareData.UserDetail.strUserId,
                         "id" : self.userProfileDetail!.strUserId,
                         "liked" : "\(likeToMark)"] as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_SaveInFavorite, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            
            if status == MessageConstant.k_StatusCode{
                
                if let user_details  = response["result"] as? [String:Any] {
                    if let strLikedStatus = user_details["liked"] as? String {
                        self.userProfileDetail?.valLikedStatus = strLikedStatus == "0" ? 0 : 1
                        self.imgVwFavProfile.image = (self.userProfileDetail!.valLikedStatus == 0) ? UIImage(named: "emptyStar") : UIImage(named: "filledStar")
                    }
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
    
    // MARK:- Get User Image And Video List
    
    func call_GetUserImage(strUserID: String) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
     //   objWebServiceManager.showIndicator()
        let parameter = ["user_id" : strUserID, "login_id" : objAppShareData.UserDetail.strUserId] as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetUserImage, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            
            if status == MessageConstant.k_StatusCode{
                
                if let arrData  = response["result"] as? [[String:Any]] {
                    for dictdata in arrData {
                        let obj = UserImageModel.init(dict: dictdata)
                        if obj.strType == "image" {
                            self.arrayPhotoCollection.append(obj)
                        }
                        else if obj.strType == "video" {
                            self.arrayVideoCollection.append(obj)
                        }
                    }
                    self.setSelectedSegment()
                }
                
            }else{
                objWebServiceManager.hideIndicator()
               // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
    
    // MARK:- Mark User Image And Video Favorite
    
    func call_MarkAssetFavorite(userImgModel: UserImageModel, index: Int) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id" : objAppShareData.UserDetail.strUserId, "user_image_id" : userImgModel.strUserImageId] as [String:Any]
        
//        Call<ResponseBody> addfav(@Query("user_id") String user_id,
//                                  @Query("video_id") String video_id);
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_LikeUserImage, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            if status == MessageConstant.k_StatusCode {
                if let user_details  = response["result"] as? [String:Any] {
                    if self.selectedSegmentIndx == 0 {
                        self.arrayPhotoCollection[index].valLiked = 1
                    }
                    else if self.selectedSegmentIndx == 1 {
                        self.arrayVideoCollection[index].valLiked = 1
                    }
                }
                else {
                    if self.selectedSegmentIndx == 0 {
                        self.arrayPhotoCollection[index].valLiked = 0
                    }
                    else if self.selectedSegmentIndx == 1 {
                        self.arrayVideoCollection[index].valLiked = 0
                    }
                }
                self.collectionUserProfile.reloadItems(at: [IndexPath(item: index, section: 0)])
            } else {
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
    
    // MARK:- Mark User Block And Unblock
    
    func call_BlockUnblockUser(strUserID: String) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id" : objAppShareData.UserDetail.strUserId, "id" : strUserID] as [String:Any]
                
        objWebServiceManager.requestGet(strURL: WsUrl.url_BlockInUser, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            self.strValueChanges = true
            
            if status == MessageConstant.k_StatusCode {
                if let user_details  = response["result"] as? [String:Any] {
                    //Blocked
                    self.userProfileDetail?.valBlockedStatus = 1
                    
//                    self.call_GetProfile(strUserID: strUserID)
                    self.setBlockedUnblockedView(isBlocked: true)
                }
                else {
                    //Unblocked
                   
                    self.userProfileDetail?.valBlockedStatus = 0
//                    self.call_GetProfile(strUserID: strUserID)
                    self.setBlockedUnblockedView(isBlocked: false)
                    
                }
            } else {
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
    
}
