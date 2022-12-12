//
//  BadgesVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 21/11/22.
//

import UIKit

class BadgesVC: UIViewController {

    @IBOutlet var backgroundImageView: CustomImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var listEmptyLbl: UILabel!
    @IBOutlet var badgeNumberLbl: UILabel!
    @IBOutlet var badgeViewHeight: NSLayoutConstraint!
    
    var viewModal = BadgeVM()
    var currentPage : Int = 1
    var isLoadingList : Bool = false
    var pageLimit = 10
    var unlockableViewModal = UnlockablesVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resetPagenation()
        getUserThemes()
    }
    
    func resetPagenation(){
        viewModal.badgeArray.removeAll()
        viewModal.isPageEmptyReached = false
        currentPage = 1
        isLoadingList = false
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func updateThemeBtnClicked(_ sender: Any) {
        let VC = self.getThemeVC()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func setCalendarBackground(date:Date){
        if self.unlockableViewModal.themeArray.count > 0{
            let themes = self.unlockableViewModal.themeArray.randomElement()
            backgroundImageView.ImageViewLoading(mediaUrl: themes?.themeUrl ?? "", placeHolderImage: nil)
            return
        }
        switch date.kvkMonth{
        case 12,1,2:
            backgroundImageView.image = UIImage(named: "CalandarWinter")
        case 3,4,5:
            backgroundImageView.image = UIImage(named: "CalandarSpring")
        case 6,7,8:
            backgroundImageView.image = UIImage(named: "CalandarSummer")
        case 9,10,11:
            backgroundImageView.image = UIImage(named: "CalandarAutumn")
        default:
            break
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

extension BadgesVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return viewModal.badgeArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "LevelCell") as! LevelCell
        let badge = self.viewModal.badgeArray[indexPath.row]
        cell.badgeLbl.text = badge.badge
        cell.dateLbl.text = badge.badgeDate
        let numberOfRows = self.viewModal.badgeArray.count
        if numberOfRows == 1{
            cell.contentView.setRoundCorners([.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: 16)
        }else if (indexPath.row == numberOfRows - 1) { // bottom cell
            cell.contentView.setRoundCorners([.layerMinXMaxYCorner,.layerMaxXMaxYCorner], radius: 16)
        }else if (indexPath.row == 0) { // top cell
            cell.contentView.setRoundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 16)
        }else{
            cell.contentView.setRoundCorners([.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: 0)
        }
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white.withAlphaComponent(0.39) : UIColor.white.withAlphaComponent(0.50)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isTracking{
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            if (offsetY > contentHeight - scrollView.frame.height) && !isLoadingList {
                self.isLoadingList = true
                self.currentPage += 1
                self.getBadgeRequest(showLoader: true)
            }
        }
    }
}

extension BadgesVC{
    
    func getUserThemes(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true,"applied":true,"user_id":Int(UserModal.sharedInstance.userId)!],
                     "populate":["theme"]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        unlockableViewModal.getUserThemes(urlParams: param, param: nil, onSuccess: { message in
            //AppDelegate.shared.showLoading(isShow: false)
            self.getBadgeRequest(showLoader: false)
            self.setCalendarBackground(date: Date())
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func getBadgeRequest(showLoader:Bool){
        var offset = 0
        if currentPage != 1{
            offset = (currentPage * pageLimit) - pageLimit
        }
        let param = ["offset":offset,
                     "limit":pageLimit,
                     "where":["active":true,"user_id":Int(UserModal.sharedInstance.userId)!],
                     "sort":[["created_at","DESC"]],
                     "populate":["badge"]] as [String : Any]
        if showLoader{
            AppDelegate.shared.showLoading(isShow: true)
        }
        viewModal.getUserBadge(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            if !self.viewModal.isPageEmptyReached{
                self.isLoadingList = false
            }
            self.tableView.reloadData()
            self.listEmptyLbl.isHidden = self.viewModal.badgeArray.count > 0
            self.tableView.isHidden = self.viewModal.badgeArray.count == 0
            self.badgeNumberLbl.text = self.viewModal.badgeArray.count == 0 ? "" : self.viewModal.badgeArray.first!.badge
            self.badgeViewHeight.constant = self.viewModal.badgeArray.count == 0 ? 0 : 87.5
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
}
