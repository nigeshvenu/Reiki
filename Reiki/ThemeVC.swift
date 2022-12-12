//
//  ThemeVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 06/10/22.
//

import UIKit

class ThemeVC: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var emptyLbl: UILabel!
    @IBOutlet var moreView: UIView!
    
    var viewModal = UnlockablesVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //setCalendarBackground(date: Date())
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        moreView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getThemesRequest()
    }
    
    func setCalendarBackground(date:Date){
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
    
    @IBAction func moreBtnClicked(_ sender: Any) {
        self.moreView.isHidden = false
    }
    
    @IBAction func resetThemeBtnClicked(_ sender: Any) {
        self.moreView.isHidden = true
        self.resetThemesRequest()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == self.moreView {
                moreView.isHidden = true
            }
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

extension ThemeVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModal.themeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let theme = self.viewModal.themeArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnlockableContentCVC", for: indexPath) as! UnlockableContentCVC
         cell.imageView.ImageViewLoading(mediaUrl: theme.image, placeHolderImage: nil)
         cell.coinLbl.text = theme.coin
         cell.leadingConst.constant = 0
         cell.trialConst.constant = 0
         cell.topConst.constant = 0
         cell.bottomConst.constant = 0
         cell.unlockBtn.addTarget(self, action: #selector(btnClicked(btn:)), for: .touchUpInside)
         cell.unlockBtn.tag = indexPath.row
         if theme.isUnlocked{
             cell.coinImageView.isHidden = true
             cell.coinLbl.isHidden = true
             if theme.isApplied{
                 cell.unlockBtn.setTitle("Remove", for: .normal)
             }else{
                 cell.unlockBtn.setTitle("Apply", for: .normal)
             }
         }else{
             cell.coinImageView.isHidden = false
             cell.coinLbl.isHidden = false
             cell.unlockBtn.setTitle("Unlock", for: .normal)
         }
         return cell
    }
    
    @objc func btnClicked(btn:UIButton){
        if let title = btn.titleLabel{
            let theme = self.viewModal.themeArray[btn.tag]
            if title.text == "Unlock"{
                self.alert(type: "Unlock", id: theme.themeId, index: btn.tag)
            }else if title.text == "Apply"{
                self.alert(type: "Apply", id: theme.userThemeId, index: btn.tag)
            }else if title.text == "Remove"{
                self.alert(type: "Remove", id: theme.userThemeId, index: btn.tag)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width / 2
        return CGSize(width:  cellWidth - 5, height: cellWidth + (cellWidth*0.30))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension ThemeVC{
    func alert(type:String,id:String,index:Int){
        let VC = self.getPopUpVC()
        if type == "Unlock"{
            VC.titleString = "Unlock"
            VC.messageString = MessageHelper.PopupMessage.unlockThemeMessage
        }else if type == "Apply"{
            VC.titleString = "Apply"
            VC.messageString = MessageHelper.PopupMessage.applyThemeMessage
        }else if type == "Remove"{
            VC.titleString = "Remove"
            VC.messageString = MessageHelper.PopupMessage.removeThemeMessage
        }
        VC.noBtnClick  = { [weak self]  in
            
        }
        VC.yesBtnClick  = { [weak self]  in
            if type == "Unlock"{
                self?.unlockThemesRequest(id: id, index: index)
            }else if type == "Apply"{
                self?.updateThemesRequest(id: id, status: true, index: index)
            }else if type == "Remove"{
                self?.updateThemesRequest(id: id, status: false, index: index)
            }
        }
        VC.modalPresentationStyle = .overFullScreen
        self.present(VC, animated: false, completion: nil)
    }
}

extension ThemeVC{
    
    func getThemesRequest(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.getThemes(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.collectionView.reloadData()
            self.collectionView.isHidden = self.viewModal.themeArray.count == 0
            self.emptyLbl.isHidden = self.viewModal.themeArray.count > 0
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func unlockThemesRequest(id:String,index:Int){
        let param = ["theme_id":Int(id)!] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.unlockThemes(urlParams: nil, param: param, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.themeUnlocked, type: .success)
            self.viewModal.themeArray[index].isUnlocked = true
            self.viewModal.themeArray[index].userThemeId = self.viewModal.userThemeId
            self.viewModal.userThemeId = ""
            self.collectionView.reloadData()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func updateThemesRequest(id:String,status:Bool,index:Int){
        let param = ["applied":status] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.updateUserTheme(id: id, urlParams: nil, param: param, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            if status{
                SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.themeApplied, type: .success)
                self.viewModal.themeArray[index].isApplied = true
            }else{
                SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.themeRemove, type: .success)
                self.viewModal.themeArray[index].isApplied = false
            }
            self.collectionView.reloadData()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func resetThemesRequest(){
        let param = ["applied":false] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.resetUserTheme(urlParams: nil, param: param, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.themeReset, type: .success)
            _ = self.viewModal.themeArray.map({$0.isApplied = false})
            UserModal.sharedInstance.userThemes = []
            self.collectionView.reloadData()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func removeThemesRequest(id:String,index:Int){
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.removeTheme(id: id, urlParams: nil, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.viewModal.themeArray[index].isUnlocked = false
            self.collectionView.reloadData()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
}
