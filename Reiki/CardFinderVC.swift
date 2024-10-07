//
//  CardFinderVC.swift
//  Reiki Avatar Editor
//
//  Created by NewAgeSMB on 15/07/22.
//

import UIKit
import Lottie
import SideMenu
import SwiftyAttributes

class CardFinderVC: UIViewController {
    @IBOutlet var card1: UIView!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var monthLbl: UILabel!
    @IBOutlet var card2: UIView!
    @IBOutlet var card2GoldCoinLbl: UILabel!
    @IBOutlet var card2ImageView: UIImageView!
    @IBOutlet var card2TitleLbl: UILabel!
    @IBOutlet var card2SubtitleLbl: UILabel!
    @IBOutlet var card3: UIView!
    @IBOutlet var card3GoldCoinLbl: UILabel!
    @IBOutlet var card3ImageView: UIImageView!
    @IBOutlet var card3TitleLbl: UILabel!
    @IBOutlet var card3SubtitleLbl: UILabel!
    @IBOutlet var cardPlayBtn: UIButton!
    @IBOutlet var image1: UIImageView!
    @IBOutlet var detailBottomVie: UIView!
    @IBOutlet var unlockedDateLbl: UILabel!
    @IBOutlet var unlockedCard1Lbl: UILabel!
    @IBOutlet var unlockedCard2Lbl: UILabel!
    @IBOutlet var noDateView: UIView!
    @IBOutlet var calendarHeightConst: NSLayoutConstraint!
    @IBOutlet var calendarTopConst: NSLayoutConstraint!
    @IBOutlet var congratsView: UIView!
    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var timerViewHeightConst: NSLayoutConstraint!
    @IBOutlet var timerViewLbl: UILabel!
    @IBOutlet var moreView: UIView!
    
    var timer : Timer?
    var isApiFinished = false
    var counter = 0
    private let animationView1 = AnimationView()
    private let animationView2 = AnimationView()
    private let animationView3 = AnimationView()
    private let skeletonAnimationView = AnimationView()
    
