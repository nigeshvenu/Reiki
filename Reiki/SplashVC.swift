//
//  SplashVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 06/09/22.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.nextVC), userInfo: nil, repeats: false)
    }
    
    @objc func nextVC(){
        setAutoLogin()
    }

    func setAutoLogin(){
        if !UserDefaultsHelper().getToken().isEmpty{
            self.getUserRequest()
        }else{
            let VC = self.getLoginPageVC()
            self.navigationController?.pushViewController(VC, animated: true)
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

extension SplashVC{
    func getUserRequest(){
        AppDelegate.shared.showLoading(isShow: true)
        LoginVM().getUser(urlParams: nil, param: nil, onSuccess: { message in
            self.getConfigurationRequest()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
            self.navigationController?.viewControllers.insert(self.getLoginPageVC(), at: 1)
        })
    }
    
    func getConfigurationRequest(){
        LoginVM().getConfiguration(urlParams: nil, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            let VC = self.getCalendarVC()
            self.navigationController?.pushViewController(VC, animated: true)
            self.navigationController?.viewControllers.insert(self.getLoginPageVC(), at: 1)
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
            self.navigationController?.viewControllers.insert(self.getLoginPageVC(), at: 1)
        })
    }
    
    
}
