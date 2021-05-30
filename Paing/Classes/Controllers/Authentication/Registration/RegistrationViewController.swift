//
//  RegistrationViewController.swift
//  Paing
//
//  Created by Akshada on 23/05/21.
//

import UIKit
import iOSDropDown

class RegistrationViewController: UIViewController,UINavigationControllerDelegate {
    
    //MARK: - Override Methods
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var btnOnImage: UIButton!
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfMuestrame: DropDown!
    @IBOutlet var tfDOB: UITextField!
    @IBOutlet var tfCountry: UITextField!
    @IBOutlet var tfAddressOne: UITextField!
    @IBOutlet var tfAddressTwo: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var tfConfirmPassword: UITextField!
    @IBOutlet var btnPassword: UIButton!
    @IBOutlet var btnConfirmPassword: UIButton!
    @IBOutlet var subVwTbl: UIView!
    @IBOutlet var tfSerchSubVw: UITextField!
    @IBOutlet var tblOptions: UITableView!
    @IBOutlet var btnMale: UIButton!
    @IBOutlet var btnFemale: UIButton!
    
    
    //MARK:- Variables
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    var datePicker = UIDatePicker()
    var arrCountry = [CountryModel]()
    var arrState = [StateModel]()
    var arrCity = [CityModel]()
    
    var arrCountryFiltered = [CountryModel]()
    var arrStateFiltered = [StateModel]()
    var arrCityFiltered = [CityModel]()
    
    var strType = "Country"
    
    var strSelectedCountryID = ""
    var strSelectedStateID = ""
    var strSelectedCityID = ""
    var strGender = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.call_WsGetCountry()
        hideKeyboardWhenTappedAround()
        self.imagePicker.delegate = self
        self.setDropDown()
        self.tblOptions.delegate = self
        self.tblOptions.dataSource = self
        
        self.tfDOB.delegate = self
        
        self.tfSerchSubVw.delegate = self
        self.tfSerchSubVw.addTarget(self, action: #selector(searchContactAsPerText(_ :)), for: .editingChanged)
        
        self.tfMuestrame.arrowSize = 0
        
        self.subVwTbl.isHidden = true
        
        self.showDatePicker()
        // Do any additional setup after loading the view.
    }
    
    func setDropDown(){

        self.tfMuestrame.optionArray = ["Muéstrame", "Hombre", "Mujer", "Hombre y Mujer"]

        self.tfMuestrame.didSelect{(selectedText , index ,id) in
        self.tfMuestrame.text = selectedText
        }
    }
    
    //MARK: - Action Methods
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionTakePhoto(_ sender: Any) {
        self.setImage()
    }
    
    @IBAction func actionRegister(_ sender: Any) {
        self.validateForSignUp()
    }
    
    @IBAction func actionGoToLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectCountry(_ sender: Any) {
        self.strType = "Country"
        self.tblOptions.reloadData()
        self.subVwTbl.isHidden = false
    }
    
    @IBAction func btnSelectState(_ sender: Any) {
       // self.subVwTbl.isHidden = false
    }
    @IBAction func btnSelectCity(_ sender: Any) {
       // self.subVwTbl.isHidden = false
    }
    
    @IBAction func actionShowPassword(_ sender: Any) {
        self.tfPassword.isSecureTextEntry = self.tfPassword.isSecureTextEntry ? false : true
    }
    @IBAction func actionShowConfirmPassword(_ sender: Any) {
        self.tfConfirmPassword.isSecureTextEntry = self.tfConfirmPassword.isSecureTextEntry ? false : true
    }
    
    @IBAction func actionSHowHome(_ sender: Any) {
        self.btnMale.setTitleColor(UIColor.init(named: "AppSkyBlue"), for: .normal)
        self.btnFemale.setTitleColor(UIColor.white, for: .normal)
        self.btnMale.backgroundColor = UIColor.white
        self.btnFemale.backgroundColor = UIColor.clear
        self.strGender = "Male"
        
    }
    @IBAction func actionShowMujer(_ sender: Any) {
        self.btnFemale.setTitleColor(UIColor.init(named: "AppSkyBlue"), for: .normal)
        self.btnMale.setTitleColor(UIColor.white, for: .normal)
        self.btnFemale.backgroundColor = UIColor.white
        self.btnMale.backgroundColor = UIColor.clear
        self.strGender = "Female"
    }
    
    @IBAction func btnCloseSubVw(_ sender: Any) {
        self.subVwTbl.isHidden = true
    }
    
}


