//
//  EventDetailVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 27/09/22.
//

import UIKit
import SwiftyAttributes

class EventDetailVC: UIViewController {
    @IBOutlet var eventTitlLbl: UILabel!
    @IBOutlet var eventImageView: CustomImageView!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var eventDescription: UILabel!
    @IBOutlet var journalInfoView: UIView!
    @IBOutlet var jouranlLbl: UILabel!
    @IBOutlet var useJournalView: UIView!
    @IBOutlet var moreBtn: UIButton!
    @IBOutlet var completeNowBtn: UIButton!
    @IBOutlet var favoriteBtn: UIButton!
    @IBOutlet var typeLbl: UILabel!
    @IBOutlet var statusView: UIView!
    @IBOutlet var statusIconImageView: UIImageView!
    @IBOutlet var orLbl: UILabel!
    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var extraOptionBtn: UIButton!
    @IBOutlet var moreView: UIView!
    
    var event = EventModal()
    var viewModal = CalendarVM()
    var localTimeZoneIdentifier: String {
        return TimeZone.current.identifier
    }
    var activityPoint = "0"
    var journalPoint = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //getConfigurationRequest(completion: {
            if self.event.eventType == .publicType{
                self.updateUserActivityRequest()
                self.getActivityStatusRequest()
            }else{
                self.extraOptionBtn.isHidden = self.event.isCompleted
                self.setUIEventStatus()
                self.getFavoriteRequest()
            }
        //})
    }
    
    func initialSettings(){
        moreView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        if !event.isCompleted{
            if let activity = UserModal.sharedInstance.configuration.filter({$0.type == "activity"}).first{
                activityPoint = activity.point
            }
            if let journal = UserModal.sharedInstance.configuration.filter({$0.type == "journal"}).first{
                journalPoint = journal.point
            }
        }
        eventImageView.roundCorners(cornerRadius: 25.0, cornerMask: [.layerMinXMaxYCorner,.layerMaxXMaxYCorner])
        eventImageView.layer.borderWidth = 1.0
        eventImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        journalInfoView.layer.borderWidth = 1.0
        journalInfoView.layer.borderColor = UIColor.init(hexString: "#AA3270").cgColor
        useJournalView.layer.borderWidth = 1.0
        useJournalView.layer.borderColor = UIColor.init(hexString: "#BBDEFB").cgColor
        
        if event.eventType == .publicType{
            jouranlLbl.attributedText = "Click to use Journal".withFont(FontHelper.montserratFontSize(fontType: .semiBold, size: 14.0)) + " (\(journalPoint)+xp)".withFont(FontHelper.montserratFontSize(fontType: .medium, size: 14.0))
            let completeNowText = "Complete Now".withFont(FontHelper.montserratFontSize(fontType: .Bold, size: 17.0)) + " (\(activityPoint)+xp)".withFont(FontHelper.montserratFontSize(fontType: .semiBold, size: 16.0))
            completeNowBtn.setAttributedTitle(completeNowText, for: .normal)
        }
        setUI()
    }
    
    func setUI(){
        eventImageView.ImageViewLoading(mediaUrl: event.eventImage, placeHolderImage: UIImage(named: "noImageEvent"))
        eventTitlLbl.text = event.eventTitle
        dateLbl.text = event.eventdateAsDate.toString(dateFormat: "MMMM d yyyy")
        eventDescription.text = event.eventdesc
        typeLbl.isHidden = event.eventType != .custom
        setMoreBtn()
    }

    func setMoreBtn(){
        eventDescription.numberOfLines = 6
        let noOfLines = countLabelLines(label: eventDescription)
        moreBtn.isHidden = noOfLines < 7
    }
    
    @IBAction func downBtnClicked(_ sender: UIButton) {
        if !sender.isSelected{
            sender.isSelected = true
            sender.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            eventDescription.isHidden = true
            moreBtn.isHidden = true
        }else{
            sender.isSelected = false
            sender.transform = CGAffineTransform.identity
            eventDescription.isHidden = false
            setMoreBtn()
        }
    }
    
    @IBAction func moreBtnClicked(_ sender: Any) {
        eventDescription.numberOfLines = 0
        moreBtn.isHidden = true
    }
    
    @IBAction func favoriteBtnClicked(_ sender: Any) {
        if event.isFavorite{
           removeFavoriteActivityRequest()
        }else{
           favoriteActivityRequest()
        }
    }
    
    func updateFavoriteBtn(status:Bool){
        favoriteBtn.setImage(status ? UIImage(named: "favoriteRed") : UIImage(named: "favoriteWhite"), for: .normal)
    }
    
    @IBAction func journalBtnClicked(_ sender: Any) {
        let VC = self.getAddJournalVC()
        VC.event = self.event
        if event.eventType == .publicType{
            //let point = ((Int(activityPoint) ?? 0) + (Int(journalPoint) ?? 0))
            let point = (Int(journalPoint) ?? 0)
            VC.point = String(point)
        }
        VC.delegate = self
        VC.isExpired = isDateExpired()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func completeBtnClicked(_ sender: Any) {
        if event.eventType == .publicType{
            if event.journal.isEmpty{
                self.completeUserActivityRequest(point: self.activityPoint)
            }else{
                let point = Int(self.activityPoint)! + Int(self.journalPoint)!
                self.editUserActivityRequest(point: String(point))
            }
        }else{
            self.completeCustomActivityRequest()
        }
    }
    
    func setUIEventStatus(){
       
        let futureDate = NSCalendar.current.compare(event.eventdateAsDate, to: Date(), toGranularity: .day)
        
        if event.isCompleted{
            statusView.isHidden = false
            statusView.backgroundColor = UIColor.init(hexString: "42980A")
            journalInfoView.isHidden = false
            useJournalView.isHidden = false
            orLbl.isHidden = true
            completeNowBtn.isHidden = true
            statusLbl.text = "COMPLETED"
            statusIconImageView.image = UIImage(named: "Check-White")
            if !event.journal.isEmpty{
                jouranlLbl.attributedText = "View Journal".withFont(FontHelper.montserratFontSize(fontType: .semiBold, size: 14.0))
            }
        }
        else if event.eventType == .publicType && futureDate == .orderedDescending{ // Future Dates - (Hide complete Now)
            statusView.isHidden = true
            journalInfoView.isHidden = false
            useJournalView.isHidden = false
            orLbl.isHidden = false
            completeNowBtn.isHidden = false
            completeNowBtn.isEnabled = false
            completeNowBtn.backgroundColor = UIColor.lightGray
            if !event.journal.isEmpty{
                jouranlLbl.attributedText = "View Journal".withFont(FontHelper.montserratFontSize(fontType: .semiBold, size: 14.0))
            }
        }else if event.eventType == .publicType && isDateExpired(){ //Expired : Days before yesterday
            statusView.isHidden = false
            statusView.backgroundColor = UIColor.init(hexString: "#DE4040")
            journalInfoView.isHidden = true
            useJournalView.isHidden = event.journal.isEmpty
            orLbl.isHidden = true
            completeNowBtn.isHidden = true
            statusLbl.text = "EXPIRED"
            statusIconImageView.image = UIImage(named: "expired")
            if !event.journal.isEmpty{
                jouranlLbl.attributedText = "View Journal".withFont(FontHelper.montserratFontSize(fontType: .semiBold, size: 14.0))
            }
        }else{
            statusView.isHidden = true
            journalInfoView.isHidden = false
            useJournalView.isHidden = false
            orLbl.isHidden = false
            completeNowBtn.isHidden = false
            if !event.journal.isEmpty{
                jouranlLbl.attributedText = "View Journal".withFont(FontHelper.montserratFontSize(fontType: .semiBold, size: 14.0))
            }
        }
    }
    
    func isDateExpired()->Bool{
        let calendar = Calendar.current
        let oneDaysAgo = calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let order = NSCalendar.current.compare(event.eventdateAsDate, to: oneDaysAgo, toGranularity: .day)
        return order == .orderedAscending
    }
    
    @IBAction func extraOptionBtnClicked(_ sender: Any) {
        moreView.isHidden = false
    }
    

    @IBAction func editBtnClicked(_ sender: Any) {
        moreView.isHidden = true
        let VC = self.getCreateCustomEventVC()
        VC.isEdit = true
        VC.event = self.event
        VC.delegate = self
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
        moreView.isHidden = true
        self.deleteEventAlert()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func countLabelLines(label: UILabel) -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout
        let myText = label.text! as NSString
        let rect = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font!], context: nil)
        return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
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

