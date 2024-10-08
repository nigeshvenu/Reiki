//
//  EditProfileVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 06/09/22.
//

import UIKit
import TOCropViewController

protocol ProfileEditDelegate {
    func profileEdited()
}

struct PickerModal {
    var id = ""
    var name = ""
    var uniqueId = ""
    
}

class EditProfileVC: UIViewController {
    
    @IBOutlet var gradientView: GradientView!
    @IBOutlet var userImageView: CustomImageView!
    @IBOutlet var firstNameTxt: UITextField!
    @IBOutlet var lastNametxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var mobileNumberTxt: UITextField!
    @IBOutlet var cityTxt: UITextField!
    @IBOutlet var stateTxt: UITextField!
    @IBOutlet var zipTxt: UITextField!
    @IBOutlet var timeZoneTxt: UITextField!
    @IBOutlet var descriptionTxtView: UITextView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var toolBar: UIToolbar!
    
    var delegate:ProfileEditDelegate?
    var imagePicker : ImagePicker?
    var isRemoveImage = false
    var selectedImage : UIImage?
    var viewModal = EditProfileVM()
    var isUpdated = false
    var textViewPlaceholderColor = UIColor.lightGray
    var textViewTextColor = UIColor.black
    var pickerData = [PickerModal]()
    var selectedTimeZone : PickerModal?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if imagePicker == nil{
            imagePicker = ImagePicker(presentationController: self,editing: false, delegate: self)
        }
    }
    
    func initialSettings(){
        gradientView.roundCorners(cornerRadius: 20.0, cornerMask: [.layerMinXMaxYCorner,.layerMaxXMaxYCorner])
        firstNameTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setPlaceholderColor(textfield: firstNameTxt)
        lastNametxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setPlaceholderColor(textfield: lastNametxt)
        emailTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setPlaceholderColor(textfield: emailTxt)
        mobileNumberTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setPlaceholderColor(textfield: mobileNumberTxt)
        //mobileNumberTxt.isEnabled = false
        cityTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setPlaceholderColor(textfield: cityTxt)
        stateTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setPlaceholderColor(textfield: stateTxt)
        zipTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setPlaceholderColor(textfield: zipTxt)
        setTextfieldPadding(textfield: firstNameTxt)
        setTextfieldPadding(textfield: lastNametxt)
        setTextfieldPadding(textfield: emailTxt)
        setTextfieldPadding(textfield: mobileNumberTxt)
        setTextfieldPadding(textfield: cityTxt)
        setTextfieldPadding(textfield: stateTxt)
        setTextfieldPadding(textfield: zipTxt)
        setTextfieldPadding(textfield: timeZoneTxt)
        descriptionTxtView.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        descriptionTxtView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        descriptionTxtView.layer.borderWidth = 1.0
        descriptionTxtView.layer.borderColor = UIColor.init(hexString: "#E3E1E1").cgColor
        timeZoneTxt.inputView = pickerView
        setUI()
    }
    
    func setPlaceholderColor(textfield:UITextField){
        textfield.attributedPlaceholder = NSAttributedString(
            string: textfield.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
    }
    
    func setTextfieldPadding(textfield:UITextField){
        let btnViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        let btnViewRight = UIView(frame: CGRect(x: 0, y: 0, width: textfield == timeZoneTxt ? 45 : 10, height: 50))
        textfield.rightViewMode = .always
        textfield.rightView = btnViewRight
        textfield.leftView = btnViewLeft
        textfield.leftViewMode = .always
    }
    
    func setUI(){
        let user = UserModal.sharedInstance
        userImageView.ImageViewLoading(mediaUrl: UserModal.sharedInstance.image, placeHolderImage: UIImage(named: "no_image"))
        firstNameTxt.text = user.firstName
        lastNametxt.text = user.lastName
        emailTxt.text = user.email
        mobileNumberTxt.text = "(\(user.phoneCode)) \(user.phone.applyPatternOnNumbers(pattern: "(###) ###-####", replacmentCharacter: "#"))"
        cityTxt.text = user.city
        stateTxt.text = user.state
        zipTxt.text = user.zip
        descriptionTxtView.text = user.aboutMe.isEmpty ? "Write something.." : user.aboutMe
        descriptionTxtView.textColor = user.aboutMe.isEmpty ? textViewPlaceholderColor : textViewTextColor
        if user.timeZone != nil{
            var modal = PickerModal()
            modal.id = user.timeZone!.id
            modal.name = user.timeZone!.name
            modal.uniqueId = user.timeZone!.value
            selectedTimeZone = modal
            timeZoneTxt.text = user.timeZone!.name
        }
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        if isUpdated{
            self.alert()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func timeZoneBtnClicked(_ sender: Any) {
        
        if !timeZoneTxt.isFirstResponder{
            timeZoneTxt.becomeFirstResponder()
        }
    }
    
    
    @IBAction func cameraBtnClicked(_ sender: UIButton) {
        imagePicker?.present(from: sender)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        if validateFieldValues(){
            self.editProfileRequest()
        }
    }
    
    func validateFieldValues()->Bool{
        if UserModal.sharedInstance.image.isEmpty && selectedImage == nil{
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.imageEmpty, type: .danger)
            return false
        }
        guard let firstName = firstNameTxt.text,!firstName.trimmingCharacters(in: .whitespaces).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.firstNameEmpty, type: .danger)
            return false
        }
        guard let lastName = lastNametxt.text,!lastName.trimmingCharacters(in: .whitespaces).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.lastNameEmpty, type: .danger)
            return false
        }
        guard let email = emailTxt.text,!email.trimmingCharacters(in: .whitespaces).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.emailEmptyAlert, type: .danger)
            return false
        }
        if !isValidEmail(testStr: email){
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.emailInvalidAlert, type: .danger)
            return false
        }
        guard let city = cityTxt.text,!city.trimmingCharacters(in: .whitespaces).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.cityEmpty, type: .danger)
            return false
        }
        guard let state = stateTxt.text,!state.trimmingCharacters(in: .whitespaces).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.stateEmpty, type: .danger)
            return false
        }
        /*guard let zip = zipTxt.text,!zip.trimmingCharacters(in: .whitespaces).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.zipEmpty, type: .danger)
            return false
        }*/
        /*if zipTxt.text!.count < 6{
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.zipeCodeInvalid, type: .danger)
            return false
        }*/
        guard let timeZone = timeZoneTxt.text,!timeZone.trimmingCharacters(in: .whitespaces).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.timeZoneEmpty, type: .danger)
            return false
        }
        guard let aboutMe = descriptionTxtView.text,!aboutMe.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.aboutMeEmpty, type: .danger)
            return false
        }
        if descriptionTxtView.textColor == textViewPlaceholderColor{
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.aboutMeEmpty, type: .danger)
            return false
        }
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditProfileVC : ImagePickerDelegate,TOCropViewControllerDelegate{
    func cancelClicked() {
        
    }
    func didSelect(image: UIImage?,fileUrl:URL?, isRemove: Bool) {
        if isRemove{
            self.isRemoveImage = isRemove
            selectedImage = nil
            userImageView.image = nil
            return
        }
        if image != nil{
            presentCropViewController(image: image!)
        }
    }
    
    func presentCropViewController(image:UIImage) {
        let cropViewController = TOCropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.customAspectRatio = CGSize(width: 414, height: 504)
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        isUpdated = true
        selectedImage = image
        userImageView.image = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileVC{
    
    func timeZoneRequest(){
        let param = ["sort":[["name","ASC"]],"offset":0,"limit":-1,"active":true] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.getTimeZones(urlParams: param, param: nil, onSuccess: { message in
           AppDelegate.shared.showLoading(isShow: false)
            if self.viewModal.timeZoneArray.count > 0{
                self.timeZoneTxt.becomeFirstResponder()
            }
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func editProfileRequest(){
        let param = getParam()
        AppDelegate.shared.showLoading(isShow: true)
        if selectedImage == nil{
            viewModal.updateUser(urlParams: nil, param: param, onSuccess: { message in
                AppDelegate.shared.showLoading(isShow: false)
                SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.profileUpdated, type: .success)
                self.navigationController?.popViewController(animated: true)
                self.delegate?.profileEdited()
            }, onFailure: { error in
                AppDelegate.shared.showLoading(isShow: false)
                SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
            })
        }else{
            viewModal.updateUserProfile(param: param, removeImage: isRemoveImage, image: selectedImage, fileName: "image_file", onSuccess: { message in
                AppDelegate.shared.showLoading(isShow: false)
                SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.profileUpdated, type: .success)
                self.navigationController?.popViewController(animated: true)
                self.delegate?.profileEdited()
            }, onFailure: { error in
                AppDelegate.shared.showLoading(isShow: false)
                SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
            })
        }
    }
    
    func getParam()->[String:Any]{
        var param : [String:Any] = [:]
        param.updateValue(firstNameTxt.text!.trimmingCharacters(in: .whitespaces), forKey: "first_name")
        param.updateValue(lastNametxt.text!.trimmingCharacters(in: .whitespaces), forKey: "last_name")
        param.updateValue(emailTxt.text!.trimmingCharacters(in: .whitespaces), forKey: "email")
        param.updateValue(cityTxt.text?.trimmingCharacters(in: .whitespaces) ?? "", forKey: "city")
        param.updateValue(stateTxt.text?.trimmingCharacters(in: .whitespaces) ?? "", forKey: "state")
        
        if let zip = zipTxt.text,!zip.trimmingCharacters(in: .whitespaces).isEmpty{
            param.updateValue(zip.trimmingCharacters(in: .whitespaces), forKey: "zip")
        }else{
            param.updateValue(NSNull(), forKey: "zip")
        }
        
        if selectedTimeZone != nil{
            param.updateValue(Int(selectedTimeZone!.id)!, forKey: "timezone_id")
        }
        param.updateValue(descriptionTxtView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", forKey: "about_me")
        return param
    }
}

extension EditProfileVC : ChangeMobileNumberDelegate{
    func phoneChanged() {
        let user = UserModal.sharedInstance
        self.mobileNumberTxt.text = "(\(user.phoneCode)) \(user.phone.applyPatternOnNumbers(pattern: "(###) ###-####", replacmentCharacter: "#"))"
    }
}

extension EditProfileVC : UIPickerViewDataSource,UIPickerViewDelegate{
    
    //MARK: - Pickerview method
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
   }
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return pickerData.count
   }
   
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return pickerData[row].name
   }
   
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.timeZoneTxt.text = pickerData[row].name
        self.selectedTimeZone = pickerData[row]
   }
    
    func setupTimeZonePickerView(){
        self.pickerData.removeAll()
        for i in self.viewModal.timeZoneArray{
            var modal = PickerModal()
            modal.id = i.id
            modal.name = i.name
            modal.uniqueId = i.value
            self.pickerData.append(modal)
        }
        self.pickerView.reloadAllComponents()
        if self.selectedTimeZone == nil{
            self.selectedTimeZone = self.self.pickerData[0]
            self.timeZoneTxt.text = self.pickerData[0].name
            self.pickerView.selectRow(0, inComponent: 0, animated: false)
        }else{
            if let indexState = self.pickerData.firstIndex(where: { ( $0.id == self.selectedTimeZone?.id ) }){
                self.pickerView.selectRow(indexState, inComponent: 0, animated: false)
            }
        }
    }
    
}

extension EditProfileVC : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == timeZoneTxt{
            if viewModal.timeZoneArray.count == 0{
                self.timeZoneRequest()
                return false
            }else{
                self.setupTimeZonePickerView()
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       if textField == mobileNumberTxt{
            self.view.endEditing(true)
            let VC = self.getChangeMobileNumberVC()
            VC.delegate = self
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTxt{
            lastNametxt.becomeFirstResponder()
        }else if textField == lastNametxt{
            emailTxt.becomeFirstResponder()
        }else if textField == emailTxt{
            textField.resignFirstResponder()
        }else if textField == mobileNumberTxt{
            cityTxt.becomeFirstResponder()
        }else if textField == cityTxt{
            stateTxt.becomeFirstResponder()
        }else if textField == stateTxt{
            zipTxt.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isUpdated = true
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if textField == firstNameTxt || textField == lastNametxt{
            let regex = try! NSRegularExpression(pattern: "[a-zA-Z\\s]+", options: [])
            let range = regex.rangeOfFirstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count))
            return range.length == string.count && updatedText.count <= 30
        }else if textField.keyboardType == .phonePad{
            // make sure the result is under 16 characters
            textField.text = format(with: "(XXX) XXX-XXXX", phone: updatedText)
            return false
        }else if textField == zipTxt{
           // make sure the result is under 16 characters
           return updatedText.count <= 10
        }
        return true
    }
    
    /// mask example: `+X (XXX) XXX-XXXX`
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}

extension EditProfileVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == textViewPlaceholderColor {
            textView.text = nil
            textView.textColor = textViewTextColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write something.."
            textView.textColor = textViewPlaceholderColor
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        isUpdated = true
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 300    // 300 Limit Value
    }
}

extension EditProfileVC{
    
    func alert(){
        let VC = self.getPopUpVC()
        VC.titleString = "Unsaved Changes"
        VC.messageString = MessageHelper.PopupMessage.saveProfileMessage
        VC.noBtnClick  = { [weak self]  in
            self?.navigationController?.popViewController(animated: true)
        }
        VC.yesBtnClick  = { [weak self]  in
            self?.saveBtnClicked(self)
        }
        VC.modalPresentationStyle = .overFullScreen
        self.present(VC, animated: false, completion: nil)
    }
    
    /*func alert(){
            
        let alert = UIAlertController(title: "Unsaved Changes", message: MessageHelper.PopupMessage.saveProfileMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }*/

}
