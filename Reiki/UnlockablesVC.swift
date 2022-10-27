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
        //setCalendarBackground(date: Date())
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
        if selectedTab == 3{
           return 1
        }
        return self.viewModal.customGearSubArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{
            return self.viewModal.customGearArray.count
        }else{
            if selectedTab == 3{
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
                if selectedTab == 3{
                        let theme = self.viewModal.themeArray[indexPath.row]
                       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnlockableContentCVC", for: indexPath) as! UnlockableContentCVC
                        cell.imageView.ImageViewLoading(mediaUrl: theme.image, placeHolderImage: nil)
                        cell.coinLbl.text = theme.coin
                        cell.leadingConst.constant = 0
                        cell.trialConst.constant = 0
                        cell.topConst.constant = 0
                        cell.bottomConst.constant = 0
                       return cell
                }else{
                    let item = self.viewModal.customGearSubArray[indexPath.section].itemArray[indexPath.row]
                    if item.name.isEmpty{
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnlockableContentCVC", for: indexPath) as! UnlockableContentCVC
                        cell.imageView.ImageViewLoading(mediaUrl: item.image, placeHolderImage: nil)
                        cell.coinLbl.text = item.coin
                        cell.leadingConst.constant = 20
                        cell.topConst.constant = 20
                        cell.trialConst.constant = 20
                        cell.bottomConst.constant = 20
                        return cell
                    }else{
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnlockableContent1CVC", for: indexPath) as! UnlockableContent1CVC
                        cell.titleLbl.text = item.name
                        cell.imageView.ImageViewLoading(mediaUrl: item.image, placeHolderImage: nil)
                        cell.coinLbl.text = item.coin
                        return cell
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
            if selectedTab == 3 || self.viewModal.customGearSubArray[indexPath.section].itemArray[indexPath.row].name.isEmpty{
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
            selectedTab = Int(self.viewModal.customGearArray[indexPath.row].categoryId)!
            for index in 0..<self.viewModal.customGearArray.count {
                self.viewModal.customGearArray[index].isSelected = false
            }
            self.viewModal.customGearArray[indexPath.row].isSelected = true
            if self.viewModal.customGearArray[indexPath.row].categoryId == "3"{
                self.getThemesRequest()
            }else{
                self.getCustomGearSubRequest(categoryId: self.viewModal.customGearArray[indexPath.row].categoryId)
            }
            collectionView.reloadData()
            DispatchQueue.main.async {
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            DispatchQueue.main.async {
                self.contentCollectionView.setContentOffset(CGPoint(x:-5,y:0), animated: false)
            }
        }else{
            
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
            if selectedTab == 3 || self.viewModal.customGearSubArray[section].name.isEmpty{
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
                self.getCustomGearSubRequest(categoryId: gear.categoryId)
            }
            
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }

    func getCustomGearSubRequest(categoryId:String){
        let param = ["offset":0,
                     "limit":-1,
                     "populate":["custom_gear_sub_category"],
                     "where":["active":true,"custom_gear_category_id":Int(categoryId)!]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.getCustomGearCategorySub(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.contentCollectionView.reloadData()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func getThemesRequest(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.getThemes(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.contentCollectionView.reloadData()
            self.contentCollectionView.layoutIfNeeded()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
}

extension UnlockablesVC : SideMenuDelegate{
    func selectedIndex(row: Int) {
        if row == 11{
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
            self?.finalStep()
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.logoutSuccess, type: .success)
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
