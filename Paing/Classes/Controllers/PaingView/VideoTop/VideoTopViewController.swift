//
//  VideoTopViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 22/07/21.
//

import UIKit
import AVKit

class VideoTopViewController: UIViewController {

    var imagePicker = UIImagePickerController()
    var arrayVideoCollection: [BlogListModel] = []
    var controller = UIImagePickerController()
    let videoFileName = "/video.mp4"
   
    var videoUrl = ""
    var videoData = Data()
    var assetURL: URL?
    var type: AssetType?
    
   // var arrVideo[]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker.delegate = self
        self.call_GetVideoBlogList(strUserID: objAppShareData.UserDetail.strUserId)
        
    }
    
    @IBAction func btnSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    
    @IBAction func btnOpenCamera(_ sender: Any) {
       // self.selectImageVideo()
        self.takeVideo()
    }
    
    @IBAction func btnShowVideos(_ sender: Any) {
        pushVc(viewConterlerId: "VideoPreviewViewController")
        
    }
    
    @IBAction func btnMyVideos(_ sender: Any) {
        
    }
    
}


//MARk:- UIImage Picker
extension VideoTopViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func takeVideo(){
        let alert = UIAlertController(title: "Choose Video", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                //already authorized
                DispatchQueue.main.async {
                    self.recordVid()
                }
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        //access allowed
                        DispatchQueue.main.async {
                            self.recordVid()
                        }
                    } else {
                        //access denied
                        self.alertPromptToAllowCameraAccessViaSettings()
                    }
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.openVideoGallery()
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        imagePicker.delegate = self
        alert.popoverPresentationController?.sourceView = self.view // works for both iPhone & iPad
        present(alert, animated: true) {
            print("option menu presented")
        }
        
    }
    
    
    func alertPromptToAllowCameraAccessViaSettings() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Access the Camera", message: "Allow to access the camera from your device settings. Go to settings.", preferredStyle: .alert )
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                if let appSettingsURL = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettingsURL as URL)
                }
            }))
            alert.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        
        captureOutput.maxRecordedDuration = CMTimeMake(value: 10, timescale: 1)
        let seconds = 5.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            captureOutput.stopRecording()
            // Put your code which should be executed with a delay here
        }
        
        
        return
    }
    
//    @objc func videoSaved(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
//        if let theError = error {
//            print("error saving the video = \(theError)")
//        } else {
//            DispatchQueue.main.async(execute: { () -> Void in
//            })
//        }
//    }
    
    //MARK: - image picker delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
   //     if isComingFromRecording == true{
            // 1
            if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
                // Save video to the main photo album
               // let selectorToCall = #selector(self.videoSaved(_:didFinishSavingWithError:context:))
                
                // 2
              //  UISaveVideoAtPathToSavedPhotosAlbum(selectedVideo.relativePath, self, selectorToCall, nil)
                // Save the video to the app directory
//                let videoData = try? Data(contentsOf: selectedVideo)
//                if videoData != nil{
//                    self.videoData = videoData ?? Data()
//                    self.assetURL = selectedVideo
//                  //  self.callwebServicceApi()
//                }
                
                    
                    let duration = AVURLAsset(url: selectedVideo).duration.seconds
                        print(duration)
                    
                    // Do something with the URL
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditImageVideoViewController") as? EditImageVideoViewController
                    vc?.type = .video
                    vc?.assetURL = selectedVideo
                    vc?.isComingFrom = "VidoBlog"
                    self.navigationController?.pushViewController(vc!, animated: true)
                
                
                //self.uploadVideoUrl(uploadUrl:] as! String)
                // print(self.videoUrl)
                
            }
            // 3
            picker.dismiss(animated: true)
            

        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil);
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Helper methods
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.videoMaximumDuration = 30
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func openVideoGallery() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.mediaTypes = ["public.movie"]
        imagePicker.allowsEditing = true
        imagePicker.videoMaximumDuration = 30
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func checkCameraPermission(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            DispatchQueue.main.async {
                self.recordVid()
            }
            
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.recordVid()
                    }
                    
                }
            }
            
        case .denied: // The user has previously denied access.
            return
            
        case .restricted: // The user can't grant access due to restrictions.
            return
        @unknown default:
            return
        }
        
    }
    
    func recordVid(){
        // 1 Check if project runs on a device with camera available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            // 2 Present UIImagePickerController to take video
            controller.sourceType = .camera
            controller.mediaTypes = ["public.movie"]
            controller.delegate = self
            controller.videoMaximumDuration = 30
            present(controller, animated: true, completion: nil)
        }
        else {
            print("Camera is not available")
            controller.sourceType = .savedPhotosAlbum
            controller.mediaTypes = ["public.movie"]
            controller.delegate = self
            controller.videoMaximumDuration = 30
            present(controller, animated: true, completion: nil)
        }
    }
  
    
}


