//
//  ForgotPasswordSetPwdVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 09/09/22.
//

import UIKit

class ForgotPasswordSetPwdVC: UIViewController {
    @IBOutlet var newPasswordTxt: UITextField!
    @IBOutlet var confirmPasswordTxt: UITextField!
    
    var viewModal = SignupVM()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.goToForgotPwd()
    }
    
    func initialSettings(){
        newPasswordTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setPlaceholderColor(textfield: newPasswordTxt)
        setTextfieldPadding(textfield: newPasswordTxt)
        confirmPasswordTxt.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        setPlaceholderColor(textfield: confirmPasswordTxt)
        setTextfieldPadding(textfield: confirmPasswordTxt)
    }
    
    func setPlaceholderColor(textfield:UITextField){
        textfield.attributedPlaceholder = NSAttributedString(
            string: textfield.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
    }
    
    func setTextfieldPadding(textfield:UITextField){
        let btnViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        let btnViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        textfield.rightViewMode = .always
        textfield.rightView = btnViewRight
        textfield.leftView = btnViewLeft
        textfield.leftViewMode = .always
    }
    
    func validateFieldValues()->Bool{
        guard let password = newPasswordTxt.text,password != "" else {
           SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.passwordEmptyAlert, type: .danger)
            return false
        }
        if password.count < 8{
           SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.passwordLengthAlert, type: .danger)
            return false
        }
        guard let confirmPassword = confirmPasswordTxt.text,confirmPassword != "" else {
           SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.confirmPasswordEmptyAlert, type: .danger)
            return false
        }
        if confirmPassword != password{
           SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.confirmPasswordMismatch, type: .danger)
            return false
        }
        return true
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        if validateFieldValues(){
            resetPassword()
        }
    }
    
    @IBAction func newPwdHideBtnClicked(_ sender: UIButton) {
        if !sender.isSelected{
            sender.isSelected = true
            newPasswordTxt.isSecureTextEntry = false
            sender.setImage(UIImage(named: "showeye"), for: .normal)
        }else{
            sender.isSelected = false
            newPasswordTxt.isSecureTextEntry = true
            sender.setImage(UIImage(named: "hideeye"), for: .normal)
        }
    }
    
    @IBAction func confirmPwdHideBtnClicked(_ sender: UIButton) {
        if !sender.isSelected{
            sender.isSelected = true
            confirmPasswordTxt.isSecureTextEntry = false
            sender.setImage(UIImage(named: "showeye"), for: .normal)
        }else{
            sender.isSelected = false
            confirmPasswordTxt.isSecureTextEntry = true
            sender.setImage(UIImage(named: "hideeye"), for: .normal)
        }
    }
    
    func goToLogin(){
        let controllers = self.navigationController?.viewControllers
          for vc in controllers! {
            if vc.isKind(of: LoginPageVC.self) {
              _ = self.navigationController?.popToViewController(vc , animated: true)
            }
         }
    }
    
    func goToForgotPwd(){
        let controllers = self.navigationController?.viewControllers
          for vc in controllers! {
            if vc.isKind(of: ForgotPasswordVC.self) {
              _ = self.navigationController?.popToViewController(vc , animated: true)
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

extension ForgotPasswordSetPwdVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == newPasswordTxt{
            confirmPasswordTxt.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
}

extension ForgotPasswordSetPwdVC{
    func resetPassword(){
        let sessionId = UserDefaults.standard.string(forKey: "sessionId") ?? ""
        let param = ["session_id":sessionId,
                     "password":newPasswordTxt!.text!] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.resetPassword(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            UserDefaults.standard.removeObject(forKey: "sessionId")
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.passwordChanged, type: .success)
            self.goToLogin()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
}
