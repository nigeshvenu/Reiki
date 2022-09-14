//
//  ChangePasswordVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 06/09/22.
//

import UIKit
import SideMenu

class ChangePasswordVC: UIViewController {

    
    @IBOutlet var currentPwdTxt: UITextField!
    @IBOutlet var newPwdTxt: UITextField!
    @IBOutlet var confirmNewPwdTxt: UITextField!
    
    var viewModal = LoginVM()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    func initialSettings(){
        currentPwdTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setTextfieldPadding(textfield: currentPwdTxt)
        newPwdTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setTextfieldPadding(textfield: newPwdTxt)
        confirmNewPwdTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setTextfieldPadding(textfield: confirmNewPwdTxt)
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
    }
    
    func setTextfieldPadding(textfield:UITextField){
        let btnViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        let btnViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        textfield.rightViewMode = .always
        textfield.rightView = btnViewRight
        textfield.leftView = btnViewLeft
        textfield.leftViewMode = .always
    }
    
    @IBAction func updateBtnClicked(_ sender: Any) {
        if validateFields(){
            self.changePassword(currentPassword: self.currentPwdTxt.text!, newPassword: self.newPwdTxt.text!)
        }
    }
    
    func validateFields()->Bool{
        guard let currentPassword = currentPwdTxt.text,!currentPassword.isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.currentPassword, type: .danger)
            return false
        }
        if currentPassword.count < 8{
           SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.currentPasswordLengthAlert, type: .danger)
            return false
        }
       guard let newPassword = newPwdTxt.text,!newPassword.isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.newPassword, type: .danger)
            return false
        }
        if newPassword.count < 8{
           SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.newPasswordLengthAlert, type: .danger)
            return false
        }
        guard let confirmPassword = confirmNewPwdTxt.text,!confirmPassword.isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.confirmPasswordEmptyAlert, type: .danger)
            return false
        }
        if confirmPassword != newPassword{
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.confirmPasswordMismatch, type: .danger)
            return false
        }
        return true
    }
    
    @IBAction func currentPwdHideBtnClicked(_ sender: UIButton) {
        if !sender.isSelected{
            sender.isSelected = true
            currentPwdTxt.isSecureTextEntry = false
            sender.setImage(UIImage(named: "showeye"), for: .normal)
        }else{
            sender.isSelected = false
            currentPwdTxt.isSecureTextEntry = true
            sender.setImage(UIImage(named: "hideeye"), for: .normal)
        }
    }
    
    @IBAction func newPwdHideBtnClicked(_ sender: UIButton) {
        if !sender.isSelected{
            sender.isSelected = true
            newPwdTxt.isSecureTextEntry = false
            sender.setImage(UIImage(named: "showeye"), for: .normal)
        }else{
            sender.isSelected = false
            newPwdTxt.isSecureTextEntry = true
            sender.setImage(UIImage(named: "hideeye"), for: .normal)
        }
    }
    
    @IBAction func confirmPwdHideBtnClicked(_ sender: UIButton) {
        if !sender.isSelected{
            sender.isSelected = true
            confirmNewPwdTxt.isSecureTextEntry = false
            sender.setImage(UIImage(named: "showeye"), for: .normal)
        }else{
            sender.isSelected = false
            confirmNewPwdTxt.isSecureTextEntry = true
            sender.setImage(UIImage(named: "hideeye"), for: .normal)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sideMenu" {
            if let sideMenu = segue.destination as? SideMenuNavigationController{
                if let rootVC = sideMenu.viewControllers.first as? SideMenuVC{
                    rootVC.delegate = self
                    rootVC.ParentNavigationController = self.navigationController
                    var settings = SideMenuSettings()
                    let appScreenRect = UIApplication.shared.keyWindow?.bounds ?? UIWindow().bounds
                    let minimumSize = min(appScreenRect.width, appScreenRect.height)
                    settings.menuWidth = round(minimumSize * 0.82)
                    settings.presentationStyle = .menuSlideIn
                    settings.presentationStyle.presentingEndAlpha = 0.5
                    SideMenuManager.default.leftMenuNavigationController?.settings = settings
                }
            }
        }
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

extension ChangePasswordVC : SideMenuDelegate{
    func selectedIndex(row: Int) {
        if row == 11{
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

extension ChangePasswordVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == currentPwdTxt{
            newPwdTxt.becomeFirstResponder()
        }else if textField == newPwdTxt{
            confirmNewPwdTxt.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
}

extension ChangePasswordVC{
    
    func changePassword(currentPassword: String, newPassword: String) {
        AppDelegate.shared.showLoading(isShow: true)
        let param = ["password":newPassword,
                     "old_password":currentPassword] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.changePassword(urlParams: nil, param: param, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.passwordChanged, type: .success)
            self.currentPwdTxt.text = ""
            self.newPwdTxt.text = ""
            self.confirmNewPwdTxt.text = ""
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
        
    }
}
