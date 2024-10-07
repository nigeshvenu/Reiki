//
//  HomePageVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 30/08/22.
//

import UIKit
import SideMenu
import Lightbox
import Lottie

class HomePageVC: UIViewController {

    @IBOutlet var characterImageView: UIImageView!
    @IBOutlet var coinLbl: UILabel!
    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var levelImageMainView: UIImageView!
    @IBOutlet var levelImage: UIImageView!
    @IBOutlet var levelNumberLbl: UILabel!
    @IBOutlet var prestigeIcon: UIImageView!
    @IBOutlet var purchaseView: UIView!
    @IBOutlet weak var purchasedAnimatioView: UIView!
    
    //Prestige
    
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4View: UIView!
    @IBOutlet weak var star4CountLbl: UILabel!
    
    var viewModal = UnlockablesVM()
    var timer: Timer?
    var timerIntervalHour : CGFloat = 3600 * 1
    var timerIntervalSeconds : CGFloat = 3600 * 11
    
    private let animationView = AnimationView()
    private var loopMode = LottieLoopMode.loop
    private var fromProgress: AnimationProgressTime = 0
    private var toProgress: AnimationProgressTime = 1
    
    var animationURLs: [[String: String]]  = []
    var currentAnimationIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSettings()
        addAnimationView()
        userCustomGearRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setAvatarImage()
        self.getUserRequest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        invalidateTimer()
    }
    
    func initialSettings(){
        levelImageMainView.layer.cornerRadius = 36/2
        //characterImageView.image = UIImage(named: "C\(UserModal.sharedInstance.avatar)Pose1")
        coinLbl.text = UserModal.sharedInstance.coin
        //self.slideShowImages()
        //Sidemenu
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
        sideMenuSettings()
        SideMenuManager.default.leftMenuNavigationController?.sideMenuDelegate = self
        purchaseView.backgroundColor = UIColor.black.withAlphaComponent(0.38)
        purchaseView.setRoundCorners([.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: 25)
        if let interval = UserModal.sharedInstance.configuration.filter({$0.type == "avatar_interval"}).first{
            if let n = NumberFormatter().number(from: interval.point) {
                timerIntervalSeconds = CGFloat(truncating: n)
            }
        }
    }
    
    func setUI(){
        coinLbl.text = UserModal.sharedInstance.coin
        levelNumberLbl.text = "LVL " + UserModal.sharedInstance.levelNumber
        levelImage.image = LevelImageHelper.getImage(leveNumber: UserModal.sharedInstance.levelNumber)
        //prestigeIcon.isHidden = !UserModal.sharedInstance.prestige
        //prestige
        if !UserModal.sharedInstance.prestige{
            star1ImageView.isHidden = true
            star2ImageView.isHidden = true
            star3ImageView.isHidden = true
            star4View.isHidden = true
        }else{
            let prestigeTotalRestart = Int(UserModal.sharedInstance.totalPrestigeRestart) ?? 0
            star1ImageView.isHidden = prestigeTotalRestart == 0
            star2ImageView.isHidden = prestigeTotalRestart < 2
            star3ImageView.isHidden = prestigeTotalRestart < 3
            star4View.isHidden = prestigeTotalRestart < 4
            star4CountLbl.text = String(prestigeTotalRestart)
        }
        
    }
    
    func startTimer(interval:CGFloat){
        timer = Timer.scheduledTimer(timeInterval: interval,
                                             target: self,
                                             selector: #selector(eventWith(timer:)),
                                             userInfo: nil,
                                             repeats: true)
    }
    
    @objc func eventWith(timer: Timer!) {
        setAvatarImage()
    }
    
    func invalidateTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    func setAvatarImage(){
        let avatarIndex = UserDefaultsHelper().getAvatarIndex(withInterval: timerIntervalSeconds)
        //print("C\(UserModal.sharedInstance.avatar)Pose\(avatarIndex.0.string)")
        characterImageView.image = UIImage(named: "C\(UserModal.sharedInstance.avatar)Pose\(avatarIndex.0.string)")!
        invalidateTimer()
        //print("Timer started with Remaining time : \(avatarIndex.1)")
        self.startTimer(interval: avatarIndex.1)
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
    
    @IBAction func levelBtnClicked(_ sender: Any) {
        let VC = self.getLevelVC()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func goldCoinBtnClicked(_ sender: Any) {
        let VC = self.getGoldCoinVC()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func badgeBtnClicked(_ sender: Any) {
        let VC = self.getBadgeVC()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func cardFinderBtnClicked(_ sender: Any) {
        let VC = self.getCardFinderVC()
        VC.showBackBtn = true
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    @IBAction func purchaseBtnClicked(_ sender: Any) {
        
        self.userCustomGearRequest()
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

extension HomePageVC{
    
    func slideShowImages(){
        var images = [UIImage]()
        let count = UserModal.sharedInstance.avatar == "Micheal" ? 3 : 8
        let duration = UserModal.sharedInstance.avatar == "Micheal" ? 9.0 : 24.0
        for i in 1...count{
           images.append(UIImage(named: "C\(UserModal.sharedInstance.avatar)Pose\(i)")!)
        }
        characterImageView.animationImages = images
        characterImageView.animationDuration = duration
        characterImageView.startAnimating()
    }
    
}

extension HomePageVC{
    
    func presentImage(){
        var images = [LightboxImage]()
        for image in self.viewModal.purchaseHistoryArray{
            if let url = URL(string: image.image){
                print(image.name)
                images.append(LightboxImage(imageURL: url,text: image.name))
            }
        }
        if images.count > 0{
            // Create an instance of LightboxController.
            let controller = LightboxController(images: images)
            //LightboxConfig.CloseButton.self.text = ""
            //LightboxConfig.CloseButton.self.size = CGSize(width: 20, height: 20)
            //LightboxConfig.CloseButton.self.image = UIImage(named: "closewhite")
            // Set delegates.
            //controller.pageDelegate = self
            //controller.dismissalDelegate = self
            // Use dynamic background.
            controller.dynamicBackground = true
            // Present your controller.
            present(controller, animated: true, completion: nil)
        }else{
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.purchaseElementsEmpty, type: .success)
        }
    }
}

extension HomePageVC{
    
    /*func userCustomGearRequest(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true,"user_id":Int(UserModal.sharedInstance.userId)!,"applied":true],
                     "sort":[["created_at","DESC"]],
                     "populate":["+custom_gear"]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.getCustomGear(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.presentImage()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }*/
    
    func userCustomGearRequest(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true,"user_id":Int(UserModal.sharedInstance.userId)!,"applied":true],
                     "sort":[["updated_at","ASC"]],
                     "populate":["custom_gear"]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.getCustomGear(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.loadAnimation()
            self.characterImageView.isHidden = self.animationURLs.count > 0
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func loadAnimation(){
        if let purchaseHistory = UserDefaults().array(forKey: "customGear") as? [[String: String]]  {
            self.animationURLs = purchaseHistory
            if purchaseHistory.count > 0{
                self.loadNextAnimation()
            }
            print("Total no of animations :\(purchaseHistory.count)")
        }
    }
    
}

extension HomePageVC{
    
    func getUserRequest(){
        let param = ["populate":["level"]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        LoginVM().getUser(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.setUI()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
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
}

extension HomePageVC : SideMenuDelegate{
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

extension HomePageVC: SideMenuNavigationControllerDelegate {

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

extension HomePageVC{
    
    func addAnimationView(){
        self.purchasedAnimatioView.addSubview(animationView)
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.isUserInteractionEnabled = false
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          animationView.topAnchor.constraint(equalTo: self.purchasedAnimatioView.topAnchor, constant: 0),
          animationView.leadingAnchor.constraint(equalTo: self.purchasedAnimatioView.leadingAnchor, constant: 0),
          animationView.bottomAnchor.constraint(equalTo: self.purchasedAnimatioView.bottomAnchor, constant: 0),
          animationView.trailingAnchor.constraint(equalTo: self.purchasedAnimatioView.trailingAnchor, constant: 0)
        ])
    }
    
    func loadNextAnimation() {
        guard currentAnimationIndex < animationURLs.count else {
            print("All animations loaded")
            currentAnimationIndex = 0
            resetCompletedStatus()
            loadNextAnimation()
            return
        }
        let animationModal = animationURLs[currentAnimationIndex]
        if animationModal["completed"] == "N" {
            guard let urlString = animationModal["url"], let url = URL(string: urlString) else {
                print("Invalid URL format at index \(currentAnimationIndex)")
                currentAnimationIndex += 1
                loadNextAnimation()
                return
            }
            //Load animation from url
            loadAnimationFromUrl(url: url)
        } else {
            currentAnimationIndex += 1
            loadNextAnimation()
        }
    }
    
    func loadAnimationFromUrl(url:URL){
        Animation.loadedFrom(url: url, closure: { [weak self] animation in
            guard let self = self else { return }
            if let animation = animation {
                print("Animation Started Playing at index : \(currentAnimationIndex)")
                self.animationView.animation = animation
                self.animationView.contentMode = .scaleAspectFit
                //Play Animation
                self.playAnimation(completion: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.updateCompletionStatus()
                })
            }else {
                print("Failed to load animation at index \(self.currentAnimationIndex)")
                self.currentAnimationIndex += 1
                self.loadNextAnimation()
            }
        }, animationCache: LRUAnimationCache.sharedCache)
    }

    func updateCompletionStatus() {
        guard let purchaseHistory = UserDefaults.standard.array(forKey: "customGear") as? [[String: String]],
              currentAnimationIndex < purchaseHistory.count else {
            currentAnimationIndex += 1
            loadNextAnimation()
            return
        }

        var updatedPurchaseHistory = purchaseHistory
        updatedPurchaseHistory[currentAnimationIndex]["completed"] = "Y"
        UserDefaults.standard.set(updatedPurchaseHistory, forKey: "customGear")
        animationURLs = updatedPurchaseHistory
        currentAnimationIndex += 1
        loadNextAnimation()
    }
    
    func resetCompletedStatus(){
        if var purchaseHistory = UserDefaults.standard.array(forKey: "customGear") as? [[String: String]] {
            for index in 0..<purchaseHistory.count {
                purchaseHistory[index]["completed"] = "N"
            }
            UserDefaults.standard.set(purchaseHistory, forKey: "customGear")
            self.animationURLs = purchaseHistory
        }
    }
    
    func playAnimation(completion: (() -> Void)? = nil) {
    
        animationView.play { status in
            if status{
                print("Animation Completed Playing")
                completion?()
            }
        }
    }
    
}