    private var loopMode = LottieLoopMode.playOnce
    private var fromProgress: AnimationProgressTime = 0.3
    private var toProgress: AnimationProgressTime = 0.5
    var blur1 : UIVisualEffectView!
    var blur2 : UIVisualEffectView!
    var blur3 : UIVisualEffectView!
    var lock1:UIImageView!
    var lock2:UIImageView!
    var lock3:UIImageView!
    var viewModal = CardFinderVM()
    var stopCardFinder = false
    var showBackBtn = false
    var nextCardTimer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.resetCardFinder()
        self.getUserRequest()
    }
    
    func resetCardFinder(){
        self.timer?.invalidate()
        self.counter = 0
        self.defaultState(showCardBtn: true)
        self.detailBottomVie.isHidden = true
        self.calendarTopConst.constant = 12
        self.calendarHeightConst.constant = 32
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        timer?.invalidate()
        nextCardTimer?.invalidate()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initialSettings(){
        menuBtn.isHidden = showBackBtn
        backBtn.isHidden = !showBackBtn
        
        if !showBackBtn{
            //sidemenu
            SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
            SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
            sideMenuSettings()
            SideMenuManager.default.leftMenuNavigationController?.sideMenuDelegate = self
        }
        
        addBlurView()
        addLockImageView()
        addParticleAnimation(imageView: card1, animationView: animationView1)
        addParticleAnimation(imageView: card2, animationView: animationView2)
        addParticleAnimation(imageView: card3, animationView: animationView3)
        addCongratsAnimation()
    }
    
    func initialFlipCard(){
        cardPlayBtn.isHidden = false
        cardPlayBtn.isEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.flipCard), userInfo: nil, repeats: true)
    }
    
    @objc func flipCard(){
        if counter == 2{
            timer?.invalidate()
            counter = 0
            cardPlayBtn.isEnabled = true
            return
        }
        counter += 1
        spinCards()
    }
    
    @IBAction func moreBtnClicked(_ sender: Any) {
        self.moreView.isHidden = false
    }
    
    @IBAction func cardHistoryBtnClicked(_ sender: Any) {
        self.moreView.isHidden = true
        let VC = self.getCardHistoryVC()
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == self.moreView {
                moreView.isHidden = true
            }
        }
    }
    
    func checkNextCardFinderDate(){
        var showCountDown = false
        if UserModal.sharedInstance.lastCardFinder != nil{
            if let interval = UserModal.sharedInstance.configuration.filter({$0.type == "card_finder_interval"}).first{
                let value = Int(interval.point) ?? 0
                let currentDate = Date().toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
                let currentDateAsDate = currentDate.date(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") ?? Date()
                let calendar = Calendar.current
                let nextCardFinderDate = calendar.date(byAdding: .hour, value: value, to: UserModal.sharedInstance.lastCardFinder!) ?? Date()
                print("Last card Finder \(UserModal.sharedInstance.lastCardFinder!.toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"))")
                print("Next card Finder \(nextCardFinderDate.toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"))")
                print("Current card Finder \(currentDateAsDate.toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"))")
                let order = Calendar.current.compare(nextCardFinderDate, to: currentDateAsDate, toGranularity: .second)
                if order == .orderedDescending{
                    showCountDown = true
                }
            }
        }
        
        if !showCountDown{
            initialFlipCard()
        }else{
            self.timerViewHeightConst.constant = 57
            nextCardTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTimer(){
        var intervalInt = 0
        if let interval = UserModal.sharedInstance.configuration.filter({$0.type == "card_finder_interval"}).first{
            intervalInt = Int(interval.point) ?? 0
        }
        let currentDate = Date().toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        let currentDateAsDate = currentDate.date(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") ?? Date()
        let calendar = Calendar.current
        let nextCardFinderDate = calendar.date(byAdding: .hour, value: intervalInt, to: UserModal.sharedInstance.lastCardFinder ?? Date()) ?? Date()
        let dateDifference = nextCardFinderDate.offsetFrom(date: currentDateAsDate)
        if dateDifference.isEmpty{
            nextCardTimer?.invalidate()
            timerViewHeightConst.constant = 0
            initialFlipCard()
        }else{
            self.timerViewLbl.text = "Please try again in \(dateDifference)"
        }
    }
    
    /*@objc func flipCardAndPlayAnimation(){
        if isApiFinished && counter > 2{
            timer.invalidate()
            counter = 0
            sendSubViewBack(card: card1)
            expandCard(card: card1, completion: {
                
                self.playParticleAnimation(animationView: self.animationView1, completion: {
                    //self.blur1.isHidden = true
                    UIView.animate(withDuration: 0.5) {
                        self.blur1.effect = nil
                    }
                    self.lock1.isHidden = true
                    self.sendSubViewBack(card: self.card2)
                    self.setCard1UI()
                    self.expandCard(card: self.card2, completion: {
                        self.playParticleAnimation(animationView: self.animationView2, completion: {
                            //self.blur2.isHidden = true
                            UIView.animate(withDuration: 0.5) {
                                self.blur2.effect = nil
                            }
                            self.lock2.isHidden = true
                            self.sendSubViewBack(card: self.card3)
                            self.setCard2UI()
                            
                            self.expandCard(card: self.card3, completion: {
                                self.playParticleAnimation(animationView: self.animationView3, completion: {
                                    //self.blur3.isHidden = true
                                    UIView.animate(withDuration: 0.5) {
                                        self.blur3.effect = nil
                                    }
                                    self.lock3.isHidden = true
                                    self.setCard3UI()
                                    self.cardPlayBtn.isEnabled = true
                                    self.cardPlayBtn.isHidden = true
                                    self.detailBottomVie.isHidden = false
                                    self.setDetailViewUI()
                                })
                            })
                        })
                    })
                })
            })
            return
        }
        counter += 1
        spinCards()
    }*/
    
    @objc func flipCardAndPlayAnimation(){
        if isApiFinished && counter > 2{
            timer?.invalidate()
            counter = 0
            self.cardPlayBtn.isEnabled = true
            self.cardPlayBtn.isHidden = true
            sendSubViewBack(card: card1)
            expandCard(card: card1, completion: {
                self.playParticleAnimation(animationView: self.animationView1, completion: {
                    //self.blur1.isHidden = true
                    UIView.animate(withDuration: 0.5) {
                        self.blur1.effect = nil
                    }
                    self.lock1.isHidden = true
                    self.sendSubViewBack(card: self.card2)
                    self.setCard1UI()
                })
            })
            self.expandCard(card: self.card2, completion: {
                self.playParticleAnimation(animationView: self.animationView2, completion: {
                    //self.blur2.isHidden = true
                    UIView.animate(withDuration: 0.5) {
                        self.blur2.effect = nil
                    }
                    self.lock2.isHidden = true
                    self.sendSubViewBack(card: self.card3)
                    self.setCard2UI()
                })
            })
            self.expandCard(card: self.card3, completion: {
                self.playParticleAnimation(animationView: self.animationView3, completion: {
                    //self.blur3.isHidden = true
                    UIView.animate(withDuration: 0.5) {
                        self.blur3.effect = nil
                    }
                    self.lock3.isHidden = true
                    self.congratsView.isHidden = false
                    self.playCongratsAnimation(animationView: self.skeletonAnimationView) {
                        self.congratsView.isHidden = true
                    }
                    self.setCard3UI()
                    self.detailBottomVie.isHidden = false
                    self.setDetailViewUI()
                })
            })
            return
        }
        counter += 1
        spinCards()
    }
    func setCard1UI(){
        if let event = self.viewModal.event{
            self.dateLbl.text = event.eventdateAsDate.toString(dateFormat: "dd")
            self.monthLbl.text = event.eventdateAsDate.toString(dateFormat: "MMMM")
        }
        noDateView.isHidden = self.viewModal.event != nil
    }
    
    func setCard2UI(){
        let cards = self.viewModal.cardArray
        if cards.indices.contains(0){
            let card1 = cards[0]
            card2ImageView.image = setCardImage(cardId: card1.cardId, random: card1.random)
            card2GoldCoinLbl.text = card1.goldCoins
            card2TitleLbl.text = card1.name
            card2SubtitleLbl.text = card1.occurance
        }
    }
    
    func setCard3UI(){
        let cards = self.viewModal.cardArray
        if cards.indices.contains(1){
            let card2 = cards[1]
            card3ImageView.image = setCardImage(cardId: card2.cardId, random: card2.random)
            card3GoldCoinLbl.text = card2.goldCoins
            card3TitleLbl.text = card2.name
            card3SubtitleLbl.text = card2.occurance
        }
    }
    
    func setDetailViewUI(){
        if let event = self.viewModal.event{
            self.unlockedDateLbl.attributedText = "You have unlocked the date ".withFont(FontHelper.montserratFontSize(fontType: .medium, size: 12)) + event.eventdateAsDate.toString(dateFormat: "MMMM d, yyyy").withFont(FontHelper.montserratFontSize(fontType: .Bold, size: 13))
        }else{
            self.unlockedDateLbl.text = ""
            self.calendarTopConst.constant = 0
            self.calendarHeightConst.constant = 0
        }
        self.unlockedDateLbl.isHidden = self.viewModal.event == nil
        let cards = self.viewModal.cardArray
        if cards.indices.contains(0){
            self.unlockedCard1Lbl.attributedText = "You have earned ".withFont(FontHelper.montserratFontSize(fontType: .medium, size: 12)) + "\(cards[0].goldCoins) Gold coins".withFont(FontHelper.montserratFontSize(fontType: .Bold, size: 13))
        }
        if cards.indices.contains(1){
            self.unlockedCard2Lbl.attributedText = "You have earned ".withFont(FontHelper.montserratFontSize(fontType: .medium, size: 12)) + "\(cards[1].goldCoins) Gold coins".withFont(FontHelper.montserratFontSize(fontType: .Bold, size: 13))
        }
        //NotificationCenter.default.post(name: Notification.Name("Notification"), object: nil)
    }
    
    func setCardImage(cardId:String,random:String)->UIImage{
        var image = UIImage()
        //let randomNumber = String(Int.random(in: 1..<3))
        let randomNumber = Int(random) ?? 1
        if cardId == "1"{
            image = UIImage(named: "ReikiParticle\(randomNumber)")!
        }else if cardId == "2"{
            image = UIImage(named: "SpiritAnimal\(randomNumber)")!
        }else if cardId == "3"{
            image = UIImage(named: "LoveEnergy\(randomNumber)")!
        }else if cardId == "4"{
            image = UIImage(named: "TheDivineFeminine\(randomNumber)")!
        }else if cardId == "5"{
            image = UIImage(named: "TranscendentalEnjoyer\(randomNumber)")!
        }else if cardId == "6"{
            image = UIImage(named: "BirdInstict\(randomNumber)")!
        }else if cardId == "7"{
            image = UIImage(named: "MountainBoost\(randomNumber)")!
        }else if cardId == "8"{
            image = UIImage(named: "Oneness\(randomNumber)")!
        }else if cardId == "9"{
            image = UIImage(named: "RareDiamond\(randomNumber)")!
        }
        return image
    }
    
    func sendSubViewBack(card:UIView){
        //self.view.sendSubviewToBack(card1)
        //self.view.sendSubviewToBack(card2)
        //self.view.sendSubviewToBack(card3)
        //self.view.bringSubviewToFront(card)
    }
    
    func spinCards(){
        UIView.transition(with: card1, duration: 1, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        UIView.transition(with: card2, duration: 1, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        UIView.transition(with: card3, duration: 1, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }

    func addParticleAnimation(imageView:UIView,animationView:AnimationView){
        
     
        let animation = Animation.named("Lock_Anime")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        imageView.addSubview(animationView)
        //animationView.isHidden = true
        animationView.loopMode = .playOnce
        animationView.isUserInteractionEnabled = false
        animationView.backgroundBehavior = .stop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        animationView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 0).isActive = true
        animationView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor, constant: 0).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
       /* NSLayoutConstraint.activate([
          animationView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 85),
          animationView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -85),
          animationView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -85),
          animationView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 85)
        ])*/
    }
    
    func addSkeletonAnimation(){
        let animation = Animation.named("skeleton-rectangle")
        skeletonAnimationView.animation = animation
        skeletonAnimationView.contentMode = .scaleAspectFit
        cardPlayBtn.addSubview(skeletonAnimationView)
        //animationView.isHidden = true
        skeletonAnimationView.loopMode = .loop
        skeletonAnimationView.isUserInteractionEnabled = false
        skeletonAnimationView.backgroundBehavior = .stop
        skeletonAnimationView.translatesAutoresizingMaskIntoConstraints = false
        skeletonAnimationView.topAnchor.constraint(equalTo: cardPlayBtn.topAnchor, constant: 0).isActive = true
        skeletonAnimationView.bottomAnchor.constraint(equalTo: cardPlayBtn.bottomAnchor, constant: 0).isActive = true
        skeletonAnimationView.leftAnchor.constraint(equalTo: cardPlayBtn.leftAnchor, constant: 0).isActive = true
        skeletonAnimationView.trailingAnchor.constraint(equalTo: cardPlayBtn.trailingAnchor, constant: 0).isActive = true
        skeletonAnimationView.play()
    }
    
    func addCongratsAnimation(){
        let animation = Animation.named("congrats")
        skeletonAnimationView.animation = animation
        skeletonAnimationView.contentMode = .scaleAspectFit
        congratsView.addSubview(skeletonAnimationView)
        skeletonAnimationView.isHidden = true
        skeletonAnimationView.loopMode = .playOnce
        skeletonAnimationView.isUserInteractionEnabled = false
        skeletonAnimationView.backgroundBehavior = .stop
        skeletonAnimationView.translatesAutoresizingMaskIntoConstraints = false
        skeletonAnimationView.topAnchor.constraint(equalTo: congratsView.topAnchor, constant: 0).isActive = true
        skeletonAnimationView.bottomAnchor.constraint(equalTo: congratsView.bottomAnchor, constant: 0).isActive = true
        skeletonAnimationView.leftAnchor.constraint(equalTo: congratsView.leftAnchor, constant: 0).isActive = true
        skeletonAnimationView.trailingAnchor.constraint(equalTo: congratsView.trailingAnchor, constant: 0).isActive = true
        
    }
    
    func addBlurView(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        blur1 = UIVisualEffectView(effect: blurEffect)
        blur1.frame = card1.bounds
        blur1.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur1.layer.cornerRadius = 10.0
        blur1.clipsToBounds = true
        card1.addSubview(blur1)
        
        blur2 = UIVisualEffectView(effect: blurEffect)
        blur2.frame = card2.bounds
        blur2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur2.layer.cornerRadius = 10.0
        blur2.clipsToBounds = true
        card2.addSubview(blur2)
        
        blur3 = UIVisualEffectView(effect: blurEffect)
        blur3.frame = card3.bounds
        blur3.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur3.layer.cornerRadius = 10.0
        blur3.clipsToBounds = true
        card3.addSubview(blur3)
        
    }
    
    func addLockImageView(){
        lock1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        //lock1.image = UIImage(named: "Lock")
        lock1.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        lock1.layer.cornerRadius = 30
        card1.addSubview(lock1)
        addConstraint(mainView: lock1, subView: card1)
        
        lock2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        //lock2.image = UIImage(named: "Lock")
        lock2.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        lock2.layer.cornerRadius = 30
        //lock2.center = card1.center
        card2.addSubview(lock2)
        addConstraint(mainView: lock2, subView: card2)
        
        lock3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        //lock3.image = UIImage(named: "Lock")
        lock3.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        lock3.layer.cornerRadius = 30
        //lock3.center = card1.center
        card3.addSubview(lock3)
        addConstraint(mainView: lock3, subView: card3)
        
    }
    
    func addConstraint(mainView:UIView,subView:UIView){
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.centerYAnchor.constraint(equalTo: subView.centerYAnchor, constant: 0).isActive = true
        mainView.centerXAnchor.constraint(equalTo: subView.centerXAnchor, constant: 0).isActive = true
        mainView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func playParticleAnimation(animationView:AnimationView,completion: @escaping () -> ()){
        animationView.isHidden = false
        //print("Started Playing Animation")
       /* DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            completion()
        }*/
        animationView.play(fromProgress: fromProgress, toProgress: toProgress, loopMode: loopMode) { status in
            animationView.isHidden = true
            animationView.stop()
            completion()
            //print("Finished Playing Animation")
        }
    }
    
    func playCongratsAnimation(animationView:AnimationView,completion: @escaping () -> ()){
        animationView.isHidden = false
        animationView.play { status in
            animationView.isHidden = true
            animationView.stop()
            completion()
        }
    }
    
    func expandCard(card:UIView,completion : @escaping () -> ()){
        completion()
        /*UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            card.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2) // Scale your image
            completion()
        }, completion: {_ in
            UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
                   card.transform = CGAffineTransform.identity // undo in 1 seconds
            }, completion: nil)
        })*/
    }
    
    @IBAction func getMyCardBtnClicked(_ sender: Any) {
        self.isApiFinished = false
        self.defaultState(showCardBtn: true)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.flipCardAndPlayAnimation), userInfo: nil, repeats: true)
        self.getCardFinderRequest()
    }
    
    @IBAction func dateBtnClicked(_ sender: Any) {
        
    }
    
    func defaultState(showCardBtn:Bool){
        self.blur1.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        self.lock1.isHidden = false
        self.blur2.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        self.lock2.isHidden = false
        self.blur3.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        self.lock3.isHidden = false
        animationView1.isHidden = false
        animationView2.isHidden = false
        animationView3.isHidden = false
        cardPlayBtn.isHidden = showCardBtn
        cardPlayBtn.isEnabled = true
        //cardPlayBtn.isEnabled = showCardBtn
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
}

extension CardFinderVC : SideMenuDelegate{
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
    
    func goToLogin(){
        let controllers = self.navigationController?.viewControllers
          for vc in controllers! {
            if vc.isKind(of: LoginPageVC.self) {
              _ = self.navigationController?.popToViewController(vc , animated: true)
            }
         }
    }
    
    func finalStep(){
        timer?.invalidate()
        nextCardTimer?.invalidate()
        UserDefaultsHelper().clearUserdefaults()
        UserModal.sharedInstance.reset()
        goToLogin()
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

extension CardFinderVC{
    
    func getUserRequest(){
        AppDelegate.shared.showLoading(isShow: true)
        LoginVM().getUser(urlParams: nil, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.checkNextCardFinderDate()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func getCardFinderRequest(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true]] as [String : Any]
        //AppDelegate.shared.showLoading(isShow: true)
        viewModal.getCardFinder(urlParams: param, param: nil, onSuccess: { message in
            //AppDelegate.shared.showLoading(isShow: false)
            self.isApiFinished = true
        }, onFailure: { error in
            //AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
            self.timer?.invalidate()
            self.counter = 0
            self.defaultState(showCardBtn: false)
            //self.timerViewHeightConst.constant = 56.5
            //self.isApiFinished = true
        })
    }
    
}

extension CardFinderVC: SideMenuNavigationControllerDelegate {

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
