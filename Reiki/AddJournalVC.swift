//
//  AddJournalVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 28/09/22.
//

import UIKit
protocol AddJournalDelegate{
    func journalAdded(isCompleted:Bool,journal:String,chest:CardModal?)
}

class AddJournalVC: UIViewController {

    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var backgroundImageView: CustomImageView!
    @IBOutlet weak var transitionView: UIImageView!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var saveAndCompleteBtn: UIButton!
    @IBOutlet var typeHereLbl: UILabel!
    
    
    var event = EventModal()
    var textViewTextColor = UIColor.white
    var textViewPlaceholderColor = UIColor.lightGray
    var viewModal = CalendarVM()
    var localTimeZoneIdentifier: String {
        return TimeZone.current.identifier
    }
    var delegate:AddJournalDelegate?
    var point = ""
    var isExpired = false
    var unlockablesVM = UnlockablesVM()
    
    private var backgroundTimer: Timer?
    
    var previouslySelectedThemes: [ThemeModal] = []
    var themeDurationSeconds : CGFloat = 35.0 //Seconds
    
    // Invalidate the timer when the view controller is deallocated
    deinit {
        backgroundTimer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("User Ac id :\(event.userActivityId)")
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getUserThemes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        backgroundTimer?.invalidate()
    }
    
    func initialSettings(){
        textView.textColor = textViewPlaceholderColor
        textView.font = FontHelper.montserratFontSize(fontType: .semiBold, size: 15)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.init(hexString: "#787878").cgColor
        textView.contentInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        textView.text = "Write something.."
        textView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        textView.tintColor = UIColor.white
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.borderColor = UIColor.white.cgColor
        cancelBtn.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        if event.isCompleted{
            textView.isEditable = true
            typeHereLbl.isHidden = false
            saveBtn.isHidden = false
            cancelBtn.isHidden = false
        }else if isExpired{
            textView.isEditable = false
            typeHereLbl.isHidden = true
            saveBtn.isHidden = true
            cancelBtn.isHidden = true
        }else{
            textView.isEditable = true
            typeHereLbl.isHidden = false
            saveBtn.isHidden = false
            cancelBtn.isHidden = false
        }
        
        if !event.journal.isEmpty{
            textView.text = event.journal
            textView.textColor = textViewTextColor
        }
        setUI()
    }
    
    func setUI(){
        self.dateLbl.text = event.eventdateAsDate.toString(dateFormat: "MMMM d") + "th"
    }
    
