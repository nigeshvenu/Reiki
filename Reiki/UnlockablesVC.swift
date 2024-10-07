//
//  UnlockablesVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 03/10/22.
//

import UIKit
import SideMenu
import CoreGraphics

struct Unlockables  {
    var name = ""
    var isSelected = false
}

struct UnlockablesContent  {
    var title = ""
    var image = ""
}

class UnlockablesVC: UIViewController {
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var contentCollectionView: UICollectionView!
    @IBOutlet var moreView: UIView!
    var unlockablesArray = [Unlockables]()
    var selectedTab = 0
    var charactersImageArray = ["Micheal","Thomas","Jessie","Linda","Ana"]
    var petsTitleArray = ["Dogs","Cats","Birds","Lizard","Horse"]
    var petsImageArray = [["lion","wolf"],
                          ["bobcat","cheetah","polarbear","panda"],
                          ["parrot","owl","eagle","bird1","bird2","bird3","bird4","bird5","bird6","bird7","bird8"],
                          ["crocodile"],
                          ["horse"]]
    var themesImageArray = [String]()
    var miscellaneousImageArray = ["guitar","wings","swords","drum","flute","halo","flowers","robot"]
    var petsContentArray = [[UnlockablesContent]]()
    var miscallenouseContentArray = [UnlockablesContent]()
    var viewModal = UnlockablesVM()
    //var themesCategoryId = "2" //dev
    var themesCategoryId = "3" //staging
    var selectedCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getCustomGearRequest()
    }
    
    func initialSettings(){
        moreView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let characters = Unlockables(name: "Characters", isSelected: true)
        let pets = Unlockables(name: "Pets", isSelected: false)
        let themes = Unlockables(name: "Themes", isSelected: false)
        let miscellaneous = Unlockables(name: "Miscellaneous", isSelected: false)
        unlockablesArray.append(characters)
        unlockablesArray.append(pets)
        unlockablesArray.append(themes)
        unlockablesArray.append(miscellaneous)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        //sidemenu
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
        sideMenuSettings()
        SideMenuManager.default.leftMenuNavigationController?.sideMenuDelegate = self
        contentCollectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        //contentCollectionView.register(HeaderRView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderRView")
        //Pets
        /*let dogs = [UnlockablesContent(title: "Wolf", image: "wolf"),UnlockablesContent(title: "Lion", image: "lion")]
        let cats = [UnlockablesContent(title: "Bobcat", image: "bobcat"),UnlockablesContent(title: "Cheetah", image: "cheetah"),UnlockablesContent(title: "Polar bear", image: "polarbear"),UnlockablesContent(title: "Panda", image: "panda")]
        let birds = [UnlockablesContent(title: "Parrot", image: "parrot"),
                     UnlockablesContent(title: "Owl", image: "owl"),
                     UnlockablesContent(title: "Eagle", image: "eagle"),
                     UnlockablesContent(title: "", image: "bird1"),
                     UnlockablesContent(title: "", image: "bird2"),
                     UnlockablesContent(title: "", image: "bird3"),
                     UnlockablesContent(title: "", image: "bird4"),
                     UnlockablesContent(title: "", image: "bird5"),
                     UnlockablesContent(title: "", image: "bird6"),
                     UnlockablesContent(title: "", image: "bird7"),
                     UnlockablesContent(title: "", image: "bird8")]
        let lizards = [UnlockablesContent(title: "Crocodile", image: "crocodile")]
        let horse = [UnlockablesContent(title: "Horse", image: "horse")]
        petsContentArray = [dogs,cats,birds,lizards,horse]
        
       //Miscalleneous
        miscallenouseContentArray = [UnlockablesContent(title: "Guitar", image: "guitar"),
                                     UnlockablesContent(title: "Wings", image: "wings"),
                                     UnlockablesContent(title: "Swords", image: "swords"),
                                     UnlockablesContent(title: "Drum", image: "drum"),
                                     UnlockablesContent(title: "Flute", image: "flute"),
                                     UnlockablesContent(title: "Halo", image: "halo"),
                                     UnlockablesContent(title: "Flower Decor", image: "flowers"),
                                     UnlockablesContent(title: "Robot", image: "robot")]*/
    }

    @IBAction func moreBtnClicked(_ sender: Any) {
        self.moreView.isHidden = false
    }
    
    @IBAction func purchaseHistoryBtnClicked(_ sender: Any) {
        self.moreView.isHidden = true
        let VC = self.getPurchaseHistoryVC()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == self.moreView {
                moreView.isHidden = true
            }
        }
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
extension UnlockablesVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.collectionView{
           return 1
        }
        if selectedTab == Int(themesCategoryId)!{
           return 1
        }
        return self.viewModal.customGearSubArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{
            return self.viewModal.customGearArray.count
        }else{
            if selectedTab == Int(themesCategoryId)!{
                return self.viewModal.themeArray.count
            }else{
                return self.viewModal.customGearSubArray[section].itemArray.count
            }
        }
        
    }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == self.collectionView{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnlockablesCVC", for: indexPath) as! UnlockablesCVC
                let unlockable = self.viewModal.customGearArray[indexPath.row]
                cell.unlockableTitleLbl.text = unlockable.categoryName
                cell.backGroundView.backgroundColor = unlockable.isSelected ? UIColor.init(hexString: "#AB3370") : UIColor.init(hexString: "#FFFFFF").withAlphaComponent(0.3)
                cell.unlockableTitleLbl.textColor = unlockable.isSelected ? UIColor.white : UIColor.black
                return cell
            }else{
                if selectedTab == Int(themesCategoryId)!{
                        let theme = self.viewModal.themeArray[indexPath.row]
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnlockableContentCVC", for: indexPath) as! UnlockableContentCVC
                        cell.imageView.ImageViewLoading(mediaUrl: theme.image, placeHolderImage: nil)
                        cell.coinLbl.text = theme.coin
                        cell.leadingConst.constant = 0
                        cell.trialConst.constant = 0
                        cell.topConst.constant = 0
                        cell.bottomConst.constant = 0
                        cell.unlockBtn.tag = indexPath.row
                        cell.unlockBtn.addTarget(self, action: #selector(unlockBtnClicked(btn:)), for: .touchUpInside)
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
                }else{
                    let item = self.viewModal.customGearSubArray[indexPath.section].itemArray[indexPath.row]
                    if item.name.isEmpty{
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnlockableContentCVC", for: indexPath) as! UnlockableContentCVC
                        cell.imageView.ImageViewLoading(mediaUrl: item.image, placeHolderImage: nil)
                        cell.coinLbl.text = item.requiredCoin
                        cell.leadingConst.constant = 20
                        cell.topConst.constant = 20
                        cell.trialConst.constant = 20
                        cell.bottomConst.constant = 20
                        if item.isUnlocked{
                            cell.coinImageView.isHidden = true
                            cell.coinLbl.isHidden = true
                            if item.isApplied{
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
                    }else{
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnlockableContent1CVC", for: indexPath) as! UnlockableContent1CVC
                        cell.titleLbl.text = item.name
                        cell.imageView.ImageViewLoading(mediaUrl: item.image, placeHolderImage: nil)
                        cell.coinLbl.text = item.requiredCoin
                        cell.unlockBtn.tag = indexPath.row
                        cell.unlockBtn.addTarget(self, action: #selector(unlockBtnClicked(btn:)), for: .touchUpInside)
                        if item.isUnlocked{
                            cell.coinImageView.isHidden = true
                            cell.coinLbl.isHidden = true
                            cell.levelView.isHidden = true
                            if item.isApplied{
                                cell.unlockBtn.setTitle("Remove", for: .normal)
                            }else{
                                cell.unlockBtn.setTitle("Apply", for: .normal)
                            }
                        }else{
                            cell.coinImageView.isHidden = false
                            cell.coinLbl.isHidden = false
                            cell.levelView.isHidden = item.levelNo.isEmpty
                            cell.levelNameLbl.text = "LVL \(item.levelNo)"
                            cell.levelImageView.image = LevelImageHelper.getImage(leveNumber: item.levelNo)
                            cell.unlockBtn.setTitle("Unlock", for: .normal)
                        }
                        cell.previewBtn.tag = indexPath.row
                        cell.previewBtn.addTarget(self, action: #selector(previewBtnClicked(btn:)), for: .touchUpInside)
                        return cell
                    }
                }
                
            }
    }
    
    @objc func previewBtnClicked(btn:UIButton){
        let buttonPostion = btn.convert(btn.bounds.origin, to: contentCollectionView)
        if let indexPath = contentCollectionView.indexPathForItem(at: buttonPostion){
            let gear = self.viewModal.customGearSubArray[indexPath.section].itemArray[indexPath.row]
            guard let url = URL(string: gear.animationUrl), !gear.animationUrl.isEmpty else {
                SwiftMessagesHelper.showSwiftMessage(title: "", body: "\(MessageHelper.ErrorMessage.animationEmpty)", type: .success)
                return
            }
            let VC = self.getAnimationPreviewVC()
            VC.animationUrl = url
            let nav = UINavigationController(rootViewController: VC)
            self.present(nav, animated: true)
        }
    }
    
    @objc func unlockBtnClicked(btn:UIButton){
        if selectedTab == Int(themesCategoryId)!{
            if let title = btn.titleLabel?.text {
                let theme = self.viewModal.themeArray[btn.tag]
                if title == "Unlock"{
                    self.alertTheme(type: title, id: theme.themeId, index: btn.tag)
                }else if title == "Apply"{
                    self.alertTheme(type: title, id: theme.userThemeId, index: btn.tag)
                }else if title == "Remove"{
                    self.alertTheme(type: title, id: theme.userThemeId, index: btn.tag)
                }
            }
        }else{
            let buttonPostion = btn.convert(btn.bounds.origin, to: contentCollectionView)
            if let indexPath = contentCollectionView.indexPathForItem(at: buttonPostion){
                print(indexPath)
                let gear = self.viewModal.customGearSubArray[indexPath.section].itemArray[indexPath.row]
                if let title = btn.titleLabel?.text {
                    if title == "Unlock"{
                        if Int(UserModal.sharedInstance.levelNumber) ?? 0 <  Int(gear.levelNo) ?? 0{
                            alertLevelNoReached(level: gear.levelNo)
                        }else{
                            self.alertCustomGear(type: "Unlock", id: gear.itemId, indexPath: indexPath)
                        }
                    }else if title == "Apply"{
                        self.alertCustomGear(type: "Apply", id: gear.userCustomGearId, indexPath: indexPath)
                    }else if title == "Remove"{
                        self.alertCustomGear(type: "Remove", id: gear.userCustomGearId, indexPath: indexPath)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView{
            let item = unlockablesArray[indexPath.row].name
            let itemSize = item.size(withAttributes: [
                    NSAttributedString.Key.font : FontHelper.montserratFontSize(fontType: .semiBold, size: 16.0)
                   ])
            
            return CGSize(width: itemSize.width + 30, height: 36)
        }else{
            if selectedTab == Int(themesCategoryId)! || self.viewModal.customGearSubArray[indexPath.section].itemArray[indexPath.row].name.isEmpty{
                let cellWidth = collectionView.frame.size.width / 2
                return CGSize(width:  cellWidth - 5, height: cellWidth + (cellWidth*0.30))
            }else{
                let cellWidth = collectionView.frame.size.width / 2
                return CGSize(width:  cellWidth - 5, height: cellWidth + (cellWidth*0.20))
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView{
            collectionView.reloadData()
            DispatchQueue.main.async {
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            selectedTab = Int(self.viewModal.customGearArray[indexPath.row].categoryId)!
            let categoryName = self.viewModal.customGearArray[indexPath.row].categoryName
            if categoryName == "Miscellaneous"{
                selectedCategory = self.viewModal.customGearArray[indexPath.row].categoryName
            }else{
                selectedCategory = self.viewModal.customGearArray[indexPath.row].categoryName.dropLast().string
            }
            for index in 0..<self.viewModal.customGearArray.count {
                self.viewModal.customGearArray[index].isSelected = false
            }
            self.viewModal.customGearArray[indexPath.row].isSelected = true
            /*if self.viewModal.customGearArray[indexPath.row].categoryId == themesCategoryId{
                self.getThemesRequest()
            }else{
                self.getCustomGearSubRequest(categoryId: self.viewModal.customGearArray[indexPath.row].categoryId, scrolltoTop: true)
            }*/
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == self.contentCollectionView{
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderRView", for: indexPath) as! HeaderRView
                let header = self.viewModal.customGearSubArray[indexPath.section]
                headerView.titleLbl.text = header.name
                return headerView
            default:
                return UICollectionReusableView()
                assert(false, "Unexpected element kind")
            }
        }else{
            return UICollectionReusableView()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == self.contentCollectionView{
            if selectedTab == Int(themesCategoryId)! || self.viewModal.customGearSubArray[section].name.isEmpty{
                return .zero
            }
            return CGSize(width: collectionView.frame.width, height: 40)
        }else{
            return .zero
        }
    }
    
}

extension UnlockablesVC{
    func getCustomGearRequest(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.getCustomGearCategory(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.collectionView.reloadData()
            if let gear = self.viewModal.customGearArray.first{
                self.getCustomGearSubRequest(categoryId: gear.categoryId, scrolltoTop: false)
                self.selectedCategory = gear.categoryName.dropLast().string
                self.selectedTab = Int(gear.categoryId)!
            }
            
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }

    func getCustomGearSubRequest(categoryId:String,scrolltoTop:Bool){
        let param = ["offset":0,
                     "limit":-1,
                     "populate":["level"],
                     "where":["custom_gear_category_id":Int(categoryId)!]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.getCustomGearCategorySub(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.contentCollectionView.reloadData()
            if scrolltoTop{
                //DispatchQueue.main.async {
                    self.contentCollectionView.setContentOffset(CGPoint(x:-5,y:0), animated: false)
                //}
            }
           
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func getThemesRequest(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":[]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.getThemes(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.contentCollectionView.reloadData()
            //DispatchQueue.main.async {
                self.contentCollectionView.setContentOffset(CGPoint(x:-5,y:0), animated: false)
            //}
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
}

extension UnlockablesVC{ //Themes
    
    func unlockThemesRequest(id:String,index:Int){
        let param = ["theme_id":Int(id)!] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.unlockThemes(urlParams: nil, param: param, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.themeUnlocked, type: .success)
            self.viewModal.themeArray[index].isUnlocked = true
            self.viewModal.themeArray[index].userThemeId = self.viewModal.userThemeId
            self.viewModal.userThemeId = ""
            self.contentCollectionView.reloadData()
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
            self.contentCollectionView.reloadData()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
}

extension UnlockablesVC{ //Custom gear
    func unlockGearRequest(id:String){
        let param = ["custom_gear_id":Int(id)!] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.unlockCustomGear(urlParams: nil, param: param, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: "\(self.selectedCategory) \(MessageHelper.SuccessMessage.unlocked)", type: .success)
            self.getCustomGearSubRequest(categoryId: String(self.selectedTab), scrolltoTop: false)
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func updateCustomGearRequest(id:String,status:Bool,index:IndexPath){
        let param = ["applied":status] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.updateCustomGear(id: id, urlParams: nil, param: param, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            if status{
                SwiftMessagesHelper.showSwiftMessage(title: "", body: "\(self.selectedCategory) \(MessageHelper.SuccessMessage.gearApplied)", type: .success)
                self.viewModal.customGearSubArray[index.section].itemArray[index.row].isApplied = true
            }else{
                SwiftMessagesHelper.showSwiftMessage(title: "", body: "\(self.selectedCategory) \(MessageHelper.SuccessMessage.gearRemove)", type: .success)
                self.viewModal.customGearSubArray[index.section].itemArray[index.row].isApplied = false
            }
            self.contentCollectionView.reloadData()
            UserDefaults.standard.removeObject(forKey: "customGear")
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
}


extension UnlockablesVC{
    func alertTheme(type:String,id:String,index:Int){
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
    
    func alertCustomGear(type:String,id:String,indexPath:IndexPath){
        let VC = self.getPopUpVC()
        if type == "Unlock"{
            VC.titleString = "Unlock"
            VC.messageString = "\(MessageHelper.PopupMessage.unlockMessage) \(selectedCategory)?"
        }else if type == "Apply"{
            VC.titleString = "Apply"
            VC.messageString = "\(MessageHelper.PopupMessage.applyMessage) \(selectedCategory)?"
        }else if type == "Remove"{
            VC.titleString = "Remove"
            VC.messageString = "\(MessageHelper.PopupMessage.removeMessage) \(selectedCategory)?"
        }
        VC.noBtnClick  = { [weak self]  in
            
        }
        VC.yesBtnClick  = { [weak self]  in
            if type == "Unlock"{
                self?.unlockGearRequest(id: id)
            }else if type == "Apply"{
                self?.updateCustomGearRequest(id: id, status: true, index: indexPath)
            }else if type == "Remove"{
                self?.updateCustomGearRequest(id: id, status: false, index: indexPath)
            }
        }
        VC.modalPresentationStyle = .overFullScreen
        self.present(VC, animated: false, completion: nil)
    }
    
    func alertLevelNoReached(level:String){
        let VC = self.getPopUpVC()
        VC.titleString = "Level Not Reached"
        VC.messageString = "You need to reach level \(level) to unlock this item."
        VC.noBtnClick  = { [weak self]  in
            
        }
        VC.yesBtnClick  = { [weak self]  in
        }
        VC.modalPresentationStyle = .overFullScreen
        self.present(VC, animated: false, completion: nil)
    }
}

extension UnlockablesVC : SideMenuDelegate{
    func selectedIndex(row: Int) {
        if row == 9{
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
            self?.logoutRequest()
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
    
    func logoutRequest(){
        let param = ["session_id":UserDefaultsHelper().getSessionId()]
        AppDelegate.shared.showLoading(isShow: true)
        LoginVM().logout(urlParams: nil, param: param) { (message) in
            AppDelegate.shared.showLoading(isShow: false)
            self.finalStep()
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.logoutSuccess, type: .success)
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
        UserModal.sharedInstance.reset()
        self.goToLogin()
    }
}

extension UnlockablesVC: SideMenuNavigationControllerDelegate {

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

extension LosslessStringConvertible {
    var string: String { .init(self) }
}
