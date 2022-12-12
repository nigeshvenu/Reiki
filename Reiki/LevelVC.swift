//
//  LevelVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 16/11/22.
//

import UIKit

class LevelVC: UIViewController {
    @IBOutlet var backgroundImageView: CustomImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var listEmptyLbl: UILabel!
    @IBOutlet var NormalView: UIView!
    @IBOutlet var levelNumberLbl: UILabel!
    @IBOutlet var levelImageMainView: UIView!
    @IBOutlet var levelImage: UIImageView!
    @IBOutlet var prestigeView: UIView!
    @IBOutlet var prestigeLevelImage: UIImageView!
    @IBOutlet var prestigeLevelNumberLbl: UILabel!
    @IBOutlet var prestigeImageMainView: UIView!
    @IBOutlet var resetBtn: UIButton!
    
    var viewModal = LevelVM()
    var unlockableViewModal = UnlockablesVM()
    var currentPage : Int = 1
    var isLoadingList : Bool = false
    var pageLimit = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initialSettings()
    }
    
    func initialSettings(){
        //tableView.register(UINib(nibName: "LevelHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "LevelHeader")
        levelImageMainView.layer.borderWidth = 1.0
        levelImageMainView.layer.borderColor = UIColor.white.cgColor
        levelImageMainView.layer.cornerRadius = 45/2
        //tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        prestigeImageMainView.layer.borderWidth = 1.0
        prestigeImageMainView.layer.borderColor = UIColor.white.cgColor
        prestigeImageMainView.layer.cornerRadius = 45/2
        resetBtn.layer.borderWidth = 1.0
        resetBtn.layer.cornerRadius = 14
        resetBtn.layer.borderColor = UIColor.white.cgColor
        NormalView.isHidden = UserModal.sharedInstance.prestige
        prestigeView.isHidden = !UserModal.sharedInstance.prestige
        resetBtn.isHidden = UserModal.sharedInstance.levelNumber != "12"
        setTopView()
    }
    
    func setTopView(){
        levelNumberLbl.text = "Level " + UserModal.sharedInstance.levelNumber
        levelImage.image = LevelImageHelper.getImage(leveNumber: UserModal.sharedInstance.levelNumber)
        prestigeLevelImage.image = LevelImageHelper.getImage(leveNumber: UserModal.sharedInstance.levelNumber)
        prestigeLevelNumberLbl.text = "Level " + UserModal.sharedInstance.levelNumber
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetPagenation()
        getUserThemes()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetBtnClicked(_ sender: Any) {
        self.resetAlert()
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
    
    func resetPagenation(){
        viewModal.levelDictArray.removeAll()
        viewModal.levelArray = nil
        viewModal.isPageEmptyReached = false
        currentPage = 1
        isLoadingList = false
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

extension LevelVC : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModal.levelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let level = self.viewModal.levelArray?[section]
        /*if level?.key ?? "" == "1"{
            return 0
        }*/
        return level?.value.count ?? 0
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "LevelCell") as! LevelCell
        let level = self.viewModal.levelArray?[indexPath.section]
        let levelModal = level?.value[indexPath.row]
        let point = (levelModal?.levelPoint ?? "")
        cell.sourceLbl.text = (levelModal?.source ?? "").firstUppercased
        cell.sourceLbl.isHidden = (Int(point) ?? 0) == 0
        cell.dateLbl.text = levelModal?.levelDateSimple ?? ""
        let pointText = (Int(point) ?? 0) == 0 ? "0xp" : "+\(point)xp"
        cell.pointLbl.text = pointText
        let numberOfRows = level?.value.count ?? 0
        if numberOfRows == 1{
            cell.contentView.setRoundCorners([.layerMinXMaxYCorner,.layerMaxXMaxYCorner], radius: 16)
        }else if (indexPath.row == numberOfRows - 1) { // bottom cell
            cell.contentView.setRoundCorners([.layerMinXMaxYCorner,.layerMaxXMaxYCorner], radius: 16)
        }else{
            cell.contentView.setRoundCorners([.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: 0)
        }
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white.withAlphaComponent(0.39) : UIColor.white.withAlphaComponent(0.50)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "LevelHeaderCell") as! LevelHeaderCell
        let level = self.viewModal.levelArray?[section]
        headerCell.levelLbl.text = "Level " + (level?.key ?? "")
        headerCell.dateLbl.text = level?.value[(level?.value.count ?? 0) - 1].levelDate
        headerCell.levelImage.image = LevelImageHelper.getImage(leveNumber: (level?.key ?? ""))
        if level?.value.count ?? 0 == 0{
            headerCell.headerMainView.setRoundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner], radius: 16)
        }else{
            headerCell.headerMainView.setRoundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 16)
        }
        if section == 0{
            if level?.key == "12"{
                headerCell.nextLvlLbl.text = "Maximum lvl"
                headerCell.requiredPointsLbl.isHidden = true
            }else{
                let nextLevel = Int(level?.key ?? "") ?? 0
                headerCell.nextLvlLbl.text = "TO REACH LVL \(nextLevel + 1)"
                headerCell.requiredPointsLbl.text = "\(UserModal.sharedInstance.points)xp/\(setLevelProgress(level: level?.key ?? ""))xp"
                headerCell.requiredPointsLbl.isHidden = false
            }
        }else{
            headerCell.nextLvlLbl.text = ""
            headerCell.requiredPointsLbl.text = ""
        }
        return headerCell
        /*let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LevelHeader") as! LevelHeader
        
        return headerView*/
    }
    
    func setLevelProgress(level:String)->String{
        switch level {
        case "1":
            return "500"
        case "2":
            return "1500"
        case "3":
            return "2500"
        case "4":
            return "4000"
        case "5":
            return "5000"
        case "6":
            return "6000"
        case "7":
            return "7000"
        case "8":
            return "8000"
        case "9":
            return "9000"
        case "10":
            return "11000"
        case "11":
            return "15000"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 97
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isTracking{
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            if (offsetY > contentHeight - scrollView.frame.height) && !isLoadingList {
                self.isLoadingList = true
                self.currentPage += 1
                self.getlevelRequest(showLoader: true)
            }
        }
    }
}

