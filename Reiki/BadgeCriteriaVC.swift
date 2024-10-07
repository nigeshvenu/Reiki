//
//  BadgeCriteriaVC.swift
//  Reiki
//
//  Created by Newage on 03/07/24.
//

import UIKit

class BadgeCriteriaVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModal = BadgeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getBadgeRequest()
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

extension BadgeCriteriaVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModal.badgeArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BadgeCell") as! BadgeCell
        let badge = self.viewModal.badgeArray[indexPath.row]
        cell.badgeTitleLbl.text = badge.badge
        cell.badgeDescLbl.text = badge.badgeDesc
        cell.setCorner(numberOfRows: self.viewModal.badgeArray.count, indexPath: indexPath)
        cell.mainView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : UIColor.init(hexString: "#F9F5F5")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension BadgeCriteriaVC{
    
    func getBadgeRequest(){
        
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true],
                     "sort":[["id","ASC"]]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.getBadge(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.tableView.reloadData()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
}
