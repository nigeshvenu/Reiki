//
//  ChangeMobileNumberVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 09/09/22.
//

import UIKit
import SideMenu
import FlagPhoneNumber

class ChangeMobileNumberVC: UIViewController {
    
    @IBOutlet var countryCodeTxt: UITextField!
    @IBOutlet var mobileTxt: UITextField!
    
    var viewModal = LoginVM()
    var signupViewModal = SignupVM()
    var delegate : ChangeMobileNumberDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    func initialSettings(){
        countryCodeTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        mobileTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setPlaceholderColor(textfield: mobileTxt)
        setTextfieldPadding(textfield: mobileTxt)
        //sidemenu
        /*SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
        sideMenuSettings()
        SideMenuManager.default.leftMenuNavigationController?.sideMenuDelegate = self*/
        let countryCode = CountryCallingCode.countryNamesByCode(code: Locale.current.regionCode ?? "")
        //let countryCode = CountryCallingCode.countryNamesByCode(code: "IN")
        countryCodeTxt.text = countryCode
    }
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setPlaceholderColor(textfield:UITextField){
        textfield.attributedPlaceholder = NSAttributedString(
            string: textfield.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
    }
    
    func setTextfieldPadding(textfield:UITextField){
        let btnViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        let btnViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textfield.rightViewMode = .always
        textfield.rightView = btnViewRight
        textfield.leftView = btnViewLeft
        textfield.leftViewMode = .always
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        if validateFields(){
            validatePhoneNumber()
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
    
    func sideMenuSettings(){
        var settings = SideMenuSettings()
        let appScreenRect = UIApplication.shared.keyWindow?.bounds ?? UIWindow().bounds
        let minimumSize = min(appScreenRect.width, appScreenRect.height)
        settings.menuWidth = round(minimumSize * 0.82)
        settings.presentationStyle = .menuSlideIn
        settings.presentationStyle.presentingEndAlpha = 0.5
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "sideMenu" {
            if let sideMenu = segue.destination as? SideMenuNavigationController{
                if let rootVC = sideMenu.viewControllers.first as? SideMenuVC{
                    rootVC.delegate = self
                    rootVC.ParentNavigationController = self.navigationController
                    sideMenuSettings()
                }
            }
        //}
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

extension ChangeMobileNumberVC{

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

extension ChangeMobileNumberVC : UITextFieldDelegate{
    
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

extension ChangeMobileNumberVC{
    
    func validatePhoneNumber(){
        let phoneCode = countryCodeTxt.text ?? ""
        let phoneNumber = mobileTxt.text!.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression)
        let param = ["phone_code":phoneCode,
        "phone":phoneNumber] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        signupViewModal.validatePhone(urlParams: param, param: nil, onSuccess: { message in
           AppDelegate.shared.showLoading(isShow: false)
            self.view.endEditing(true)
            self.mobileTxt.text = ""
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.otpSent, type: .success)
            let VC = self.getOtpVC()
            VC.isEditProfile = true
            VC.delegate = self.delegate
            VC.countryCode = phoneCode
            VC.mobileNumber = phoneNumber
            self.navigationController?.pushViewController(VC, animated: true)
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
}

extension ChangeMobileNumberVC : SideMenuDelegate{
    func selectedIndex(row: Int) {
        if row == 9{
            logoutAlert()
        }else{
            deleteAccountAlert()
        }
    }
    
    func logoutAlert(){
        let VC = self.getPopUpVC()
        VC.titleString = "Logout"
        VC.messageString = MessageHelper.PopupMessage.LogoutMessage
        VC.noBtnClick  = { [weak self]  in
        }
        VC.yesBtnClick  = { [weak self]  in
            self?.finalStep()
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.logoutSuccess, type: .success)
        }
        VC.modalPresentationStyle = .overFullScreen
        self.present(VC, animated: false, completion: nil)
    }
    
    func deleteAccountAlert(){
        let VC = self.getPopUpVC()
        VC.titleString = "Delete Account"
        VC.messageString = MessageHelper.PopupMessage.deleteAccountMessage
        VC.noBtnClick  = { [weak self]  in
        }
        VC.yesBtnClick  = { [weak self]  in
            self?.deleteUserRequest()
        }
        VC.modalPresentationStyle = .overFullScreen
        self.present(VC, animated: false, completion: nil)
    }
    
    func goToLogin(){
        let controllers = self.navigationController?.viewControllers
          for vc in controllers! {
            if vc.isKind(of: LoginPageVC.self) {
              _ = self.navigationController?.popToViewController(vc , animated: true)
            }
         }
    }
    
    func finalStep(){
        UserDefaultsHelper().clearUserdefaults()
        UserModal.sharedInstance.reset()
        self.goToLogin()
    }
    
    func deleteUserRequest(){
        AppDelegate.shared.showLoading(isShow: true)
        LoginVM().deleteUserWithId(id: UserModal.sharedInstance.userId, urlParams: nil, param: nil) { (message) in
            AppDelegate.shared.showLoading(isShow: false)
            self.finalStep()
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.accountDeleted, type: .success)
        } onFailure: { (error) in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        }
    }
}

extension ChangeMobileNumberVC: SideMenuNavigationControllerDelegate {

    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }

    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
        if let rootVC = menu.viewControllers.first as? SideMenuVC{
            rootVC.delegate = self
            rootVC.ParentNavigationController = self.navigationController
        }
    }

    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }

    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}