extension RegistrationViewController{

    
    //MARK:- All Validations
    func validateForSignUp(){
        self.tfName.text = self.tfName.text!.trim()
        self.tfEmail.text = self.tfEmail.text!.trim()
        self.tfDOB.text = self.tfDOB.text!.trim()
        self.tfCountry.text = self.tfCountry.text!.trim()
        self.tfPassword.text = self.tfPassword.text!.trim()
        self.tfConfirmPassword.text = self.tfConfirmPassword.text!.trim()
        self.tfMuestrame.text = self.tfMuestrame.text?.trim()
        
        
        if (tfName.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankUserName, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfMuestrame.text?.isEmpty)! {
            objAlert.showAlert(message: "Please select Mustrame", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfEmail.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }else if !objValidationManager.validateEmail(with: tfEmail.text!){
            objAlert.showAlert(message: MessageConstant.ValidEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfDOB.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankDOB, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfCountry.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.CountrySelection, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfAddressOne.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.stateSelection, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfDOB.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.citySelection, title:MessageConstant.k_AlertTitle, controller: self)
        }

        else if (tfPassword.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankPassword, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfConfirmPassword.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankPassword, title:MessageConstant.k_AlertTitle, controller: self)
        }
        
        else if self.tfPassword.text != self.tfConfirmPassword.text{
            objAlert.showAlert(message: MessageConstant.PasswordNotMatched, title:MessageConstant.k_AlertTitle, controller: self)
        }
        
        else{
            
            self.callWebserviceForSignUp()
            
        }
    }
    
}




//MARK:- UIDatePicker
extension RegistrationViewController{
    
    func showDatePicker(){
        
        let screenWidth = UIScreen.main.bounds.width
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2

        // iOS 14 and above
        if #available(iOS 14, *) {// Added condition for iOS 14
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        
        //ToolBar
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolBar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        self.tfDOB.inputAccessoryView = toolBar
        self.tfDOB.inputView = datePicker
        
    }

      @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.tfDOB.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
     }

     @objc func cancelDatePicker(){
        self.view.endEditing(true)
      }
}


//MARK:- UITableViewDelegate and DataSorce
extension RegistrationViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.strType == "Country"{
            return arrCountryFiltered.count
        }else if self.strType == "State"{
            return arrStateFiltered.count
        }else if self.strType == "City"{
            return arrCityFiltered.count
        }else{
         return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblOptions.dequeueReusableCell(withIdentifier: "OptionsRegistrationTableViewCell")as! OptionsRegistrationTableViewCell
        
        if self.strType == "Country"{
           
            let obj = self.arrCountryFiltered[indexPath.row]
            cell.lblTitle.text = obj.strCountryName
        }else if self.strType == "State"{
            let obj = self.arrStateFiltered[indexPath.row]
            cell.lblTitle.text = obj.strStateName
        }else if self.strType == "City"{
            let obj = self.arrCityFiltered[indexPath.row]
            cell.lblTitle.text = obj.strCityName
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.strType == "Country"{
            self.strType = "State"
            let strCountryID = self.arrCountry[indexPath.row].strCountryID
            
            self.strSelectedCountryID = strCountryID
            self.tfCountry.text = self.arrCountry[indexPath.row].strCountryName
            
           // self.arrCountry.removeAll()
            self.call_WsGetState(strCountryID: strCountryID)
            
        }else if self.strType == "State"{
            self.strType = "City"
            let strStateID = self.arrState[indexPath.row].strStateID
            
            self.strSelectedStateID = strStateID
            self.tfAddressOne.text = self.arrState[indexPath.row].strStateName
            
           // self.arrState.removeAll()
            self.call_WsGetCity(strStateID: strStateID)
           
        }else if self.strType == "City"{
            self.strSelectedStateID = self.arrCity[indexPath.row].strCityID
            self.tfAddressTwo.text = self.arrCity[indexPath.row].strCityName
            self.subVwTbl.isHidden = true
           // self.arrCity.removeAll()
        }
       
    }
}


//MARK:- Searching
extension RegistrationViewController{
    
