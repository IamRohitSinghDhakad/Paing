//
//  EditProfileViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 23/05/21.
//

import UIKit
import iOSDropDown

class EditProfileViewController: UIViewController,UINavigationControllerDelegate {
    
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfSelectGender: DropDown!
    @IBOutlet var tfDOB: UITextField!
    @IBOutlet var tfCountry: UITextField!
    @IBOutlet var tfState: UITextField!
    @IBOutlet var tfCity: UITextField!
    @IBOutlet var vwHombre: UIView!
    @IBOutlet var vwMujer: UIView!
    @IBOutlet var vwHombreMujer: UIView!
    @IBOutlet var btnHombre: UIButton!
    @IBOutlet var btnMujer: UIButton!
    @IBOutlet var btnHombreMujer: UIButton!
    @IBOutlet var vwMunicipio: UIView!
    @IBOutlet var vwProvincia: UIView!
    @IBOutlet var vwPais: UIView!
    @IBOutlet var btnRelacionIntima: UIButton!
    @IBOutlet var txtVwAboutMe: SZTextView!
    @IBOutlet var btnAmistad: UIButton!
    @IBOutlet var btnRelacion: UIButton!
    @IBOutlet var btnChat: UIButton!
    @IBOutlet var vwChat: UIView!
    @IBOutlet var vwRelacion: UIView!
    @IBOutlet var vwAmistad: UIView!
    @IBOutlet var vwRelacionIntima: UIView!
    @IBOutlet var tfHairColor: UITextField!
    @IBOutlet var tfEyeColor: UITextField!
    @IBOutlet var tfHeightInMeter: UITextField!
    @IBOutlet var tfMusic: UITextField!
    @IBOutlet var tfTheSportOf: UITextField!
    @IBOutlet var tfCinema: UITextField!
    @IBOutlet var txtVwSpecificInformation: SZTextView!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var tfSkinTone: UITextField!
    @IBOutlet var subVwTable: UIView!
    @IBOutlet var tfSearch: UITextField!
    @IBOutlet var tblCountry: UITableView!
    
    
    //MARK:- Variables
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    var datePicker = UIDatePicker()
    var selectedGender = ""
    var strSelectedIWantToBeFound = ""
    var isGenderSelected = Bool()
    var strSelectedIWantToBeFoundInCountry = ""
    var strSelectedIWantToBeFoundInState = ""
    var strSelectedIWantToBeFoundInCity = ""
    var isSelectedOne = Bool()
    var isSelectedTwo = Bool()
    var isSelectedThree = Bool()
    var isSelectedFour = Bool()
    //Country
    var arrCountry = [CountryModel]()
    var arrState = [StateModel]()
    var arrCity = [CityModel]()
    
    var arrCountryFiltered = [CountryModel]()
    var arrStateFiltered = [StateModel]()
    var arrCityFiltered = [CityModel]()
    
    var strType = "Country"
    var strAge = ""
    
    var strSelectedCountryID = ""
    var strSelectedStateID = ""
    var strSelectedCityID = ""
    
    var strSelectedCountry = ""
    var strSelectedState = ""
    var strSelectedCity = ""
    
    var isComingFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.call_GetProfile(strUserID: objAppShareData.UserDetail.strUserId)
        self.call_WsGetCountry()
        
        self.tblCountry.delegate = self
        self.tblCountry.dataSource = self
        
        self.tfSearch.delegate = self
        self.tfSearch.addTarget(self, action: #selector(searchContactAsPerText(_ :)), for: .editingChanged)
        
        self.imagePicker.delegate = self
        
        self.setDefaultStyling()
        self.setDropDown()
        self.showDatePicker()
    }
    
    //SetStyling
    @IBAction func actionBtnCloseSubVw(_ sender: Any) {
        self.subVwTable.isHidden = true
    }
    
