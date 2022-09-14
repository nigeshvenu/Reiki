//
//  ViewController.swift
//  Reiki
//
//  Created by NewAgeSMB on 18/08/22.
//

import UIKit
import SwiftyAttributes
import FlagPhoneNumber

class ViewController: UIViewController {

    @IBOutlet var agreementTextView: UITextView!
    @IBOutlet var firstNameTxt: UITextField!
    @IBOutlet var lastNameTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var mobileTxt: UITextField!
    @IBOutlet var checkImageView: UIImageView!
    @IBOutlet var checkBtn: UIButton!
    @IBOutlet var countryCodeTxt: UITextField!
    
    var viewModal = SignupVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    func initialSettings(){
        firstNameTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setTextfieldPadding(textfield: firstNameTxt)
        lastNameTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setTextfieldPadding(textfield: lastNameTxt)
        emailTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setTextfieldPadding(textfield: emailTxt)
        mobileTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setTextfieldPadding(textfield: mobileTxt)
        countryCodeTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        //setTextfieldPadding(textfield: countryCodeTxt)
        setAgreementTextView()
        let countryCode = CountryCallingCode.countryNamesByCode(code: Locale.current.regionCode ?? "IN")
        //let countryCode = CountryCallingCode.countryNamesByCode(code: "IN")
        countryCodeTxt.text = countryCode
    }
    
    func setTextfieldPadding(textfield:UITextField){
        let btnViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        let btnViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textfield.rightViewMode = .always
        textfield.rightView = btnViewRight
        textfield.leftView = btnViewLeft
        textfield.leftViewMode = .always
    }
    
    @IBAction func checkBtnClicked(_ sender: UIButton) {
        if !sender.isSelected{
            sender.isSelected = true
            sender.backgroundColor = UIColor.init(hexString: "#6DA741")
        }else{
            sender.isSelected = false
            sender.backgroundColor = UIColor.init(hexString: "#E2E2E2")
        }
    }
    
    func setAgreementTextView(){
        let font = FontHelper.montserratFontSize(fontType: .Light, size: 15.0)
        let fontBold = FontHelper.montserratFontSize(fontType: .semiBold, size: 14.0)
        let color1 = UIColor.init(hexString: "#73697C")
        let color = UIColor.init(hexString: "#4F4A58")
        let terms = "Terms & Conditions".withTextColor(color).withFont(fontBold).withLink(URL(string: "terms://termsofCondition")!)
        let privacy = "Privacy Policy".withTextColor(color).withFont(fontBold).withLink(URL(string: "privacy://privacyPolicy")!)
        agreementTextView.attributedText = "By signing below, you agree to the\n ".withTextColor(color1).withFont(font) + terms + " & ".withTextColor(color1).withFont(font) +  privacy
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signupBtnClicked(_ sender: Any) {
        if validateFieldValues(){
            self.validatePhoneNumber()
        }
    }
    
    func validateFieldValues()->Bool{
        guard let firstName = firstNameTxt.text,!firstName.trimmingCharacters(in: .whitespaces).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.firstNameEmpty, type: .danger)
            return false
        }
        guard let lastName = lastNameTxt.text,!lastName.trimmingCharacters(in: .whitespaces).isEmpty else {
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
        guard let mobile = mobileTxt.text,!mobile.trimmingCharacters(in: .whitespaces).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.enterPhoneNumber, type: .danger)
            return false
        }
        if mobile.count < 14{
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.invalidPhoneNumber, type: .danger)
            return false
        }
        if !checkBtn.isSelected{
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.agreementNotAccepted, type: .danger)
            return false
         }
         return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension ViewController{

    func openCountryListVC(){
        let  listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
        listController.setup(repository: FPNCountryRepository())
        let navigationViewController = UINavigationController(rootViewController: listController)
        listController.title = "Countries"
        listController.didSelect = { [weak self] country in
            print(country)
            self?.countryCodeTxt.text = country.phoneCode
        }
        self.present(navigationViewController, animated: true, completion: nil)
    }
    
}

extension ViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTxt{
            lastNameTxt.becomeFirstResponder()
        }else if textField == lastNameTxt{
            emailTxt.becomeFirstResponder()
        }else if textField == emailTxt{
            mobileTxt.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryCodeTxt{
            openCountryListVC()
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if textField == firstNameTxt || textField == lastNameTxt{
            let regex = try! NSRegularExpression(pattern: "[a-zA-Z\\s]+", options: [])
            let range = regex.rangeOfFirstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count))
            return range.length == string.count
        }else if textField.keyboardType == .phonePad{
            // make sure the result is under 16 characters
            textField.text = format(with: "(XXX) XXX-XXXX", phone: updatedText)
            return false
        }else if textField == firstNameTxt || textField == lastNameTxt{
            // make sure the result is under 16 characters
            return updatedText.count <= 30
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

extension ViewController : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

        if URL.scheme == "terms" {
            //push view controller 1
            let VC = self.getWebViewVC()
            VC.agreementHeaderTitle = "Terms & Conditions"
            VC.showBackBtn = true
            self.navigationController?.pushViewController(VC, animated: true)
            return false
        } else  if URL.scheme == "privacy"{
           // pushViewcontroller 2
            let VC = self.getWebViewVC()
            VC.agreementHeaderTitle = "Privacy Policy"
            VC.showBackBtn = true
            self.navigationController?.pushViewController(VC, animated: true)
            return false
        }
        return true
        // let the system open this URL
    }
}

extension ViewController{
    
    func validatePhoneNumber(){
        let phoneCode = countryCodeTxt.text ?? ""
        let phoneNumber = mobileTxt.text!.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression)
        let param = ["phone_code":phoneCode,
        "phone":phoneNumber] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.validatePhone(urlParams: param, param: nil, onSuccess: { message in
           AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.otpSent, type: .success)
            let VC = self.getSignupOtpVC()
            VC.firstName = self.firstNameTxt.text ?? ""
            VC.lastName = self.lastNameTxt.text ?? ""
            VC.email = self.emailTxt.text ?? ""
            VC.countryCode = self.countryCodeTxt.text ?? ""
            VC.mobileNumber = self.mobileTxt.text ?? ""
            self.navigationController?.pushViewController(VC, animated: true)
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
}
