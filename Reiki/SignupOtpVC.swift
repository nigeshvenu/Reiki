//
//  SignupOtpVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 25/08/22.
//

import UIKit

class SignupOtpVC: UIViewController {

    @IBOutlet weak var otpTextFieldView: OTPFieldView!
    @IBOutlet var resendCodeBtn: UIButton!
    @IBOutlet var otpDescLbl: UILabel!
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var countryCode = ""
    var mobileNumber = ""
    var retryTimer: Timer?
    var timerDurationInSec = 30
    var hasEnteredAll = false
    var otpEntered = ""
    var viewModal = SignupVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.otpTextFieldView.initializeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.stopTimer()
    }
    
    func initialSettings(){
        otpDescLbl.text = "Enter the 4-digit code we sent to \n (\(countryCode)) \(mobileNumber.applyPatternOnNumbers(pattern: "(###) ###-####", replacmentCharacter: "#")) to verify your mobile number"
        setupOtpView()
    }
    
    func setupOtpView(){
        self.otpTextFieldView.fieldFont = FontHelper.montserratFontSize(fontType: .medium, size: 18)
        self.otpTextFieldView.fieldTextColor = UIColor.black
        self.otpTextFieldView.fieldsCount = 4
        self.otpTextFieldView.fieldBorderWidth = 2
        self.otpTextFieldView.defaultBorderColor = UIColor.white
        self.otpTextFieldView.filledBorderColor = UIColor.white
        self.otpTextFieldView.defaultBackgroundColor = UIColor.white
        self.otpTextFieldView.filledBackgroundColor = UIColor.white
        self.otpTextFieldView.cursorColor = UIColor.black
        self.otpTextFieldView.displayType = .square
        self.otpTextFieldView.fieldSize = 50
        self.otpTextFieldView.separatorSpace = 40
        self.otpTextFieldView.shouldAllowIntermediateEditing = false
        self.otpTextFieldView.delegate = self
        
    }
    
    func startTimer(){
        retryTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateResentBtn), userInfo: nil, repeats: true)
        self.resendCodeBtn.isUserInteractionEnabled = false
    }
    
    @objc func updateResentBtn(){
        if timerDurationInSec == 1{
            stopTimer()
            return
        }
        timerDurationInSec -= 1
        self.resendCodeBtn.setTitle("Resend Code in \(String(timerDurationInSec))s", for: .normal)
    }
    
    func stopTimer(){
        self.retryTimer?.invalidate()
        self.resendCodeBtn.setTitle("Resend Code", for: .normal)
        self.resendCodeBtn.isUserInteractionEnabled = true
        self.timerDurationInSec = 31
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        if hasEnteredAll{
            self.verifyOTP(otp: self.otpEntered)
        }else{
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.otpEmpty, type: .danger)
        }
    }
    
    @IBAction func resendCodeBtnClicked(_ sender: Any) {
        self.resendOTP()
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

extension SignupOtpVC: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        hasEnteredAll = hasEntered
        if hasEntered{
            //self.verifyOTP(otp: otpEntered)
        }
        return true
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
        otpEntered = otpString
    }
}

extension SignupOtpVC{
    
    func verifyOTP(otp:String){
        let sessionId = UserDefaults.standard.string(forKey: "sessionId") ?? ""
        let param = ["session_id":sessionId,
        "otp":otp] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.verifyOTP(urlParams: param, param: nil, onSuccess: { message in
           AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.codeVerified, type: .success)
            let VC = self.getSignupSetPasswordVC()
            VC.firstName = self.firstName
            VC.lastName = self.lastName
            VC.email = self.email
            VC.countryCode = self.countryCode
            VC.mobileNumber = self.mobileNumber
            self.navigationController?.pushViewController(VC, animated: true)
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func resendOTP(){
        let sessionId = UserDefaults.standard.string(forKey: "sessionId") ?? ""
        let param = ["session_id":sessionId] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.resendOTP(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.otpResend, type: .success)
            self.startTimer()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
}