    func setDefaultStyling(){
        self.subVwTable.isHidden = true
        self.vwHombre.borderColor = UIColor.lightGray
        self.vwMujer.borderColor = UIColor.lightGray
        self.vwHombreMujer.borderColor = UIColor.lightGray
        
        self.vwPais.borderColor = UIColor.lightGray
        self.vwProvincia.borderColor = UIColor.lightGray
        self.vwMunicipio.borderColor = UIColor.lightGray
        
        self.vwChat.borderColor = UIColor.lightGray
        self.vwRelacion.borderColor = UIColor.lightGray
        self.vwAmistad.borderColor = UIColor.lightGray
        self.vwRelacionIntima.borderColor = UIColor.lightGray
    }
    
    func clearIwantFoundValues(){
        self.strSelectedIWantToBeFound = ""
        self.vwHombre.borderColor = UIColor.lightGray
        self.vwMujer.borderColor = UIColor.lightGray
        self.vwHombreMujer.borderColor = UIColor.lightGray
    }
    
    func clearIwantFoundInValues(){
        self.strSelectedIWantToBeFoundInCountry = "0"
        self.strSelectedIWantToBeFoundInState = "0"
        self.strSelectedIWantToBeFoundInCity = "0"
        self.vwPais.borderColor = UIColor.lightGray
        self.vwProvincia.borderColor = UIColor.lightGray
        self.vwMunicipio.borderColor = UIColor.lightGray
    }
    
    
    //MARK:- DropDown List Prepare
    func setDropDown(){

        self.tfSelectGender.optionArray = ["Soy un hombre", "Soy una mujer"]

        self.tfSelectGender.didSelect{(selectedText , index ,id) in
            if index == 0{
                self.selectedGender = "Male"
            }else{
                self.selectedGender = "Female"
            }
        self.tfSelectGender.text = selectedText
        }
    }
    
    @IBAction func btnOpenCamera(_ sender: Any) {
        self.setImage()
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    @IBAction func btnOpenCountryPicker(_ sender: Any) {
        self.subVwTable.isHidden = false
    }
    
    @IBAction func actionBtnHombre(_ sender: Any) {
        self.clearIwantFoundValues()
        self.vwHombre.borderColor =  UIColor.init(named: "AppSkyBlue")
        self.strSelectedIWantToBeFound = "Male"
        self.isGenderSelected = true
    }
    
    @IBAction func actioBtnMujer(_ sender: Any) {
        self.clearIwantFoundValues()
        self.vwMujer.borderColor =  UIColor.init(named: "AppSkyBlue")
        self.strSelectedIWantToBeFound = "Female"
        self.isGenderSelected = true
    }
    @IBAction func actionHombreMujer(_ sender: Any) {
        self.clearIwantFoundValues()
        self.vwHombreMujer.borderColor =  UIColor.init(named: "AppSkyBlue")
        self.strSelectedIWantToBeFound = ""
        self.isGenderSelected = true
    }
    
    @IBAction func actionBtnPais(_ sender: Any) {
        self.clearIwantFoundInValues()
        self.vwPais.borderColor =  UIColor.init(named: "AppSkyBlue")
        self.strSelectedIWantToBeFoundInCountry = "1"
    }
    
    @IBAction func actionBtnProvincia(_ sender: Any) {
        self.clearIwantFoundInValues()
        self.vwProvincia.borderColor =  UIColor.init(named: "AppSkyBlue")
        self.strSelectedIWantToBeFoundInState = "1"
    }
    
    @IBAction func actionBtnMuncipio(_ sender: Any) {
        self.clearIwantFoundInValues()
        self.vwMunicipio.borderColor =  UIColor.init(named: "AppSkyBlue")
        self.strSelectedIWantToBeFoundInCity = "1"
    }
    
    @IBAction func actionBtnChat(_ sender: Any) {
        if self.vwChat.borderColor == UIColor.lightGray{
            self.vwChat.borderColor = UIColor.init(named: "AppSkyBlue")
            self.isSelectedOne = true
        }else{
            self.vwChat.borderColor = UIColor.lightGray
            self.isSelectedOne = false
        }
    }
    @IBAction func actgionBtnRelacion(_ sender: Any) {
        if self.vwRelacion.borderColor == UIColor.lightGray{
            self.vwRelacion.borderColor = UIColor.init(named: "AppSkyBlue")
            self.isSelectedTwo = true
        }else{
            self.vwRelacion.borderColor = UIColor.lightGray
            self.isSelectedTwo = false
        }
    }
    @IBAction func actionBtnAmistad(_ sender: Any) {
        if self.vwAmistad.borderColor == UIColor.lightGray{
            self.vwAmistad.borderColor = UIColor.init(named: "AppSkyBlue")
            self.isSelectedThree = true
        }else{
            self.vwAmistad.borderColor = UIColor.lightGray
            self.isSelectedThree = false
        }
    }
    
    @IBAction func actionbtnRelacionIntima(_ sender: Any) {
        if self.vwRelacionIntima.borderColor == UIColor.lightGray{
            self.vwRelacionIntima.borderColor = UIColor.init(named: "AppSkyBlue")
            self.isSelectedFour = true
        }else{
            self.vwRelacionIntima.borderColor = UIColor.lightGray
            self.isSelectedFour = false
        }
    }
    
    @IBAction func btnActionSubmit(_ sender: Any) {
        self.validateForCompleteProfile()
    }
    
}

//MARK:- Set User Data
extension EditProfileViewController{
    
