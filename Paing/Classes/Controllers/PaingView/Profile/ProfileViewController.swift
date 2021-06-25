//
//  ProfileViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit
import AVKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var vwPhotosDigonal: UIView!
    @IBOutlet var vwVideoDigonal: UIView!
    @IBOutlet var vwAboutDigonal: UIView!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var imgVwBtnSelected: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblRelationshipStatus: UILabel!
    @IBOutlet weak var lblVisibility: UILabel!
    @IBOutlet weak var lblAboutUs: UILabel!
    @IBOutlet weak var vwAboutUs: UIView!
    
    @IBOutlet weak var collectionProfile: UICollectionView!
    
    let margin: CGFloat = 10
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        self.selectImageVideo()
//        self.imgVwBtnSelected.image = #imageLiteral(resourceName: "thr_blue")
    }
    
    @IBAction func actionSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func actionRelationshipStatus(_ sender: Any) {
        self.openRelationshipStatus()
    }
    
    @IBAction func actionVisibility(_ sender: Any) {
        self.openVisibilityStatus()
    }
    
    @IBAction func actionFavorites(_ sender: Any) {
        self.pushVc(viewConterlerId: "FavoriteViewController")
    }
    
    @IBAction func actionFavImageVideo(_ sender: Any) {
    }
    
    
    //MARK: - Helper Methods
    
    func setUpView() {
        self.vwAboutUs.isHidden = false
        self.imagePicker.delegate = self
        self.selectedSegmentIndx = 0
        self.setSelectedSegment()
        self.bindUserProfile()
//        vwRelationStatus.isHidden = true
        
        guard let collectionView = self.collectionProfile, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

            flowLayout.minimumInteritemSpacing = margin
            flowLayout.minimumLineSpacing = margin
            flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
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
        self.collectionProfile.reloadData()
    }
    
    func openRelationshipStatus() {
        let alert:UIAlertController = UIAlertController(title: self.relStatusList[0], message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let option1 = UIAlertAction(title: self.relStatusList[1], style: .default) { (action) in
            if objAppShareData.UserDetail.strRelStatus != self.relStatusList[1] {
                self.call_ChangeRelationshipStatus(status: self.relStatusList[1])
            }
        }
        let option2 = UIAlertAction(title: self.relStatusList[2], style: .default) { (action) in
            if objAppShareData.UserDetail.strRelStatus != self.relStatusList[2] {
                self.call_ChangeRelationshipStatus(status: self.relStatusList[2])
            }
        }
        let option3 = UIAlertAction(title: self.relStatusList[3], style: .default) { (action) in
            if objAppShareData.UserDetail.strRelStatus != self.relStatusList[3] {
                self.call_ChangeRelationshipStatus(status: self.relStatusList[3])
            }
        }
        let option4 = UIAlertAction(title: self.relStatusList[4], style: .default) { (action) in
            if objAppShareData.UserDetail.strRelStatus != self.relStatusList[4] {
                self.call_ChangeRelationshipStatus(status: self.relStatusList[4])
            }
        }
        let optionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(option1)
        alert.addAction(option2)
        alert.addAction(option3)
        alert.addAction(option4)
        alert.addAction(optionCancel)
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    func openVisibilityStatus() {
        let alert:UIAlertController = UIAlertController(title: "Seleccion", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let option1 = UIAlertAction(title: self.visibleStatusList[0], style: .default) { (action) in
            if objAppShareData.UserDetail.strVisibilityStatus != "0" {
                self.call_ChangeVisibleStatus(visibility: 0)
            }
        }
        let option2 = UIAlertAction(title: self.visibleStatusList[1], style: .default) { (action) in
            if objAppShareData.UserDetail.strVisibilityStatus != "1" {
                self.call_ChangeVisibleStatus(visibility: 1)
            }
        }
        let optionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(option1)
        alert.addAction(option2)
        alert.addAction(optionCancel)
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    func actionImageVideoSelect(index: Int) {
        let vc = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "PreviewPhotoVideoViewController") as? PreviewPhotoVideoViewController
        let alert:UIAlertController = UIAlertController(title: "Seleccion", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        if self.selectedSegmentIndx == 0{
            let option1 = UIAlertAction(title: "Ver Foto", style: .default) { (action) in
                let imageObj = self.arrayPhotoCollection[index]
                vc?.asset = imageObj
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
            let option2 = UIAlertAction(title: "Quitar foto", style: .default) { (action) in
                alert.dismiss(animated: true) {
                    DispatchQueue.main.async {
                        self.showDeleteImageVideoPopup(index: index)
                    }
                }
                
            }
            
            alert.addAction(option1)
            alert.addAction(option2)
            
        }else if self.selectedSegmentIndx == 1 {
            let option1 = UIAlertAction(title: "Ver Video", style: .default) { (action) in
                let videoObj = self.arrayVideoCollection[index]
                vc?.asset = videoObj
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
            let option2 = UIAlertAction(title: "Quitar Video", style: .default) { (action) in
                alert.dismiss(animated: true) {
                    DispatchQueue.main.async {
                        self.showDeleteImageVideoPopup(index: index)
                    }
                }
                
            }
            
            alert.addAction(option1)
            alert.addAction(option2)
        }
       

        let optionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
       
        alert.addAction(optionCancel)
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDeleteImageVideoPopup(index: Int) {
        let message = (self.selectedSegmentIndx == 0) ? "¿Quieres eliminar esta imagen?" : "¿Quieres eliminar esta video?"
        objAlert.showAlertCallBack(alertLeftBtn: "CANCEL", alertRightBtn: "OK", title: "Borrar", message: message, controller: self) {
            if self.selectedSegmentIndx == 0 {
                let obj = self.arrayPhotoCollection[index]
                self.call_DeleteUserImage(id: obj.strUserImageId)
            }
            else if self.selectedSegmentIndx == 1 {
                let obj = self.arrayVideoCollection[index]
                self.call_DeleteUserImage(id: obj.strUserImageId)
            }
            
        }
    }
    
    //MARK: - Bind User Profile
    
    func bindUserProfile() {
        var finalText = ""
        let userProfile = objAppShareData.UserDetail
        let profilePic = userProfile.strProfilePicture
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
        }
        let locationArr = [userProfile.strCity, userProfile.strState, userProfile.strCountry].filter { !$0.trim().isEmpty }
        
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
            print(h)
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
        
        
        self.lblLocation.text = locationArr.joined(separator: ", ")
        self.lblName.text = userProfile.strName
       // self.lblAboutUs.text = userProfile.strAboutMe
        self.lblRelationshipStatus.text = (userProfile.strRelStatus.isEmpty) ? self.relStatusList[0] : userProfile.strRelStatus
        self.lblVisibility.text = (Int(userProfile.strVisibilityStatus) == nil) ? self.visibleStatusList[0] : ((Int(userProfile.strVisibilityStatus)! < self.visibleStatusList.count) ? self.visibleStatusList[Int(userProfile.strVisibilityStatus)!] : self.visibleStatusList[0])
        
        print("Relationship status: \(userProfile.strRelStatus)")
        print("Visibility status: \(userProfile.strVisibilityStatus)")
        
//        self.btnRelationshipStatus.setTitle(userProfile.strRelStatus, for: .normal)
//        self.vwRelationStatus.isHidden = (userProfile.strRelStatus == "") ?  true : false
    }
    
}

//MARK: - Collection Methods

extension ProfileViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
        let cell = self.collectionProfile.dequeueReusableCell(withReuseIdentifier: "UserAssetsCollectionViewCell", for: indexPath) as! UserAssetsCollectionViewCell
        let row = indexPath.row
        cell.btnFavAsset.tag = row
        if self.selectedSegmentIndx == 0 {
            let imageObj = self.arrayPhotoCollection[row]
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
        self.actionImageVideoSelect(index: row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 3   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((self.collectionProfile.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
    
}

// MARK:- UIImage Picker Delegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func selectImageVideo(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        let alert:UIAlertController = UIAlertController(title: "Seleccion", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Foto", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            
            if self.arrayPhotoCollection.count > 11{
                objAlert.showAlert(message: "Puede cargar un máximo de 12 fotos.", title: "Alert", controller: self)
            }else{
                self.openGallery()
            }
        }
        
        let galleryAction = UIAlertAction(title: "Video", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            if self.arrayVideoCollection.count > 2{
                objAlert.showAlert(message: "Puede cargar un máximo de 3 videos.", title: "Alert", controller: self)
            }else{
                self.openVideoGallery()
            }
           
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
        imagePicker.allowsEditing = true
        imagePicker.videoMaximumDuration = 60
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
            if let url = info[.imageURL] as? URL {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditImageVideoViewController") as? EditImageVideoViewController
                vc?.type = .image
                vc?.assetURL = url
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
//            if let editedImage = info[.editedImage] as? UIImage {
//
//            } else if let originalImage = info[.originalImage] as? UIImage {
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditImageVideoViewController") as? EditImageVideoViewController
//                vc?.type = .image
//                self.navigationController?.pushViewController(vc!, animated: true)
//            }
        }
        
        if mediaType == "public.movie" {
            print("Video Selected")
            // Using the full key
            if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                
                let duration = AVURLAsset(url: url).duration.seconds
                    print(duration)
                
                // Do something with the URL
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditImageVideoViewController") as? EditImageVideoViewController
                vc?.type = .video
                vc?.assetURL = url
                self.navigationController?.pushViewController(vc!, animated: true)
            }

            // Using just the information key value
            if let url = info[.mediaURL] as? URL {
                // Do something with the URL
            }
            
        }

        
    
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
        
//        objWebServiceManager.showIndicator()
        let parameter = ["user_id" : strUserID, "login_id" : objAppShareData.UserDetail.strUserId] as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetUserImage, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let arrData  = response["result"] as? [[String:Any]] {
                    print("User details: \(arrData)")
                    self.arrayPhotoCollection = []
                    self.arrayVideoCollection = []
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
              //  objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    //MARK: - Change Relationship Status
    
    func call_ChangeRelationshipStatus(status: String) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id" : objAppShareData.UserDetail.strUserId, "rel_status" : status] as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_completeProfile, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let user_details  = response["result"] as? [String:Any] {
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                    objAppShareData.fetchUserInfoFromAppshareData()
                    self.bindUserProfile()
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
    
    //MARK: - Change Visibility Status
    
    func call_ChangeVisibleStatus(visibility: Int) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id" : objAppShareData.UserDetail.strUserId, "visible" : "\(visibility)"] as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_completeProfile, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode {
                if let user_details  = response["result"] as? [String:Any] {
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                    objAppShareData.fetchUserInfoFromAppshareData()
                    self.bindUserProfile()
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
    
    //MARK: - Delete Image Video
    
    func call_DeleteUserImage(id: String) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_image_id" : id] as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_DeleteUserImage, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                self.call_GetUserImage(strUserID: objAppShareData.UserDetail.strUserId)
                
            }else{
                objWebServiceManager.hideIndicator()
               // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}
