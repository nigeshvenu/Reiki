//
//  FavoritesVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 06/10/22.
//

import UIKit
import SideMenu

class FavoritesVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var listEmptyLbl: UILabel!
    
    var viewModal = FavoriteVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getFavoriteRequest()
    }
    
    func initialSettings (){
        //sidemenu
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
        sideMenuSettings()
        SideMenuManager.default.leftMenuNavigationController?.sideMenuDelegate = self
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

extension FavoritesVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModal.favoritesArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FavoritesTVC") as! FavoritesTVC
        cell.mainView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : UIColor.init(hexString: "#F9F5F5")
        let favorite = self.viewModal.favoritesArray[indexPath.row]
        cell.eventImageView.ImageViewLoading(mediaUrl: favorite.event.eventImage, placeHolderImage: UIImage(named: "noImageEvent"))
        cell.eventTitle.text = favorite.event.eventTitle
        cell.dateLbl.text = favorite.createdDate
        cell.favoriteBtn.tag = indexPath.row
        cell.favoriteBtn.addTarget(self, action: #selector(unfavorite(btn:)), for: .touchUpInside)
        cell.customLb.isHidden = favorite.event.eventType == .publicType
        return cell
    }
    
    @objc func unfavorite(btn:UIButton){
        self.removeFavoriteActivityRequest(eventId: self.viewModal.favoritesArray[btn.tag].favoriteId)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToEventPage(event: self.viewModal.favoritesArray[indexPath.row].event)
    }
    
    func goToEventPage(event:EventModal){
        let VC = self.getEventDetailVC()
        VC.event = event
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

extension FavoritesVC{
    
    func getFavoriteRequest(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true,"user_id":Int(UserModal.sharedInstance.userId)!],
                     "populate":["activity","custom_activity"],
                     "sort":[["activity","date","desc"],["custom_activity","date","desc"]]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.getFavorite(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.tableView.reloadData()
            self.listEmptyLbl.isHidden = self.viewModal.favoritesArray.count > 0
            self.tableView.isHidden = self.viewModal.favoritesArray.count == 0
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func removeFavoriteActivityRequest(eventId:String){
        AppDelegate.shared.showLoading(isShow: true)
        CalendarVM().removeFavoriteActivity(id: eventId,urlParams: nil, param: nil) { (message) in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.removedFavorite, type: .success)
            self.getFavoriteRequest()
        } onFailure: { (error) in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        }
    }
    
}

extension FavoritesVC : SideMenuDelegate{
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
}

extension FavoritesVC: SideMenuNavigationControllerDelegate {

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