//// MARK:- UIImage Picker Delegate
//
//extension VideoTopViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func selectImageVideo(){
//        imagePicker.allowsEditing = true
//        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
//        let alert:UIAlertController = UIAlertController(title: "Seleccion", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
//
//        let cameraAction = UIAlertAction(title: "Foto", style: UIAlertAction.Style.default)
//        {
//            UIAlertAction in
//
//            if self.arrayVideoCollection.count > 11{
//                objAlert.showAlert(message: "Puede cargar un máximo de 12 fotos.", title: "Alert", controller: self)
//            }else{
//             //   self.openGallery()
//            }
//        }
//
//        let galleryAction = UIAlertAction(title: "Video", style: UIAlertAction.Style.default) {
//            UIAlertAction in
//
//            if self.arrayVideoCollection.count > 2{
//                objAlert.showAlert(message: "Puede cargar un máximo de 3 videos.", title: "Alert", controller: self)
//            }else{
//                self.openVideoGallery()
//            }
//
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
//            UIAlertAction in
//        }
//        alert.addAction(cameraAction)
//        alert.addAction(galleryAction)
//        alert.addAction(cancelAction)
//        alert.popoverPresentationController?.sourceView = self.view
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    // Open Video Gallery
//    func openVideoGallery() {
//        imagePicker.sourceType = .savedPhotosAlbum
//        imagePicker.mediaTypes = ["public.movie"]
//        imagePicker.allowsEditing = true
//        imagePicker.videoMaximumDuration = 60
//        self.present(imagePicker, animated: true, completion: nil)
//    }
//
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else { return }
//
//        if mediaType == "public.movie" {
//            print("Video Selected")
//            // Using the full key
//            if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
//
//                let duration = AVURLAsset(url: url).duration.seconds
//                    print(duration)
//
//                // Do something with the URL
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditImageVideoViewController") as? EditImageVideoViewController
//                vc?.type = .video
//                vc?.assetURL = url
//                self.navigationController?.pushViewController(vc!, animated: true)
//            }
//        }
//    }
//
//    func cornerImage(image: UIImageView, color: UIColor ,width: CGFloat){
//        image.layer.cornerRadius = image.layer.frame.size.height / 2
//        image.layer.masksToBounds = false
//        image.layer.borderColor = color.cgColor
//        image.layer.borderWidth = width
//
//    }
//
//
//
//}


extension VideoTopViewController{
    
    func call_GetVideoBlogList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["my_id":strUserID]as [String:Any]
        print(parameter)
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getVideos, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                  //  self.arrBlogList.removeAll()
                    for dictdata in arrData{
                        let obj = BlogListModel.init(dict: dictdata)
                        if objAppShareData.UserDetail.strUserId == obj.strBlogUserID{
                            self.arrayVideoCollection.append(obj)
                        }else{
                            //Do Nothing
                        }
                        
                    }
                    
                    if self.arrayVideoCollection.count == 0{
                        objAlert.showAlert(message: "No se encontró ningún video", title: "", controller: self)
                      //  self.cvVideo.displayBackgroundText(text: "Aún no publicas ningún blog")
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedPageViewController")as! FeedPageViewController
                        //vc.arrayVideoCollection = self.arrayVideoCollection
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                       // self.cvVideo.displayBackgroundText(text: "")
                    }
//
//                    self.cvVideo.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                   // self.tblBLogs.displayBackgroundText(text: "Aún no publicas ningún blog")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}



//Upload Video
extension VideoTopViewController {
    // MARK:- Get Profile
    
    func call_UploadImageVideo() {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        
        var assetData: [Data] = []
        if self.type! == .video {
            do {
                let data = try Data(contentsOf: self.assetURL!, options: Data.ReadingOptions.alwaysMapped)
                assetData.append(data)
            } catch {
                print(error)
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: error.localizedDescription, title: "Alert", controller: self)
                return
            }
        }
        else if self.type! == .image {
            do {
                let data = try Data(contentsOf: self.assetURL!, options: Data.ReadingOptions.alwaysMapped)
                assetData.append(data)
            } catch {
                print(error)
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: error.localizedDescription, title: "Alert", controller: self)
                return
            }
        }
        
        if assetData.count > 0 {
            let parameter = ["user_id" : objAppShareData.UserDetail.strUserId, "type" : self.type!.rawValue] as [String:Any]
//            let fileName = "File\(objAppShareData.UserDetail.strUserId)_\(Date().toMillis())"
            let fileName = "file"
            objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_AddUserImage, params: parameter, showIndicator: true, customValidation: "", imageData: nil, imageToUpload: assetData, imagesParam: [fileName], fileName: fileName, mimeType: (self.type! == .video) ? "video/mp4" : "image/jpeg") { (response) in
                objWebServiceManager.hideIndicator()
                let status = (response["status"] as? Int)
                let message = (response["message"] as? String)
                if status == MessageConstant.k_StatusCode {
                    if let userData  = response["result"] as? [[String:Any]] {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
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
                print(Error)
                objWebServiceManager.hideIndicator()
            }

        }
        else {
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "Something went wrong!", title: "Alert", controller: self)
            return
        }
    }
}
