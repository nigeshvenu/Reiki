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
    
    private var backgroundTimer: Timer?
    
    var previouslySelectedThemes: [ThemeModal] = []
    var themeDurationSeconds : CGFloat = 45.0 //Seconds
    
    // Invalidate the timer when the view controller is deallocated
    deinit {
        backgroundTimer?.invalidate()
    }
    
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
    
    @IBAction func infoBtnClicked(_ sender: Any) {
        let VC = self.getBadgeCriteriaVC()
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

//Themes
extension BadgesVC{
    
    func getRandomUniqueTheme() -> ThemeModal? {
        let availableThemes = self.unlockableViewModal.themeArray.filter { !previouslySelectedThemes.contains($0) }
        
        guard let selectedTheme = availableThemes.randomElement() else {
            previouslySelectedThemes.removeAll() // Reset if all themes have been used
            return getRandomUniqueTheme()
        }
        
        previouslySelectedThemes.append(selectedTheme)
        return selectedTheme
    }
    
    func setCalendarBackground(date:Date){
        if self.unlockableViewModal.themeArray.count > 0 {
            if self.unlockableViewModal.themeArray.count == 1{
                updateBackgroundImage()
            }else{
                updateBackgroundImageWithTimer()
            }
        } else {
            // Set background based on the current season
            switch date.kvkMonth {
            case 12, 1, 2:
                backgroundImageView.image = UIImage(named: "CalandarWinter")
            case 3, 4, 5:
                backgroundImageView.image = UIImage(named: "CalandarSpring")
            case 6, 7, 8:
                backgroundImageView.image = UIImage(named: "CalandarSummer")
            case 9, 10, 11:
                backgroundImageView.image = UIImage(named: "CalandarAutumn")
            default:
                break
            }
        }
    }
    
    private func updateBackgroundImageWithTimer() {
        // Update background image immediately
        updateBackgroundImage()
        
        // Invalidate any existing timer
        backgroundTimer?.invalidate()
        
        // Start a new timer to update the background every 20 seconds
        backgroundTimer = Timer.scheduledTimer(withTimeInterval: themeDurationSeconds, repeats: true) { [weak self] _ in
            self?.updateBackgroundImage()
        }
    }
    
    @objc private func updateBackgroundImage() {
        if let themes = getRandomUniqueTheme() {
            // Fade out the current image
            UIView.animate(withDuration: 0.5, animations: {
                self.backgroundImageView.alpha = 0
            }, completion: { _ in
                // Once the fade-out is complete, update the image
                self.backgroundImageView.ImageViewLoading(mediaUrl: themes.themeUrl, placeHolderImage: nil)
                
                // Fade in the new image
                UIView.animate(withDuration: 0.5) {
                    self.backgroundImageView.alpha = 1
                }
            })
        }
    }
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
        cell.badgeCriteriaLbl.text = badge.badgeDesc
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
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
                     "populate":["+theme"]] as [String : Any]
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
                     "sort":[["badge_id","DESC"]],
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
