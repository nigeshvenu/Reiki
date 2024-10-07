//
//  PurchaseHistoryVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 22/11/22.
//

import UIKit

class PurchaseHistoryVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var listEmptyLbl: UILabel!
    
    var currentPage : Int = 1
    var isLoadingList : Bool = false
    var pageLimit = 10
    var unlockableViewModal = UnlockablesVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if unlockableViewModal.purchaseHistoryArray.count == 0{
            getPurchaseHistioryRequest()
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

extension PurchaseHistoryVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unlockableViewModal.purchaseHistoryArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PurchaseHistoryCell") as! PurchaseHistoryCell
        let history = self.unlockableViewModal.purchaseHistoryArray[indexPath.row]
        cell.itemImage.ImageViewLoading(mediaUrl: history.image, placeHolderImage: nil)
        cell.nameLbl.text = history.name
        cell.dateLbl.text = history.createdDate
        cell.coinLbl.text = history.requiredCoin
        cell.setCorner(numberOfRows: self.unlockableViewModal.purchaseHistoryArray.count, indexPath: indexPath)
        cell.viewContents.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : UIColor.init(hexString: "#F9F5F5")
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isTracking{
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            if (offsetY > contentHeight - scrollView.frame.height) && !isLoadingList {
                self.isLoadingList = true
                self.currentPage += 1
                self.getPurchaseHistioryRequest()
            }
        }
    }
}

extension PurchaseHistoryVC{
    
    func getPurchaseHistioryRequest(){
        var offset = 0
        if currentPage != 1{
            offset = (currentPage * pageLimit) - pageLimit
        }
        let param = ["offset":offset,
                     "limit":pageLimit,
                     "where":["active":true,"user_id":Int(UserModal.sharedInstance.userId)!],
                     "sort":[["created_at","DESC"]],
                     "populate":["+custom_gear","+theme"]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        unlockableViewModal.getPurchaseHistory(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            if !self.unlockableViewModal.isPageEmptyReached{
                self.isLoadingList = false
            }
            self.tableView.reloadData()
            self.listEmptyLbl.isHidden = self.unlockableViewModal.purchaseHistoryArray.count > 0
            self.tableView.isHidden = self.unlockableViewModal.purchaseHistoryArray.count == 0
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
}
