//
//  ProfileViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var vwPhotosDigonal: UIView!
    @IBOutlet var vwVideoDigonal: UIView!
    @IBOutlet var vwAboutDigonal: UIView!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var imgVwBtnSelected: UIImageView!
    
    var selectedSegmentIndx: Int = 0
    var arrayPhotoCollection: [UserImageModel] = []
    var arrayVideoCollection: [UserImageModel] = []
    var imagePicker = UIImagePickerController()
    var relStatusList: [String] = ["Seleccion", "Con pareja", "Sin pareja", "Relación Abierta", "Relación no pública"]
    var visibleStatusList: [String] = ["Visible", "No visible"]
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.imgVwBtnSelected.image = #imageLiteral(resourceName: "one_blue")
        self.setUpView()
        self.call_GetProfile(strUserID: objAppShareData.UserDetail.strUserId)
    }
    
    //MARK: - Action Methods
    
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
    
    @IBAction func actionSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    //MARK: - Helper Methods
    
    func setUpView() {
//        self.vwAboutUs.isHidden = true
        self.imagePicker.delegate = self
        self.selectedSegmentIndx = 0
        self.setSelectedSegment()
//        vwRelationStatus.isHidden = true
        
//        guard let collectionView = self.collectionUserProfile, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//
//            flowLayout.minimumInteritemSpacing = margin
//            flowLayout.minimumLineSpacing = margin
//            flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
    func setSelectedSegment() {
        if self.selectedSegmentIndx == 0 {
            self.imgVwBtnSelected.image = #imageLiteral(resourceName: "one_blue")
//            self.vwAboutUs.isHidden = true
        }
        else if self.selectedSegmentIndx == 1 {
            self.imgVwBtnSelected.image = #imageLiteral(resourceName: "two_blue")
//            self.vwAboutUs.isHidden = true
        }
        else if self.selectedSegmentIndx == 2 {
            self.imgVwBtnSelected.image = #imageLiteral(resourceName: "thr_blue")
//            self.vwAboutUs.isHidden = false
        }
//        self.collectionUserProfile.reloadData()
    }
    
    //MARK: - Bind User Profile
    
    func bindUserProfile() {
        let userProfile = objAppShareData.UserDetail
        let profilePic = userProfile.strProfilePicture
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
        }
        let locationArr = [userProfile.strCity, userProfile.strState, userProfile.strCountry].filter { !$0.trim().isEmpty }
        
//        self.lblLocation.text = locationArr.joined(separator: ", ")
//        self.lblUserName.text = userProfile.strName
//        self.lblAboutUs.text = userProfile.strAboutMe
//        self.btnRelationshipStatus.setTitle(userProfile.strRelStatus, for: .normal)
//        self.vwRelationStatus.isHidden = (userProfile.strRelStatus == "") ?  true : false
//        self.imgVwFavProfile.image = (userProfile.valLikedStatus == 0) ? UIImage(named: "emptyStar") : UIImage(named: "filledStar")
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK:- UIImage Picker Delegate
    func setImage(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        let alert:UIAlertController = UIAlertController(title: "", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Foto", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        
        let galleryAction = UIAlertAction(title: "Video", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.openVideoGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    // Open Photo Gallery
    func openGallery() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // Open Video Gallery
    func openVideoGallery() {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.mediaTypes = ["public.movie"]
        imagePicker.allowsEditing = false
        imagePicker.videoMaximumDuration = 300
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else { return }

        if mediaType  == "public.image" {
            print("Image Selected")
            
        }
        
        if mediaType == "public.movie" {
            print("Video Selected")
            // Using the full key
            if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                // Do something with the URL
            }

            // Using just the information key value
            if let url = info[.mediaURL] as? URL {
                // Do something with the URL
            }
            
        }
    /*
        if let editedImage = info[.editedImage] as? UIImage {
            self.pickedImage = editedImage
            self.imgVwUser.image = self.pickedImage
            //  self.cornerImage(image: self.imgUpload,color:#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) ,width: 0.5 )
            
            self.makeRounded()
            if self.imgVwUser.image == nil{
                // self.viewEditProfileImage.isHidden = true
            }else{
                // self.viewEditProfileImage.isHidden = false
            }
            imagePicker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.pickedImage = originalImage
            self.imgVwUser.image = pickedImage
            self.makeRounded()
            // self.cornerImage(image: self.imgUpload,color:#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) ,width: 0.5 )
            if self.imgVwUser.image == nil{
                // self.viewEditProfileImage.isHidden = true
            }else{
                //self.viewEditProfileImage.isHidden = false
            }
            imagePicker.dismiss(animated: true, completion: nil)
        }
    */
    }
    
    func cornerImage(image: UIImageView, color: UIColor ,width: CGFloat){
        image.layer.cornerRadius = image.layer.frame.size.height / 2
        image.layer.masksToBounds = false
        image.layer.borderColor = color.cgColor
        image.layer.borderWidth = width
        
    }
    
    func makeRounded() {
        
        self.imgVwUser.layer.borderWidth = 0
        self.imgVwUser.layer.masksToBounds = false
        //self.imgUpload.layer.borderColor = UIColor.blackColor().CGColor
        self.imgVwUser.layer.cornerRadius = self.imgVwUser.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        self.imgVwUser.clipsToBounds = true
    }
    
}

extension ProfileViewController {
    
    // MARK:- Get Profile
    
    func call_GetProfile(strUserID: String) {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getUserProfile, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let user_details  = response["result"] as? [String:Any] {
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                    objAppShareData.fetchUserInfoFromAppshareData()
                    self.bindUserProfile()
                    self.call_GetUserImage(strUserID: strUserID)
                }
                else {
                    objWebServiceManager.hideIndicator()
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
        } failure: { (Error) in
            print(Error)
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
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let arrData  = response["result"] as? [[String:Any]] {
                    print("User details: \(arrData)")
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
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    func call_ChangeRelationshipStatus() {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id" : objAppShareData.UserDetail.strUserId, "rel_status" : ""] as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_completeProfile, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let user_details  = response["result"] as? [String:Any] {
                    
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    func call_ChangeVisibleStatus() {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id" : objAppShareData.UserDetail.strUserId, "visible" : ""] as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_completeProfile, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let user_details  = response["result"] as? [String:Any] {
                    
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}
