//
//  LevelCriteriaVC.swift
//  Reiki
//
//  Created by Newage on 04/07/24.
//

import UIKit

class LevelCriteriaVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModal = LevelVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getLevelsRequest()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

extension LevelCriteriaVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModal.levelCriteriaArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "LevelCriteriaCell") as! LevelCriteriaCell
        let level = self.viewModal.levelCriteriaArray[indexPath.row]
        cell.levelTitleLbl.text = level.levelName
        let requiredXp = Int(level.requiredPoint) ?? 0
        cell.levelShapeLbl.text = requiredXp > 0 ? level.levelShape + "(\(level.requiredPoint)xp required)" : level.levelShape
        cell.setCorner(numberOfRows: self.viewModal.levelCriteriaArray.count, indexPath: indexPath)
        cell.levelImgView.image = LevelImageHelper.getImage(leveNumber: level.levelNo)?.withRenderingMode(.alwaysTemplate)
        cell.levelImgView.tintColor = UIColor(red: 170/255, green: 50/255, blue: 112/255, alpha: 1.0)
        cell.mainView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : UIColor.init(hexString: "#F9F5F5")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension LevelCriteriaVC{
    
    func getLevelsRequest(){
        
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true],
                     "sort":[["id","ASC"]]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.getLevels(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.tableView.reloadData()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
}