    @objc func searchContactAsPerText(_ textfield:UITextField) {
        
        switch strType {
        case "Country":
            self.arrCountryFiltered.removeAll()
            if textfield.text?.count != 0 {
                for dicData in self.arrCountry {
                    let isMachingWorker : NSString = (dicData.strCountryName ?? "") as NSString
                    let range = isMachingWorker.lowercased.range(of: textfield.text!, options: NSString.CompareOptions.caseInsensitive, range: nil,   locale: nil)
                    if range != nil {
                        arrCountryFiltered.append(dicData)
                    }
                }
            } else {
                self.arrCountryFiltered = self.arrCountry
            }
            if self.arrCountryFiltered.count == 0{
                self.tblOptions.displayBackgroundText(text: "No Record Found")
            }else{
                self.tblOptions.displayBackgroundText(text: "")
            }
           // self.arrPhoneContactsFiltered = self.arrPhoneContactsFiltered.sorted(by: { $0.sort > $1.sort})
            self.tblOptions.reloadData()
        case "State":
            
            self.arrStateFiltered.removeAll()
            if textfield.text?.count != 0 {
                for dicData in self.arrState {
                    let isMachingWorker : NSString = (dicData.strStateName ?? "") as NSString
                    let range = isMachingWorker.lowercased.range(of: textfield.text!, options: NSString.CompareOptions.caseInsensitive, range: nil,   locale: nil)
                    if range != nil {
                        arrStateFiltered.append(dicData)
                    }
                }
            } else {
                self.arrStateFiltered = self.arrState
            }
            if self.arrStateFiltered.count == 0{
                self.tblOptions.displayBackgroundText(text: "No Record Found")
            }else{
                self.tblOptions.displayBackgroundText(text: "")
            }
           // self.arrPhoneContactsFiltered = self.arrPhoneContactsFiltered.sorted(by: { $0.sort > $1.sort})
            self.tblOptions.reloadData()
        default:
            self.arrCityFiltered.removeAll()
            if textfield.text?.count != 0 {
                for dicData in self.arrCity {
                    let isMachingWorker : NSString = (dicData.strCityName ?? "") as NSString
                    let range = isMachingWorker.lowercased.range(of: textfield.text!, options: NSString.CompareOptions.caseInsensitive, range: nil,   locale: nil)
                    if range != nil {
                        arrCityFiltered.append(dicData)
                    }
                }
            } else {
                self.arrCityFiltered = self.arrCity
            }
            if self.arrCityFiltered.count == 0{
                self.tblOptions.displayBackgroundText(text: "No Record Found")
            }else{
                self.tblOptions.displayBackgroundText(text: "")
            }
           // self.arrPhoneContactsFiltered = self.arrPhoneContactsFiltered.sorted(by: { $0.sort > $1.sort})
            self.tblOptions.reloadData()
        }
    }
    
    
}


extension RegistrationViewController: UIImagePickerControllerDelegate{
    
    // MARK:- UIImage Picker Delegate
    func setImage(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    // Open camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.modalPresentationStyle = .fullScreen
            self .present(imagePicker, animated: true, completion: nil)
        } else {
            self.openGallery()
        }
    }
    
    // Open gallery
    func openGallery()
    {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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



//MARK:- CallWebservice
extension RegistrationViewController{
    
    func callWebserviceForSignUp(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        var imageData = [Data]()
        var imgData : Data?
        if self.pickedImage != nil{
            imgData = (self.pickedImage?.jpegData(compressionQuality: 1.0))!
        }
        else {
            imgData = (self.imgVwUser.image?.jpegData(compressionQuality: 1.0))!
        }
        imageData.append(imgData!)
        
        let imageParam = ["user_image"]
        
        print(imageData)
        
        let dicrParam = ["name":self.tfName.text!,
                         "email":self.tfEmail.text!,
                         "looking_for":self.tfMuestrame.text!,
                         "dob":self.tfDOB.text!,
                         "password":self.tfPassword.text!,
                         "country":self.tfCountry.text!,
                         "state":self.tfAddressOne.text!,
                         "city":self.tfAddressTwo.text!,
                         "sex":self.strGender,
                         "ios_register_id":"dfhjkgdkjgh"]as [String:Any]
        
        print(dicrParam)
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_SignUp, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "user_image", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
            
                let user_details  = response["result"] as? [String:Any]

                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                objAppShareData.fetchUserInfoFromAppshareData()

                self.pushVc(viewConterlerId: "DemoViewController")

            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }
    
    

    
   }


//MARK:- CallAPIGetCountries

extension RegistrationViewController{
    //MARK:- Get Country List
    func call_WsGetCountry(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getCountry, params: [:], queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                
                if let result = response["result"]as? [[String:Any]]{
                    for dictData in result{
                        let obj = CountryModel.init(dict: dictData)
                        self.arrCountry.append(obj)
                    }
                    
                    self.arrCountryFiltered = self.arrCountry
                    
                    self.tblOptions.reloadData()
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
    
    //MARK:- Get State List
    func call_WsGetState(strCountryID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let param = ["country_id":strCountryID]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getStates, params: param, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                
                if let result = response["result"]as? [[String:Any]]{
                    for dictData in result{
                        let obj = StateModel.init(dict: dictData)
                        self.arrState.append(obj)
                    }
                    
                    self.arrStateFiltered = self.arrState
                    
                    self.tblOptions.reloadData()
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
    
    //MARK:- Get City State
    func call_WsGetCity(strStateID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let param = ["state_id":strStateID]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getCity, params: param, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                
                if let result = response["result"]as? [[String:Any]]{
                    for dictData in result{
                        let obj = CityModel.init(dict: dictData)
                        self.arrCity.append(obj)
                    }
                    
                    self.arrCityFiltered = self.arrCity
                    
                    self.tblOptions.reloadData()
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
