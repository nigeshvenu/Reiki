//
//  ForgotPasswordVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 05/09/22.
//

import UIKit
import FlagPhoneNumber

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet var emailCheckBtn: UIButton!
    @IBOutlet var emailView: UIView!
    @IBOutlet var mobileCheckBtn: UIButton!
    @IBOutlet var mobileView: UIView!
    @IBOutlet var countryCodeTxt: UITextField!
    @IBOutlet var mobileTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var enterLbl: UILabel!
    
    var signupViewModal = SignupVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    func initialSettings(){
        emailTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setTextfieldPadding(textfield: emailTxt)
        countryCodeTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        mobileTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setTextfieldPadding(textfield: mobileTxt)
        selectbtn(btn: mobileCheckBtn, selectedView: mobileView)
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
    
    @IBAction func emailCheckBtnClicked(_ sender: UIButton) {
        enterLbl.text = "Enter Email"
        emailTxt.isHidden = false
        mobileTxt.isHidden = true
        emailTxt.becomeFirstResponder()
        selectbtn(btn: sender, selectedView: emailView)
    }
    
    @IBAction func mobileNumberCheckBtnClicked(_ sender: UIButton) {
        enterLbl.text = "Enter Mobile Number"
        emailTxt.isHidden = true
        mobileTxt.isHidden = false
        mobileTxt.becomeFirstResponder()
        selectbtn(btn: sender, selectedView: mobileView)
    }
    
    func selectbtn(btn:UIButton,selectedView:UIView){
        emailCheckBtn.layer.borderWidth = 0.0
        emailCheckBtn.isSelected = false
        emailView.isHidden = true
        mobileCheckBtn.layer.borderWidth = 0.0
        mobileCheckBtn.isSelected = false
        mobileView.isHidden = true
        if !btn.isSelected{
            btn.isSelected = true
            btn.layer.borderColor = UIColor.init(hexString: "#AA3270").cgColor
            btn.layer.borderWidth = 1.0
            selectedView.isHidden = false
        }
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        if validateFields(){
            self.validatePhoneNumber()
        }
    }
    
    func validateFields()->Bool{
        guard let mobile = mobileTxt.text,!mobile.isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.enterPhoneNumber, type: .danger)
            return false
        }
        if mobile.count < 14{
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.invalidPhoneNumber, type: .danger)
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

extension ForgotPasswordVC{

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

extension ForgotPasswordVC : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryCodeTxt{
            openCountryListVC()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if textField.keyboardType == .phonePad{
            // make sure the result is under 16 characters
            textField.text = format(with: "(XXX) XXX-XXXX", phone: updatedText)
            return false
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

extension ForgotPasswordVC{
    
    func validatePhoneNumber(){
        let phoneCode = countryCodeTxt.text ?? ""
        let phoneNumber = mobileTxt.text!.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression)
        let param = ["phone_code":phoneCode,
        "phone":phoneNumber] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        signupViewModal.forgotPwd(urlParams: param, param: nil, onSuccess: { message in
           AppDelegate.shared.showLoading(isShow: false)
            self.view.endEditing(true)
            self.mobileTxt.text = ""
            SwiftMessagesHelper.showSwiftMessage(title: "", body: message, type: .success)
            let VC = self.getOtpVC()
            VC.VC = "forgotpassword"
            VC.isEditProfile = false
            VC.countryCode = phoneCode
            VC.mobileNumber = phoneNumber
            self.navigationController?.pushViewController(VC, animated: true)
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
}