    func setUserData(){
        
        let profilePic = objAppShareData.UserDetail.strProfilePicture
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
        }
        
        self.tfName.text = objAppShareData.UserDetail.strName
        self.tfEmail.text = objAppShareData.UserDetail.strEmail
        
        if objAppShareData.UserDetail.strGender == "Male"{
            self.tfSelectGender.text = "Soy un hombre"
            self.selectedGender = "Male"
        }else{
            self.tfSelectGender.text = "Soy una mujer"
            self.selectedGender = "Female"
        }
        
        self.tfDOB.text = objAppShareData.UserDetail.strDob
        self.tfCountry.text = objAppShareData.UserDetail.strCountry
        self.tfState.text = objAppShareData.UserDetail.strState
        self.tfCity.text = objAppShareData.UserDetail.strCity
        
        self.txtVwAboutMe.text = objAppShareData.UserDetail.strAboutMe
        self.txtVwSpecificInformation.text = objAppShareData.UserDetail.strSpecialInstruction
        
        self.tfHairColor.text = objAppShareData.UserDetail.strHairColor
        self.tfEyeColor.text = objAppShareData.UserDetail.strEye
        self.tfSkinTone.text = objAppShareData.UserDetail.strSkinTone
        self.tfHeightInMeter.text = objAppShareData.UserDetail.strHeight
        self.tfMusic.text = objAppShareData.UserDetail.strMusic
        self.tfTheSportOf.text = objAppShareData.UserDetail.strSport
        self.tfCinema.text = objAppShareData.UserDetail.strCinema
        
        self.strSelectedCountry = objAppShareData.UserDetail.strCountry
        self.strSelectedState = objAppShareData.UserDetail.strState
        self.strSelectedCity = objAppShareData.UserDetail.strCity
        
        let lookingFor = objAppShareData.UserDetail.strLookingFor
        let arr = lookingFor.split(separator: ",")
        for data in arr{
            
            switch data {
            case "Chat":
                self.vwChat.borderColor = UIColor.init(named: "AppSkyBlue")
                self.isSelectedOne = true
            case "Relación":
                self.vwRelacion.borderColor = UIColor.init(named: "AppSkyBlue")
                self.isSelectedTwo = true
            case "Amistad":
                self.vwAmistad.borderColor = UIColor.init(named: "AppSkyBlue")
                self.isSelectedThree = true
            case "Relación íntima":
                self.vwRelacionIntima.borderColor = UIColor.init(named: "AppSkyBlue")
                self.isSelectedFour = true
            default:
                break
            }
        }
    
        if objAppShareData.UserDetail.strAllowCountry == "1"{
            self.strSelectedIWantToBeFoundInCountry = "1"
            self.vwPais.borderColor =  UIColor.init(named: "AppSkyBlue")
        }
        
        if objAppShareData.UserDetail.strAllowState == "1"{
            self.strSelectedIWantToBeFoundInState = "1"
            self.vwProvincia.borderColor =  UIColor.init(named: "AppSkyBlue")
        }
        
        if objAppShareData.UserDetail.strAllowCity == "1"{
            self.strSelectedIWantToBeFoundInCity = "1"
            self.vwMunicipio.borderColor =  UIColor.init(named: "AppSkyBlue")
        }
        