extension EventDetailVC : EditCustomEventDelegate{
    func eventEdited(event: EventModal) {
        self.event = event
        self.setUI()
    }
}

extension EventDetailVC : AddJournalDelegate{
    func journalAdded(isCompleted:Bool,journal: String, chest: CardModal?) {
        self.event.isCompleted = isCompleted
        self.event.journal = journal
        self.setUIEventStatus()
        if event.eventType == .custom && isCompleted{
           self.extraOptionBtn.isHidden = true
        }
        if chest != nil{
            self.HiddenChestAlert(card: chest!)
        }
    }
}

extension EventDetailVC{
    func completAlert(xpPoint:String,isHiddenChest:CardModal?){
        let VC = self.getEventCompletVC()
        VC.xpPoint = xpPoint
        VC.doneBtnClick  = { [weak self]  in
            if isHiddenChest != nil{
                self?.HiddenChestAlert(card: isHiddenChest!)
                self?.viewModal.card = nil
            }else{
                NotificationCenter.default.post(name: Notification.Name("Notification"), object: nil)
            }
        }
        VC.modalPresentationStyle = .overFullScreen
        self.present(VC, animated: false, completion: nil)
    }
}

extension EventDetailVC{
    func HiddenChestAlert(card:CardModal){
        let VC = self.getUnlockHiddenChestVC()
        VC.card = card
        VC.doneBtnClick  = { [weak self]  in
            NotificationCenter.default.post(name: Notification.Name("Notification"), object: nil)
        }
        VC.modalPresentationStyle = .overFullScreen
        self.present(VC, animated: false, completion: nil)
    }
    
