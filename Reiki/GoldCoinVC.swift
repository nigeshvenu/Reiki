//
//  GoldCoinVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 31/10/22.
//

import UIKit

class GoldCoinVC: UIViewController {

    
    @IBOutlet var backgroundImageView: CustomImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var listEmptyLbl: UILabel!
    @IBOutlet var goldCoinLbl: UILabel!
    
    var viewModal = HomePageVM()
    var unlockablesVM = UnlockablesVM()
    
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
        goldCoinLbl.text = UserModal.sharedInstance.coin
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserThemes()
        
    }

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateThemeBtnClicked(_ sender: Any) {
        let VC = self.getThemeVC()
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
extension GoldCoinVC{
    
    func getRandomUniqueTheme() -> ThemeModal? {
        let availableThemes = self.unlockablesVM.themeArray.filter { !previouslySelectedThemes.contains($0) }
        
        guard let selectedTheme = availableThemes.randomElement() else {
            previouslySelectedThemes.removeAll() // Reset if all themes have been used
            return getRandomUniqueTheme()
        }
        
        previouslySelectedThemes.append(selectedTheme)
        return selectedTheme
    }
    
    func setCalendarBackground(date:Date){
        if self.unlockablesVM.themeArray.count > 0 {
            if self.unlockablesVM.themeArray.count == 1{
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

extension GoldCoinVC{
    
    func getUserThemes(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true,"applied":true,"user_id":Int(UserModal.sharedInstance.userId)!],
                     "populate":["+theme"]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        unlockablesVM.getUserThemes(urlParams: param, param: nil, onSuccess: { message in
            //AppDelegate.shared.showLoading(isShow: false)
            self.getCoinsRequest()
            self.setCalendarBackground(date: Date())
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func getCoinsRequest(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true,"user_id":Int(UserModal.sharedInstance.userId)!],
                     "sort":[["created_at","DESC"]]] as [String : Any]
        //AppDelegate.shared.showLoading(isShow: true)
        viewModal.getUserCoin(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.tableView.reloadData()
            self.listEmptyLbl.isHidden = self.viewModal.coinArray.count > 0
            self.tableView.isHidden = self.viewModal.coinArray.count == 0
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
}


extension GoldCoinVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModal.coinArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "GoldCoinCell") as! GoldCoinCell
        let numberOfRows = self.viewModal.coinArray.count
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
        let coin = self.viewModal.coinArray[indexPath.row]
        cell.titleLbl.text = coin.type
        cell.dateLbl.text = coin.date
        cell.coinLbl.text = coin.coin
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