        if objAppShareData.UserDetail.strAllowSex == "Male"{
            self.vwHombre.borderColor = UIColor.init(named: "AppSkyBlue")
            self.isGenderSelected = true
        }
        if objAppShareData.UserDetail.strAllowSex == "Female"{
            self.vwMujer.borderColor = UIColor.init(named: "AppSkyBlue")
            self.isGenderSelected = true
        }
        if objAppShareData.UserDetail.strAllowSex == ""{
            self.vwHombreMujer.borderColor = UIColor.init(named: "AppSkyBlue")
            self.isGenderSelected = true
        }
    }
    
}

//MARK:- UIDatePicker
extension EditProfileViewController{
    
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
extension EditProfileViewController:UITableViewDelegate,UITableViewDataSource{
    
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
        let cell = tblCountry.dequeueReusableCell(withIdentifier: "OptionsRegistrationTableViewCell")as! OptionsRegistrationTableViewCell
        
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
            
            self.call_WsGetState(strCountryID: strCountryID)
            
        }else if self.strType == "State"{
            self.strType = "City"
            let strStateID = self.arrState[indexPath.row].strStateID
            
            self.strSelectedStateID = strStateID
            self.tfState.text = self.arrState[indexPath.row].strStateName
            
            self.call_WsGetCity(strStateID: strStateID)
           
        }else if self.strType == "City"{
            self.strSelectedStateID = self.arrCity[indexPath.row].strCityID
            self.tfCity.text = self.arrCity[indexPath.row].strCityName
            self.subVwTable.isHidden = true
        }
    }
}

//MARK:- Searching
extension EditProfileViewController{
    
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
                self.tblCountry.displayBackgroundText(text: "No Record Found")
            }else{
                self.tblCountry.displayBackgroundText(text: "")
            }
           // self.arrPhoneContactsFiltered = self.arrPhoneContactsFiltered.sorted(by: { $0.sort > $1.sort})
            self.tblCountry.reloadData()
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
                self.tblCountry.displayBackgroundText(text: "No Record Found")
            }else{
                self.tblCountry.displayBackgroundText(text: "")
            }
           // self.arrPhoneContactsFiltered = self.arrPhoneContactsFiltered.sorted(by: { $0.sort > $1.sort})
            self.tblCountry.reloadData()
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
                self.tblCountry.displayBackgroundText(text: "No Record Found")
            }else{
                self.tblCountry.displayBackgroundText(text: "")
            }
           // self.arrPhoneContactsFiltered = self.arrPhoneContactsFiltered.sorted(by: { $0.sort > $1.sort})
            self.tblCountry.reloadData()
        }
    }
    
    
}

// MARK:- UIImage Picker Delegate
extension EditProfileViewController: UIImagePickerControllerDelegate{
    
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


extension EditProfileViewController{
    