    func deleteEventAlert(){
        let VC = self.getPopUpVC()
        VC.titleString = "Delete Event"
        VC.messageString = MessageHelper.PopupMessage.deleteEventMessage
        VC.noBtnClick  = { [weak self]  in
        }
        VC.yesBtnClick  = { [weak self]  in
            self?.deleteCustomActivityRequest()
        }
        VC.modalPresentationStyle = .overFullScreen
        self.present(VC, animated: false, completion: nil)
    }
}

extension EventDetailVC{
    
    func getConfigurationRequest(completion: @escaping () -> Void){
        //AppDelegate.shared.showLoading(isShow: true)
        LoginVM().getConfiguration(urlParams: nil, param: nil, onSuccess: { message in
            //AppDelegate.shared.showLoading(isShow: false)
            completion()
        }, onFailure: { error in
            //AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func updateUserActivityRequest(){
        let param = ["activity_list_id":Int(self.event.eventId)!,
                     "completed_date":Date().toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS"),
                     "timezone":self.localTimeZoneIdentifier] as [String:Any]
        viewModal.userActivityView(urlParams: nil, param: param, onSuccess: { message in
        }, onFailure: { error in
           
        })
    }
    
    func getActivityStatusRequest(){
        let param = ["where":["activity_list_id":self.event.eventId,"user_id":UserModal.sharedInstance.userId]]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.getUserActivity(urlParams: param, param: nil, onSuccess: { message in
            self.event.journal = self.viewModal.event.journal
            self.event.userActivityId = self.viewModal.event.userActivityId
            self.event.isCompleted = self.viewModal.isActivityCompleted
            self.setUIEventStatus()
            self.getFavoriteRequest()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func getFavoriteRequest(){
        var param = [:] as [String:Any]
        if event.eventType == .publicType{
            param.updateValue(["activity_id":event.eventId,"user_id":Int(UserModal.sharedInstance.userId)!], forKey: "where")
        }else if event.eventType == .custom{
            param.updateValue(["custom_activity_id":event.eventId,"user_id":Int(UserModal.sharedInstance.userId)!], forKey: "where")
        }
        
        //AppDelegate.shared.showLoading(isShow: true)
        viewModal.getFavorite(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.event.favoriteId = self.viewModal.favoriteId
            self.event.isFavorite = self.viewModal.isFavorite
            self.updateFavoriteBtn(status: self.viewModal.isFavorite)
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func favoriteActivityRequest(){
        var param = ["completed_date":Date().toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS"),
                     "timezone":self.localTimeZoneIdentifier] as [String:Any]
        if event.eventType == .publicType{
            param.updateValue(Int(event.eventId)!, forKey: "activity_id")
            param.updateValue("Normal", forKey: "activity_type")
        }else if event.eventType == .custom{
            param.updateValue(Int(event.eventId)!, forKey: "custom_activity_id")
            param.updateValue("Custom", forKey: "activity_type")
        }
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.favoriteActivity(urlParams: nil, param: param) { (message) in
            AppDelegate.shared.showLoading(isShow: false)
            let successMessage = "\(MessageHelper.SuccessMessage.favorited)"
            SwiftMessagesHelper.showSwiftMessage(title: "", body: successMessage, type: .success)
            self.event.isFavorite = true
            self.event.favoriteId = self.viewModal.favoriteId
            self.updateFavoriteBtn(status: true)
        } onFailure: { (error) in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        }
    }
    
    func removeFavoriteActivityRequest(){
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.removeFavoriteActivity(id: self.event.favoriteId,urlParams: nil, param: nil) { (message) in
            AppDelegate.shared.showLoading(isShow: false)
            let successMessage = "\(MessageHelper.SuccessMessage.removedFavorite)"
            SwiftMessagesHelper.showSwiftMessage(title: "", body: successMessage, type: .success)
            self.event.isFavorite = false
            self.event.favoriteId = ""
            self.updateFavoriteBtn(status: false)
        } onFailure: { (error) in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        }
    }
    
    func completeUserActivityRequest(point:String){
        var param = ["completed_date":Date().toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS"),
                     "timezone":self.localTimeZoneIdentifier,
                     "activity_list_id":Int(self.event.eventId)!] as [String:Any]
        if !point.isEmpty{
            param.updateValue(Int(point)!, forKey: "point")
        }
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.createUserActivity(urlParams: nil, param: param) { (message) in
            AppDelegate.shared.showLoading(isShow: false)
            self.event.userActivityId = self.viewModal.useractivityId
            self.viewModal.useractivityId = ""
            self.event.isCompleted = true
            self.setUIEventStatus()
            self.completAlert(xpPoint: point, isHiddenChest: self.viewModal.card)
        } onFailure: { (error) in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        }
    }
    
    func editUserActivityRequest(point:String){
        var param = ["completed_date":Date().toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS"),
                     "timezone":self.localTimeZoneIdentifier,
                     "activity_list_id":Int(self.event.eventId)!] as [String:Any]
        if !point.isEmpty{
            param.updateValue(Int(point)!, forKey: "point")
        }
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.editUserActivity(id: self.event.userActivityId, urlParams: nil, param: param) { (message) in
            AppDelegate.shared.showLoading(isShow: false)
            self.event.isCompleted = true
            self.setUIEventStatus()
            self.completAlert(xpPoint: point, isHiddenChest: self.viewModal.card)
        } onFailure: { (error) in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        }
    }

    func completeCustomActivityRequest(){
        let param = ["status":"Completed"] as [String:Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.updateCustomUserActivity(id:self.event.eventId,urlParams: nil, param: param) { (message) in
            AppDelegate.shared.showLoading(isShow: false)
            self.event.isCompleted = true
            self.setUIEventStatus()
            self.extraOptionBtn.isHidden = true
            self.completAlert(xpPoint: "", isHiddenChest: self.viewModal.card)
        } onFailure: { (error) in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        }
    }
    
    func deleteCustomActivityRequest(){
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.deleteCustomActivity(id:self.event.eventId, urlParams: nil,param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.customEventDeleted, type: .success)
            self.backBtnClicked(self)
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
}
