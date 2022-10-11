//
//  LoginPageVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 30/08/22.
//

import UIKit
import FlagPhoneNumber

class LoginPageVC: UIViewController {

    @IBOutlet var mobileNumberTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var countryCodeTxt: UITextField!
    
    var viewModal = LoginVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    func initialSettings(){
        mobileNumberTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        passwordTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        countryCodeTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setTextfieldPadding(textfield: mobileNumberTxt, leftWidth: 10, rightWidth: 10)
        setTextfieldPadding(textfield: passwordTxt, leftWidth: 10, rightWidth: 50)
        mobileNumberTxt.attributedPlaceholder = NSAttributedString(
            string: "Mobile Number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        passwordTxt.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        let countryCode = CountryCallingCode.countryNamesByCode(code: Locale.current.regionCode ?? "")
        countryCodeTxt.text = countryCode
    }
    
    func setTextfieldPadding(textfield:UITextField,leftWidth:Int,rightWidth:Int){
        let btnViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: leftWidth, height: 50))
        let btnViewRight = UIView(frame: CGRect(x: 0, y: 0, width: rightWidth, height: 50))
        textfield.rightViewMode = .always
        textfield.rightView = btnViewRight
        textfield.leftView = btnViewLeft
        textfield.leftViewMode = .always
    }
    
    @IBAction func showPasswordBtn(_ sender: UIButton) {
        if !sender.isSelected{
            sender.isSelected = true
            passwordTxt.isSecureTextEntry = false
            sender.setImage(UIImage(named: "showeye"), for: .normal)
        }else{
            sender.isSelected = false
            passwordTxt.isSecureTextEntry = true
            sender.setImage(UIImage(named: "hideeye"), for: .normal)
        }
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        if validateFieldValues(){
            self.loginRequest()
        }
    }
    
    func validateFieldValues()->Bool{
        guard let mobileNumber = mobileNumberTxt.text,!mobileNumber.trimmingCharacters(in: .whitespaces).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.enterPhoneNumber, type: .danger)
            return false
        }
        /*if mobileNumber.count < 14{
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.invalidPhoneNumber, type: .danger)
            return false
        }*/
        guard let password = passwordTxt.text,!password.trimmingCharacters(in: .whitespaces).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.passwordEmptyAlert, type: .danger)
            return false
        }
        return true
    }
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        clearLogin()
        let VC = self.getViewControllerVC()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func forgotPasswordBtnClicked(_ sender: Any) {
        clearLogin()
        let VC = self.getForgotPasswordVC()
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    func clearLogin(){
        let countryCode = CountryCallingCode.countryNamesByCode(code: Locale.current.regionCode ?? "")
        countryCodeTxt.text = countryCode
        self.mobileNumberTxt.text = ""
        self.passwordTxt.text = ""
        self.view.endEditing(true)
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

extension LoginPageVC{

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

extension LoginPageVC : UITextFieldDelegate{
    
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

extension LoginPageVC{
    
    func loginRequest(){
        let countryCode = countryCodeTxt.text ?? ""
        let mobile = mobileNumberTxt.text!.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression)
        let param = ["username":countryCode+mobile,
                     "password":passwordTxt.text!,
                     "info":["device_token":""]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.login(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.loginSuccess, type: .success)
            self.mobileNumberTxt.text = ""
            self.passwordTxt.text = ""
            self.view.endEditing(true)
            let VC = self.getHomePageVC()
            self.navigationController?.pushViewController(VC, animated: true)
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
  
}