    //MARK:- All Validations
    func validateForCompleteProfile(){
        self.tfName.text = self.tfName.text!.trim()
        self.tfEmail.text = self.tfEmail.text!.trim()
        self.tfDOB.text = self.tfDOB.text!.trim()
        self.tfSelectGender.text = self.tfSelectGender.text?.trim()
        self.tfCountry.text = self.tfCountry.text!.trim()
        self.tfState.text = self.tfState.text!.trim()
        self.tfCity.text = self.tfCity.text!.trim()
        self.txtVwAboutMe.text = self.txtVwAboutMe.text?.trim()
        
        
        if (tfName.text?.isEmpty)! {
            objAlert.showAlert(message: "¡No puede estar vacío!", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfEmail.text?.isEmpty)! {
            objAlert.showAlert(message: "¡No puede estar vacío!", title:MessageConstant.k_AlertTitle, controller: self)
        }else if !objValidationManager.validateEmail(with: tfEmail.text!){
            objAlert.showAlert(message: "¡No puede estar vacío!", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfSelectGender.text?.isEmpty)!{
            objAlert.showAlert(message: "Seleccione género!", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfDOB.text?.isEmpty)! {
            objAlert.showAlert(message: "Seleccionar fecha de nacimiento", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfCountry.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.CountrySelection, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfState.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.stateSelection, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfCity.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.citySelection, title:MessageConstant.k_AlertTitle, controller: self)
        }

        else if self.isGenderSelected == false {
            objAlert.showAlert(message: "Quiero que me encuentres", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if self.vwPais.borderColor == UIColor.lightGray  && self.vwProvincia.borderColor == UIColor.lightGray && self.vwMunicipio.borderColor == UIColor.lightGray  {
            objAlert.showAlert(message: "Quiero que me encuentren en", title:MessageConstant.k_AlertTitle, controller: self)
        }
        
        else if self.isSelectedOne == false && self.isSelectedTwo == false && self.isSelectedThree == false && self.isSelectedFour == false {
            objAlert.showAlert(message: "Encontrar personas que quieran", title:MessageConstant.k_AlertTitle, controller: self)
        }
        
        else{
            
            self.callWebserviceCompleteProfile()
            
        }
    }
    
}



extension EditProfileViewController{
    // MARK:- Get Profile
    
    func call_GetProfile(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
     //   objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getUserProfile, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let user_details  = response["result"] as? [String:Any] {
                       
                        objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                        objAppShareData.fetchUserInfoFromAppshareData()
                    
                    self.setUserData()
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


//MARK:- CallAPIGetCountries
extension EditProfileViewController{
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
                    
                    self.tblCountry.reloadData()
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
                    self.tblCountry.reloadData()
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
                    self.tblCountry.reloadData()
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


//MARK:- Complete Profile
extension EditProfileViewController{
    
    
    func callWebserviceCompleteProfile(){
        
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
        
        
        if self.tfDOB.text != ""{
            self.strAge = Date().calculateAgeFromDate(strDate: self.tfDOB.text!, strFormatter: "yyyy-MM-dd")
        }
        
        var lookingFor = ""
        if isSelectedOne{
            lookingFor = "Chat"
            lookingFor = lookingFor.trim()
        }
        if isSelectedTwo{
            lookingFor =  "\(lookingFor),Relación"
            lookingFor = lookingFor.trim()
        }
        if isSelectedThree{
            lookingFor =  "\(lookingFor),Amistad"
            lookingFor = lookingFor.trim()
        }
        if isSelectedFour{
            lookingFor =  "\(lookingFor),Relación íntima"
            lookingFor = lookingFor.trim()
        }
        
        if lookingFor.hasPrefix(","){
            lookingFor.remove(at: lookingFor.startIndex)
        }
        
        let dicrParam = ["name":self.tfName.text!,
                         "email":self.tfEmail.text!,
                         "user_id":objAppShareData.UserDetail.strUserId,
                         "looking_for":lookingFor,
                         "dob":self.tfDOB.text!,
                         "age":self.strAge,
                         "country":self.tfCountry.text!,
                         "state":self.tfState.text!,
                         "city":self.tfCity.text!,
                         "sex":self.selectedGender,
                         "short_bio":self.txtVwAboutMe.text!,
                         "hair":self.tfHairColor.text!,
                         "eye":self.tfEyeColor.text!,
                         "skin":self.tfSkinTone.text!,
                         "height":self.tfHeightInMeter.text!,
                         "music":self.tfMusic.text!,
                         "sport":self.tfTheSportOf.text!,
                         "cinema":self.tfCinema.text!,
                         "highlight_info":self.txtVwSpecificInformation.text!,
                         "allow_sex":strSelectedIWantToBeFound,
                         "allow_country":self.strSelectedIWantToBeFoundInCountry,
                         "allow_state":self.strSelectedIWantToBeFoundInState,
                         "allow_city":self.strSelectedIWantToBeFoundInCity]as [String:Any]
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_completeProfile, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "user_image", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
            
                let user_details  = response["result"] as? [String:Any]

                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                objAppShareData.fetchUserInfoFromAppshareData()

                if self.isComingFrom == "Basic Information"{
                    objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "", message: "Actualización de información básica con éxito", controller: self) {
                        self.onBackPressed()
                    }
                }else{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
                    let navController = UINavigationController(rootViewController: vc)
                    navController.isNavigationBarHidden = true
                    appDelegate.window?.rootViewController = navController
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }
    
}
