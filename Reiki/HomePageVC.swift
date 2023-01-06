//
//  HomePageVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 30/08/22.
//

import UIKit
import SideMenu
import Lightbox

class HomePageVC: UIViewController {

    @IBOutlet var characterImageView: UIImageView!
    @IBOutlet var coinLbl: UILabel!
    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var levelImageMainView: UIImageView!
    @IBOutlet var levelImage: UIImageView!
    @IBOutlet var levelNumberLbl: UILabel!
    @IBOutlet var prestigeIcon: UIImageView!
    @IBOutlet var purchaseView: UIView!
    
    var viewModal = UnlockablesVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.getConfigurationRequest()
        self.getUserRequest()
    }
    
    func initialSettings(){
        levelImageMainView.layer.cornerRadius = 36/2
        characterImageView.image = UIImage(named: "C\(UserModal.sharedInstance.avatar)Pose1")
        coinLbl.text = UserModal.sharedInstance.coin
        self.slideShowImages()
        //Sidemenu
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
        sideMenuSettings()
        SideMenuManager.default.leftMenuNavigationController?.sideMenuDelegate = self
        purchaseView.backgroundColor = UIColor.black.withAlphaComponent(0.38)
        purchaseView.setRoundCorners([.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: 25)
    }
    
    func setUI(){
        coinLbl.text = UserModal.sharedInstance.coin
        levelNumberLbl.text = "LVL " + UserModal.sharedInstance.levelNumber
        levelImage.image = LevelImageHelper.getImage(leveNumber: UserModal.sharedInstance.levelNumber)
        prestigeIcon.isHidden = !UserModal.sharedInstance.prestige
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
    
    @IBAction func levelBtnClicked(_ sender: Any) {
        let VC = self.getLevelVC()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func goldCoinBtnClicked(_ sender: Any) {
        let VC = self.getGoldCoinVC()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func badgeBtnClicked(_ sender: Any) {
        let VC = self.getBadgeVC()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func cardFinderBtnClicked(_ sender: Any) {
        let VC = self.getCardFinderVC()
        VC.showBackBtn = true
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    @IBAction func purchaseBtnClicked(_ sender: Any) {
        
        self.userCustomGearRequest()
    }
    
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomePageVC{
    
    func slideShowImages(){
        var images = [UIImage]()
        let count = UserModal.sharedInstance.avatar == "Micheal" ? 3 : 8
        let duration = UserModal.sharedInstance.avatar == "Micheal" ? 9.0 : 24.0
        for i in 1...count{
           images.append(UIImage(named: "C\(UserModal.sharedInstance.avatar)Pose\(i)")!)
        }
        characterImageView.animationImages = images
        characterImageView.animationDuration = duration
        characterImageView.startAnimating()
    }
    
}

extension HomePageVC{
    
    func presentImage(){
        var images = [LightboxImage]()
        for image in self.viewModal.purchaseHistoryArray{
            if let url = URL(string: image.image){
                print(image.name)
                images.append(LightboxImage(imageURL: url,text: image.name))
            }
        }
        if images.count > 0{
            // Create an instance of LightboxController.
            let controller = LightboxController(images: images)
            //LightboxConfig.CloseButton.self.text = ""
            //LightboxConfig.CloseButton.self.size = CGSize(width: 20, height: 20)
            //LightboxConfig.CloseButton.self.image = UIImage(named: "closewhite")
            // Set delegates.
            //controller.pageDelegate = self
            //controller.dismissalDelegate = self
            // Use dynamic background.
            controller.dynamicBackground = true
            // Present your controller.
            present(controller, animated: true, completion: nil)
        }else{
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.purchaseElementsEmpty, type: .success)
        }
    }
}

extension HomePageVC{
    
    func userCustomGearRequest(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true,"user_id":Int(UserModal.sharedInstance.userId)!,"applied":true],
                     "sort":[["created_at","DESC"]],
                     "populate":["custom_gear"]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.getCustomGear(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.presentImage()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
}

extension HomePageVC{
    
    func getConfigurationRequest(){
        //AppDelegate.shared.showLoading(isShow: true)
        LoginVM().getConfiguration(urlParams: nil, param: nil, onSuccess: { message in
            //AppDelegate.shared.showLoading(isShow: false)
            //self.getUserRequest()
        }, onFailure: { error in
            //AppDelegate.shared.showLoading(isShow: false)
            //SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
            //self.navigationController?.viewControllers.insert(self.getLoginPageVC(), at: 1)
        })
    }
    
    func getUserRequest(){
        let param = ["populate":["level"]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        LoginVM().getUser(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.setUI()
            self.getConfigurationRequest()
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

extension HomePageVC : SideMenuDelegate{
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

extension HomePageVC: SideMenuNavigationControllerDelegate {

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
