//
//  WebViewVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 09/09/22.
//

import UIKit
import WebKit
import SideMenu

class WebViewVC: UIViewController {
    @IBOutlet var headerTitleLbl: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet var leftBtn: UIButton!
    
    var webView: WKWebView!
    var agreementHeaderTitle = ""
    var showBackBtn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    override func loadView() {
        super.loadView()
        webView = WKWebView(frame: mainView.bounds, configuration: WKWebViewConfiguration())
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        self.mainView.addSubview(webView)
    }
    
    @IBAction func leftBtnClicked(_ sender: Any) {
        if showBackBtn{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func initialSettings(){
        if showBackBtn{
            leftBtn.setImage(UIImage(named: "backArrow"), for: .normal)
        }else{
            SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
            SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
        }
        headerTitleLbl.text = agreementHeaderTitle
        var agreementUrl = ""
        if agreementHeaderTitle == "Terms of use" || agreementHeaderTitle == "Terms & Conditions"{
            agreementUrl = "\(APIUrl.BaseURL)\(APIFunction.terms)"
        }else if agreementHeaderTitle == "Privacy Policy"{
            agreementUrl = "\(APIUrl.BaseURL)\(APIFunction.privacy)"
        }
        if let url = URL(string: agreementUrl){
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
            self.webView.navigationDelegate = self
            AppDelegate.shared.showLoading(isShow: true)
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

extension WebViewVC : WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        AppDelegate.shared.showLoading(isShow: false)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        AppDelegate.shared.showLoading(isShow: false)
    }
}


extension WebViewVC : SideMenuDelegate{
    
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
