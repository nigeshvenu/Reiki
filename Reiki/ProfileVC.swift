//
//  ProfileVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 05/09/22.
//

import UIKit
import SideMenu
import SwiftyAttributes


class ProfileVC: UIViewController {

    @IBOutlet var gradientView: GradientView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var userImageView: CustomImageView!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var userAddressLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var mobileNumberLbl: UILabel!
    @IBOutlet var aboutMeLbl: UILabel!
    @IBOutlet var timezoneLbl: UILabel!
    //
    @IBOutlet weak var avatarNameLbl: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getUserRequest()
        setUI()
    }
    
    func initialSettings(){
        gradientView.roundCorners(cornerRadius: 20.0, cornerMask: [.layerMinXMaxYCorner,.layerMaxXMaxYCorner])
        //sidemenu
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
        sideMenuSettings()
        SideMenuManager.default.leftMenuNavigationController?.sideMenuDelegate = self
    }
    
    func setUI(){
        let user = UserModal.sharedInstance
        userImageView.ImageViewLoading(mediaUrl: UserModal.sharedInstance.image, placeHolderImage: UIImage(named: "no_image"))
        userNameLbl.attributedText = user.firstName.withFont(FontHelper.montserratFontSize(fontType: .semiBold, size: 20.0)) + " ".withFont(FontHelper.montserratFontSize(fontType: .Light, size: 18.0)) + user.lastName.withFont(FontHelper.montserratFontSize(fontType: .Light, size: 20.0))
        emailLbl.text = user.email
        mobileNumberLbl.text = "\(user.phoneCode) \(user.phone.applyPatternOnNumbers(pattern: "(###) ###-####", replacmentCharacter: "#"))"
        aboutMeLbl.text = user.aboutMe
        var address = [user.city,user.state]
        address = address.filter({!$0.isEmpty})
        userAddressLbl.text = address.joined(separator: ", ")
        userAddressLbl.isHidden = address.count == 0
        if user.timeZone != nil{
            self.timezoneLbl.text = user.timeZone!.name
        }
        avatarNameLbl.text = user.avatar
        avatarImageView.image = UIImage(named: user.avatar)
    }
    
    @IBAction func editProfileBtnClicked(_ sender: Any) {
        let VC = self.getEditProfileVC()
        VC.delegate = self
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func deleteAccountBtnClicked(_ sender: Any) {
        self.deleteAccountAlert()
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
    
    @IBAction func changeCharacterBtnClicked(_ sender: Any) {
        let VC = self.getSignupCharacterVC()
        VC.selectedCharacter = UserModal.sharedInstance.avatar
        VC.isSignup = false
        VC.delegate = self
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
    // MARK: - Navigation

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
}

extension ProfileVC : ProfileEditDelegate{
    func profileEdited() {
        UserDefaultsHelper().clearAvatarDate()
        self.getUserRequest()
    }
}

extension ProfileVC{
    func getUserRequest(){
        let param = ["populate":["timezone"]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        LoginVM().getUser(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.setUI()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
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

extension ProfileVC : SideMenuDelegate{
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
            self?.logoutRequest()
        }
        VC.modalPresentationStyle = .overFullScreen
        self.present(VC, animated: false, completion: nil)
    }
    
    func logoutRequest(){
        let param = ["session_id":UserDefaultsHelper().getSessionId()]
        AppDelegate.shared.showLoading(isShow: true)
        LoginVM().logout(urlParams: nil, param: param) { (message) in
            AppDelegate.shared.showLoading(isShow: false)
            self.finalStep()
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.logoutSuccess, type: .success)
        } onFailure: { (error) in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        }
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
}

extension ProfileVC: SideMenuNavigationControllerDelegate {

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
