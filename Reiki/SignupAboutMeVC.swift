//
//  SignupAboutMeVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 25/08/22.
//

import UIKit

class SignupAboutMeVC: UIViewController {
    
    @IBOutlet var descriptionTxtView: UITextView!
    
    var textViewPlaceholderColor = UIColor.lightGray
    var textViewTextColor = UIColor.black
    var firstName = ""
    var lastName = ""
    var email = ""
    var countryCode = ""
    var mobileNumber = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initialSettings(){
        descriptionTxtView.text = "Write something.."
        descriptionTxtView.textColor = textViewPlaceholderColor
        descriptionTxtView.font = FontHelper.montserratFontSize(fontType: .medium, size: 15)
        descriptionTxtView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        
        guard let aboutMe = descriptionTxtView.text,!aboutMe.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.aboutMeEmpty, type: .danger)
            return
        }
        if descriptionTxtView.textColor == textViewPlaceholderColor{
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.aboutMeEmpty, type: .danger)
            return
        }
        SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.aboutMeAdded, type: .success)
        self.view.endEditing(true)
        let VC = self.getSignupCharacterVC()
        VC.firstName = self.firstName
        VC.lastName = self.lastName
        VC.email = self.email
        VC.countryCode = self.countryCode
        VC.mobileNumber = self.mobileNumber
        VC.aboutMe = self.descriptionTxtView.textColor == textViewTextColor ? self.descriptionTxtView.text.trimmingCharacters(in: .whitespacesAndNewlines) : ""
        VC.password = self.password
        //Clear textfield
        descriptionTxtView.text = "Write something.."
        descriptionTxtView.textColor = textViewPlaceholderColor
        VC.selectedCharacter = "Micheal"
        self.navigationController?.pushViewController(VC, animated: true)
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


extension SignupAboutMeVC : UITextViewDelegate{
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
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 300    // 300 Limit Value
    }
    
}