extension LevelVC{
    
    func resetAlert(){
        let VC = self.getPopUpVC()
        VC.titleString = "Reset"
        VC.messageString = MessageHelper.PopupMessage.resetLevelMessage
        VC.noBtnClick  = { [weak self]  in
        }
        VC.yesBtnClick  = { [weak self]  in
            self?.resetLevelRequest()
        }
        VC.modalPresentationStyle = .overFullScreen
        self.present(VC, animated: false, completion: nil)
    }
}


extension LevelVC{
    
    func getUserThemes(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true,"applied":true,"user_id":Int(UserModal.sharedInstance.userId)!],
                     "populate":["theme"]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        unlockableViewModal.getUserThemes(urlParams: param, param: nil, onSuccess: { message in
            //AppDelegate.shared.showLoading(isShow: false)
            self.getlevelRequest(showLoader: false)
            self.setCalendarBackground(date: Date())
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func getlevelRequest(showLoader:Bool){
        var offset = 0
        if currentPage != 1{
            offset = (currentPage * pageLimit) - pageLimit
        }
        let param = ["offset":offset,
                     "limit":pageLimit,
                     "where":["active":true,"user_id":Int(UserModal.sharedInstance.userId)!],
                     "sort":[["created_at","DESC"]],
                     "populate":["level"]] as [String : Any]
        if showLoader{
            AppDelegate.shared.showLoading(isShow: true)
        }
        viewModal.getUserLevel(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            if !self.viewModal.isPageEmptyReached{
                self.isLoadingList = false
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.listEmptyLbl.isHidden = self.viewModal.levelArray != nil
            self.tableView.isHidden = self.viewModal.levelArray == nil
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func resetLevelRequest(){
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.resetLevel(urlParams: nil, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.resetLevel, type: .success)
            UserModal.sharedInstance.levelNumber = "1"
            UserModal.sharedInstance.points = "0"
            self.resetBtn.isHidden = true
            self.setTopView()
            self.resetPagenation()
            self.getlevelRequest(showLoader: true)
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
}
