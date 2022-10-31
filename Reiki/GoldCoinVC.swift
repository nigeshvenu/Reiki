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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        goldCoinLbl.text = UserModal.sharedInstance.coin
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserThemes()
        getCoinsRequest()
    }

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateThemeBtnClicked(_ sender: Any) {
        let VC = self.getThemeVC()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func setCalendarBackground(date:Date){
        if self.unlockablesVM.themeArray.count > 0{
            let themes = self.unlockablesVM.themeArray.randomElement()
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

extension GoldCoinVC{
    
    func getUserThemes(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true,"applied":true,"user_id":Int(UserModal.sharedInstance.userId)!],
                     "populate":["theme"]] as [String : Any]
        //AppDelegate.shared.showLoading(isShow: true)
        unlockablesVM.getUserThemes(urlParams: param, param: nil, onSuccess: { message in
            //AppDelegate.shared.showLoading(isShow: false)
            self.setCalendarBackground(date: Date())
        }, onFailure: { error in
            //AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func getCoinsRequest(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true,"user_id":Int(UserModal.sharedInstance.userId)!],
                     "sort":[["created_at","DESC"]]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
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
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white.withAlphaComponent(0.39) : UIColor.white.withAlphaComponent(0.50)
        let coin = self.viewModal.coinArray[indexPath.row]
        cell.titleLbl.text = coin.type
        cell.dateLbl.text = coin.date
        cell.coinLbl.text = "+" + coin.coin
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
