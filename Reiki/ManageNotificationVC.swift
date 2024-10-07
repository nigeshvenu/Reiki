//
//  ManageNotificationVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 22/12/22.
//

import UIKit
import Switches

class ManageNotificationVC: UIViewController {

    @IBOutlet weak var customSwitch: YapSwitch!
    @IBOutlet weak var publicSwitch: YapSwitch!
    
    var viewModal = EditProfileVM()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    func initialSettings(){
        customSwitch.addTarget(self, action: #selector(customSwitchClick(sender:)), for: .touchUpInside)
        publicSwitch.addTarget(self, action: #selector(publicSwitchClick(sender:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getUserRequest()
    }
    
    func setUI(){
        customSwitch.setOn(UserModal.sharedInstance.send_custom_push, animated: true)
        publicSwitch.setOn(UserModal.sharedInstance.send_public_push, animated: true)
        setSwitchSettings()
    }
    
    func setSwitchSettings(){
        customSwitch.onThumbTintColor = UIColor.init(hexString: "#703FCC")
        customSwitch.offThumbTintColor =  UIColor.init(hexString: "#727272")
        customSwitch.onTintColor = UIColor.init(hexString: "#D8C4FF").withAlphaComponent(0.43)
        customSwitch.offTintColor = UIColor.init(hexString: "#D8C4FF").withAlphaComponent(0.43)
        publicSwitch.onThumbTintColor = UIColor.init(hexString: "#703FCC")
        publicSwitch.offThumbTintColor =  UIColor.init(hexString: "#727272")
        publicSwitch.onTintColor = UIColor.init(hexString: "#D8C4FF").withAlphaComponent(0.43)
        publicSwitch.offTintColor = UIColor.init(hexString: "#D8C4FF").withAlphaComponent(0.43)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func customSwitchClick(sender:YapSwitch){
        updateCustomNotification(status: sender.isOn)
    }
    
    @objc func publicSwitchClick(sender:YapSwitch){
        updatePublicNotification(status: sender.isOn)
    }
    
    @IBAction func customSwitchClicked(_ sender: YapSwitch) {
       
    }
    
    @IBAction func publicSwitchClicked(_ sender: YapSwitch) {
        
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

extension ManageNotificationVC{
    
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
    
    func updateCustomNotification(status:Bool){
        let param = ["send_custom_push":status]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.updateUser(urlParams: nil, param: param, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            if status{
                SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.customNotEnabled, type: .success)
            }else{
                SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.customNotDisabled, type: .success)
            }
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func updatePublicNotification(status:Bool){
        let param = ["send_public_push":status]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.updateUser(urlParams: nil, param: param, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            if status{
                SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.publicNotEnabled, type: .success)
            }else{
                SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.publicNotDisabled, type: .success)
            }
            
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
}