    func validateFields()->Bool{
        guard let aboutMe = textView.text,!aboutMe.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.journalEmpty, type: .danger)
            return false
        }
        if textView.textColor == textViewPlaceholderColor{
            SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.ErrorMessage.journalEmpty, type: .danger)
            return false
        }
        return true
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        if validateFields(){
            if event.eventType == .publicType{
                if event.userActivityId.isEmpty{
                    self.completeUserActivityRequest(point: "0", isComplete: false)
                }else{
                    self.editUserActivityRequest(point: self.point, isComplete: false)
                }
            }else{
                self.editCustomActivityRequest(isComplete: false, isUpdate: !event.journal.isEmpty)
            }
        }
    }
    
    /*@IBAction func finishBtnClicked(_ sender: Any) {
        
        if validateFields(){
            if event.journal.isEmpty{
                if event.eventType == .publicType{
                    self.completeUserActivityRequest(point: self.point, isComplete: true)
                }else{
                    self.editCustomActivityRequest(isComplete: true, isUpdate: false)
                }
            }else{
                if event.eventType == .publicType{
                    self.editUserActivityRequest(point: self.point, isComplete: true)
                }else{
                    self.editCustomActivityRequest(isComplete: true, isUpdate: false)
                }
            }
           
        }
    }*/
    
    @IBAction func themeBtnClicked(_ sender: Any) {
        
        let VC = self.getThemeVC()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        
        self.backBtnClicked(self)
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

//Themes
extension AddJournalVC{
    
    func getRandomUniqueTheme() -> ThemeModal? {
        var availableThemes = self.unlockablesVM.themeArray.filter { !previouslySelectedThemes.contains($0) }
        
        if availableThemes.isEmpty {
            // Reset if all themes have been used
            previouslySelectedThemes.removeAll()
            availableThemes = self.unlockablesVM.themeArray
        }
        
        guard let selectedTheme = availableThemes.randomElement() else {
            return nil // Handle case where no themes are available
        }
        
        previouslySelectedThemes.append(selectedTheme)
        return selectedTheme
    }
    
    func setCalendarBackground(date:Date){
        if self.unlockablesVM.themeArray.count > 0 {
            if self.unlockablesVM.themeArray.count == 1{
                updateBackgroundImage()
            }else{
                updateBackgroundImageWithTimer()
            }
        } else {
            // Set background based on the current season
            switch date.kvkMonth {
            case 12, 1, 2:
                backgroundImageView.image = UIImage(named: "CalandarWinter")
            case 3, 4, 5:
                backgroundImageView.image = UIImage(named: "CalandarSpring")
            case 6, 7, 8:
                backgroundImageView.image = UIImage(named: "CalandarSummer")
            case 9, 10, 11:
                backgroundImageView.image = UIImage(named: "CalandarAutumn")
            default:
                break
            }
        }
    }
    
    private func updateBackgroundImageWithTimer() {
        // Update background image immediately
        updateBackgroundImage()
        
        // Invalidate any existing timer
        backgroundTimer?.invalidate()
        
        // Start a new timer to update the background every 20 seconds
        backgroundTimer = Timer.scheduledTimer(withTimeInterval: themeDurationSeconds, repeats: true) { [weak self] _ in
            self?.updateBackgroundImage()
        }
    }
    
    @objc private func updateBackgroundImage() {
        if let themes = getRandomUniqueTheme() {
            // Fade out the current image
            UIView.animate(withDuration: 0.5, animations: {
                self.transitionView.backgroundColor = UIColor.black
                self.transitionView.alpha = 1
            }, completion: { _ in
                // Once the fade-out is complete, update the image
                self.backgroundImageView.ImageViewLoading(mediaUrl: themes.themeUrl, placeHolderImage: nil)
                
                // Fade in the new image
                UIView.animate(withDuration: 0.5) {
                    self.transitionView.backgroundColor = UIColor.clear
                    self.transitionView.alpha = 0
                }
            })
        }
    }
}

extension AddJournalVC{
    
    func completeUserActivityRequest(point:String,isComplete:Bool){
        var param = ["activity_list_id":Int(self.event.eventId)!,
                     "journal":(self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines))] as [String:Any]
        if isComplete{
            if !point.isEmpty{
                param.updateValue(Int(point)!, forKey: "point")
            }
            param.updateValue(Date().toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS"), forKey: "completed_date")
            param.updateValue(self.localTimeZoneIdentifier, forKey: "timezone")
        }
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.createUserActivity(urlParams: nil, param: param) { (message) in
            AppDelegate.shared.showLoading(isShow: false)
            if isComplete{
                self.completAlert(xpPoint: point, card: self.viewModal.card)
            }else{
                SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.journalAdded, type: .success)
                self.backBtnClicked(self)
            }
        } onFailure: { (error) in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        }
    }
    
    func editUserActivityRequest(point:String,isComplete:Bool){
        var param = ["journal":(self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines)),
                     "activity_list_id":Int(self.event.eventId)!] as [String:Any]
        if isComplete{
            if !point.isEmpty{
                param.updateValue(Int(point)!, forKey: "point")
            }
            param.updateValue(Date().toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS"), forKey: "completed_date")
            param.updateValue(self.localTimeZoneIdentifier, forKey: "timezone")
        }
        if event.journal.isEmpty{
            if !point.isEmpty{
                param.updateValue(Int(point)!, forKey: "point")
            }
        }else{
            param.updateValue(0, forKey: "point")
        }
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.editUserActivity(id: self.event.userActivityId, urlParams: nil, param: param) { (message) in
            AppDelegate.shared.showLoading(isShow: false)
            if isComplete{
                self.completAlert(xpPoint: point, card: self.viewModal.card)
            }else{
                SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.journalUpdate, type: .success)
                self.backBtnClicked(self)
            }
        } onFailure: { (error) in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        }
    }
}

extension AddJournalVC{
    
    func editCustomActivityRequest(isComplete:Bool,isUpdate:Bool){
        var param = ["journal":(self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines))] as [String:Any]
        if isComplete{
            param.updateValue("Completed", forKey: "status")
        }
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.updateCustomActivity(id:self.event.eventId,param: param, removeImage: false, image: nil, fileName: "image_file", onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            if isComplete{
                self.completAlert(xpPoint: "", card: self.viewModal.card)
            }else{
                self.delegate?.journalAdded(isCompleted: self.event.isCompleted, journal: (self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines)), chest: nil)
                if isUpdate{
                    SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.journalUpdate, type: .success)
                }else{
                    SwiftMessagesHelper.showSwiftMessage(title: "", body: MessageHelper.SuccessMessage.journalAdded, type: .success)
                }
                self.backBtnClicked(self)
            }
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
        
    }
    
    func getUserThemes(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["$theme.active$":true,"applied":true,"user_id":Int(UserModal.sharedInstance.userId)!],
                     "populate":["theme"]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        unlockablesVM.getUserThemes(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.previouslySelectedThemes.removeAll()
            self.setCalendarBackground(date: self.event.eventdateAsDate)
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
}

extension AddJournalVC{
    func completAlert(xpPoint:String,card:CardModal?){
        let VC = self.getEventCompletVC()
        VC.xpPoint = xpPoint
        VC.doneBtnClick  = { [weak self]  in
            self?.delegate?.journalAdded(isCompleted: true, journal: (self?.textView.text.trimmingCharacters(in: .whitespacesAndNewlines))!, chest: card)
            self?.navigationController?.popViewController(animated: true)
        }
        VC.modalPresentationStyle = .overFullScreen
        self.present(VC, animated: false, completion: nil)
    }
}

extension AddJournalVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == textViewPlaceholderColor {
            textView.text = nil
            textView.textColor = textViewTextColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write something.."
            textView.textColor = textViewPlaceholderColor
        }
    }

}
