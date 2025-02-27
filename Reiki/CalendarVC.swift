//
//  CalendarVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 22/09/22.
//

import UIKit
import SideMenu
import EventKit
import FSCalendar
import Switches

class CalendarVC: UIViewController,KVKCalendarSettings {
    
    @IBOutlet var backgroundImageView: CustomImageView!
    @IBOutlet weak var transitionView: UIImageView!
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var monthBtn: UIButton!
    @IBOutlet var yearBtn: UIButton!
    @IBOutlet var bottomViewLeadingConst: NSLayoutConstraint!
    @IBOutlet var moreView: UIView!
    @IBOutlet var calendarSwitch: UISwitch!
    @IBOutlet var publicTitle: UILabel!
    @IBOutlet var createCustomView: UIView!
    @IBOutlet var seperateView: UIView!
    
    var selectDate = Date()
    var events = [Event]() {
        didSet {
            calendarView.reloadData()
        }
    }
    @IBOutlet var manView: UIView!
    @IBOutlet var monthCalendarView: FSCalendar!
    
    var eventViewer = EventViewer()
    var style: Style {
        createCalendarStyle()
    }
    private lazy var calendarView: CalendarView = {
        var frame = CGRect()
        frame.origin.y = 0
        let calendar = CalendarView(frame: frame, date: selectDate, style: style,years:10)
        calendar.delegate = self
        calendar.dataSource = self
        return calendar
    }()
    private var backgroundTimer: Timer?
    
    var previouslySelectedThemes: [ThemeModal] = []
    var themeDurationSeconds : CGFloat = 35.0 //Seconds
    
    @IBOutlet weak var randomE: YapSwitch! {
        didSet {
            randomE.onThumbTintColor = UIColor.init(hexString: "#703FCC")
            randomE.offThumbTintColor = UIColor.white.withAlphaComponent(0.39)
            randomE.onTintColor = UIColor.init(hexString: "#703FCC").withAlphaComponent(0.43)
            randomE.offTintColor = UIColor.white.withAlphaComponent(0.43)
            randomE.isOn = false
        }
    }
    
    var selectedTab = 0
    var calendarVM = CalendarVM()
    var unlockablesVM = UnlockablesVM()
    let switchThumbOnColor = "#703FCC"
    let switchThumbOffColor = "#FFFFFF"
    let switchOnColor = "#D8C4FF"
    let switchOffColor = "#FFFFFF"
    let publicEventFillColorCode = "#AA3270"
    let customEventFillColorCode = "#703FCC"
    
    //Date View
    let titleColor = UIColor.white
    let titleFont = FontHelper.montserratFontSize(fontType: .semiBold, size: 13.0)
    let subtitleColor = UIColor.white
    let todayColor = UIColor.white.withAlphaComponent(0.3)
    let previousMonthAndFutureMonthDateColor = UIColor.white.withAlphaComponent(0.6)
    //Header View
    let calendarWeekdayViewBackgroundColor = UIColor.white.withAlphaComponent(0.5)
    let weekDayFont = FontHelper.montserratFontSize(fontType: .Bold, size: 15.0)
    
    // Invalidate the timer when the view controller is deallocated
    deinit {
        backgroundTimer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSettings()
        
        //AppDelegate.shared.getlevelPopup(level: "1", prestige: true)
    }

    func initialSettings(){
       
        //sidemenu
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
        sideMenuSettings()
        SideMenuManager.default.leftMenuNavigationController?.sideMenuDelegate = self
        moreView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        //Month calendar
        setUpMonthCalendar()
        //Year calendar
        manView.addSubview(calendarView)
        //setSwitch()
    }
    
    func setUpMonthCalendar(){
        //Date View
        monthCalendarView.appearance.titleDefaultColor = titleColor
        monthCalendarView.appearance.subtitleDefaultColor = subtitleColor
        monthCalendarView.appearance.selectionColor = UIColor.clear
        monthCalendarView.appearance.todayColor = todayColor
        monthCalendarView.appearance.titlePlaceholderColor = previousMonthAndFutureMonthDateColor // previous month and future month dates color
        monthCalendarView.appearance.titleFont = titleFont
        //Header View
        monthCalendarView.headerHeight = 0.0
        monthCalendarView.appearance.calendar.calendarWeekdayView.backgroundColor = calendarWeekdayViewBackgroundColor
        monthCalendarView.appearance.caseOptions = .weekdayUsesSingleUpperCase
        monthCalendarView.appearance.weekdayFont = weekDayFont
        //Set calendar Delegate & DataSource
        monthCalendarView.delegate = self
        monthCalendarView.dataSource = self
    }
    
    func setSwitch(){
        calendarSwitch.layer.cornerRadius = 16.0
        calendarSwitch.onTintColor = UIColor.init(hexString: switchThumbOnColor).withAlphaComponent(0.30)
        calendarSwitch.tintColor = UIColor.white
        calendarSwitch.thumbTintColor = calendarSwitch.isOn ? UIColor.init(hexString: switchThumbOnColor) : UIColor.white.withAlphaComponent(0.50)
    }
    
    func setUpYearCalendar(){
        let bottomSafeArea: CGFloat
        if #available(iOS 11.0, *) {
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            bottomSafeArea = bottomLayoutGuide.length
        }
        //Year calendar
        calendarView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height:  (view.frame.height - manView.frame.origin.y) - bottomSafeArea )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getConfigurationRequest()
        getUserThemes()
        commonSettings(date: selectDate,setCalendarImage: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        backgroundTimer?.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setUpYearCalendar()
    }
    
    @IBAction func moreBtbClicked(_ sender: Any) {
        self.moreView.isHidden = false
    }
    
    @IBAction func createCustomEventBtnClicked(_ sender: Any) {
        self.moreView.isHidden = true
        let VC = self.getCreateCustomEventVC()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func updateThemeBtnClicked(_ sender: Any) {
        self.moreView.isHidden = true
        let VC = self.getThemeVC()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func manageNotificationBtnClicked(_ sender: Any) {
        self.moreView.isHidden = true
        let VC = self.getManageNotificationVC()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func monthBtnClicked(_ sender: UIButton) {
       selectDate = Date()
       monthClicked()
    }
    
    func monthClicked(){
        selectedTab = 0
        bottomViewLeadingConst.constant = 15
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (complete: Bool) in
            self.manView.isHidden = true
            self.monthCalendarView.isHidden = false
            self.monthBtn.setTitleColor(UIColor.init(hexString: "#AA3270"), for: .normal)
            self.yearBtn.setTitleColor(.black, for: .normal)
            self.scrolltoMonth(animate: true)
            self.commonSettings(date: self.selectDate)
        })
    }
    
    @IBAction func yearBtnClicked(_ sender: UIButton) {
        selectedTab = 1
        bottomViewLeadingConst.constant = yearBtn.frame.origin.x
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (complete: Bool) in
            self.manView.isHidden = false
            self.monthCalendarView.isHidden = true
            self.yearBtn.setTitleColor(UIColor.init(hexString: "#AA3270"), for: .normal)
            self.monthBtn.setTitleColor(.black, for: .normal)
            self.setTitleLbl(date: Date(), isMonth: false)
            self.calendarView.set(type: .year, date: Date(), animated: false)
        })
    }
    
    func scrolltoMonth(animate:Bool){
        monthCalendarView.setCurrentPage(selectDate, animated: animate)
        //monthCalendarView.select(selectDate, scrollToDate: animate)
        //monthCalendarView.deselect(selectDate)
        monthCalendarView.reloadData()
    }
    

    func setTitleLbl(date:Date?,isMonth:Bool){
        let month = (date ?? Date()).titleForLocale(style.locale, formatter: style.month.titleFormatterHyphen)
        let year = (date ?? Date()).titleForLocale(style.locale, formatter: style.year.titleFormatter)
        let dateLbl = isMonth ? month : year
        titleLbl.text = dateLbl
    }
    
    func commonSettings(date:Date,setCalendarImage:Bool = true){
        setTitleLbl(date: date, isMonth: selectedTab == 0)
        if setCalendarImage{
            setCalendarBackground(date: date)
        }
        if !randomE.isOn{
            self.getCustomActivityList(date: self.monthCalendarView.currentPage)
        }else{
            self.getActivityList(date: self.monthCalendarView.currentPage)
        }
    }

    func goToEventPage(event:EventModal){
        let VC = self.getEventDetailVC()
        VC.event = event
        self.navigationController?.pushViewController(VC, animated: true)
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
    
    @IBAction func switchClicked(_ sender: UISwitch) {
        
    }
    
    @IBAction func switchAction(_ sender: YapSwitch) {
        //setSwitch()
        if !sender.isOn{
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.view.isUserInteractionEnabled = true
                self.getCustomActivityList(date: self.monthCalendarView.currentPage)
            }
            self.createCustomView.isHidden = false
            self.seperateView.isHidden = false
            //self.publicTitle.alpha = 0.5
            self.publicTitle.text = "Custom"
            SwiftMessagesHelper.showSwiftMessage(title: "", body: "Switched to custom events", type: .success)
            
        }else{
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.view.isUserInteractionEnabled = true
                self.getActivityList(date: self.monthCalendarView.currentPage)
            }
            self.createCustomView.isHidden = true
            self.seperateView.isHidden = true
            //self.publicTitle.alpha = 1.0
            self.publicTitle.text = "Public"
            SwiftMessagesHelper.showSwiftMessage(title: "", body: "Switched to public events", type: .success)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == self.moreView {
                moreView.isHidden = true
            }
        }
    }
    
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

//Themes
extension CalendarVC{
    
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
            print("Theme changed")
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

// MARK: - Calendar delegate

extension CalendarVC: CalendarDelegate {
    
    
    func didChangeEvent(_ event: Event, start: Date?, end: Date?) {
        if let result = handleChangingEvent(event, start: start, end: end) {
            //events.replaceSubrange(result.range, with: result.events)
        }
    }
    
    func didSelectDates(_ dates: [Date], type: CalendarType, frame: CGRect?) {
        //selectDate = dates.first ?? Date()
        //print(selectDate)
        //calendarView.reloadData()
    }
    func didSelectDate(_ dates: Date, type: CalendarType, frame: CGRect?) {
        selectDate = dates
        monthClicked()
    }
    
    func didSelectEvent(_ event: Event, type: CalendarType, frame: CGRect?) {
        print(type, event)
        switch type {
        case .day: break
            //eventViewer.text = event.title.timeline
        default:
            break
        }
    }
    
    func didDeselectEvent(_ event: Event, animated: Bool) {
        print(event)
    }
    
    func didSelectMore(_ date: Date, frame: CGRect?) {
        print(date)
    }
    
    func didChangeViewerFrame(_ frame: CGRect) {
        //eventViewer.reloadFrame(frame: frame)
    }
    
    func didAddNewEvent(_ event: Event, _ date: Date?) {
        if let newEvent = handleNewEvent(event, date: date) {
            //events.append(newEvent)
        }
    }
    
    /*func sizeForHeader(_ date: Date?, type: CalendarType) -> CGSize? {
        return CGSize(width: 0, height: 5)
    }*/
}

// MARK: - Calendar datasource

extension CalendarVC: CalendarDataSource {
    
    func dequeueAllDayViewEvent(_ event: Event, date: Date, frame: CGRect) -> UIView? {
        if date.kvkDay == 11 {
            let view = UIView(frame: frame)
            view.backgroundColor = .systemRed
            return view
        }
        return nil
    }
    
    @available(iOS 14.0, *)
    func willDisplayEventOptionMenu(_ event: Event, type: CalendarType) -> (menu: UIMenu, customButton: UIButton?)? {
        handleOptionMenu(type: type)
    }
    
    func eventsForCalendar(systemEvents: [EKEvent]) -> [Event] {
        // if you want to get a system events, you need to set style.systemCalendars = ["test"]
        handleEvents(systemEvents: systemEvents)
    }
    
    func willDisplayEventView(_ event: Event, frame: CGRect, date: Date?) -> EventViewGeneral? {
        handleCustomEventView(event: event, style: style, frame: frame)
    }
    func didDisplayEvents(_ events: [Event], dates: [Date?]) {
        let dateYear = (dates[0] ?? Date()).titleForLocale(style.locale, formatter: style.year.titleFormatter)
        titleLbl.text = dateYear
    }
    
    func dequeueCell<T>(parameter: CellParameter, type: CalendarType, view: T, indexPath: IndexPath) -> KVKCalendarCellProtocol? where T: UIScrollView {
        ///print((parameter.date ?? Date()).titleForLocale(style.locale, formatter: style.year.titleFormatter))
        return handleCell(parameter: parameter, type: type, view: view, indexPath: indexPath)
    }
    
    func willDisplayEventViewer(date: Date, frame: CGRect) -> UIView? {
        eventViewer.frame = frame
        return eventViewer
    }
    
    func sizeForCell(_ date: Date?, type: CalendarType) -> CGSize? {
        handleSizeCell(type: type, stye: calendarView.style, view: view)
    }
}


extension CalendarVC : SideMenuDelegate{
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
        UserDefaultsHelper().clearUserdefaults()
        UserModal.sharedInstance.reset()
        self.goToLogin()
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

extension CalendarVC: SideMenuNavigationControllerDelegate {

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

extension CalendarVC : FSCalendarDataSource,FSCalendarDelegateAppearance,FSCalendarDelegate{
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        selectDate = calendar.currentPage
        commonSettings(date: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let eventsCount = getEventsForDate(date: date).count
        switch eventsCount{
        case 0:
            return 0
        case 1 :
            return 1
        default:
            return 2
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return appearance.titlePlaceholderColor
    }
    
    //Event Color for Date
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let colors = eventColorForDate(date: date, color: "#FFFFFF")
        return [colors!]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return [UIColor.white]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return fillColorForDate(date: date, color: !randomE.isOn ? self.customEventFillColorCode : self.publicEventFillColorCode)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
       return fillColorForDate(date: date, color: !randomE.isOn ? self.customEventFillColorCode : self.publicEventFillColorCode)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if !randomE.isOn{
            return true
        }
        //return isLockedDate(date: date) ? false : true
        return true
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        return borderColorForDate(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        if !randomE.isOn{
            return nil
        }
        return isLockedDate(date: date) ? UIImage(named: "calendarLock") : nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return titleColorForDate(date: date, calendar: calendar)
    }
   
    func isLockedDate(date:Date)->Bool{
        if !randomE.isOn{
            return false
        }
        var isLocked = false
        for i in calendarVM.eventArray{
            let order = NSCalendar.current.compare(i.eventdateAsDate, to: date, toGranularity: .day)
            if order == .orderedSame{
                isLocked = i.isLocked
                continue
            }
        }
        return isLocked
    }
    
    /*func getUnlockedDates(date:Date)->Bool?{
        var isFound : Bool?
        for i in self.calendarVM.eventArray{
            let order = NSCalendar.current.compare(i.eventdateAsDate, to: date, toGranularity: .day)
            if order == .orderedSame{
                for j in self.calendarVM.openEventArray{
                    let order1 = NSCalendar.current.compare(j.eventdateAsDate, to: i.eventdateAsDate, toGranularity: .day)
                    if order1 == .orderedSame{
                        isFound = true
                        continue
                    }
                }
                if isFound == nil && self.calendarVM.openEventArray.count > 0{
                   isFound = false
                }
            }
        }
        return isFound == nil ? nil : isFound! ? true : false
    }*/

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let events = self.calendarVM.eventArray.filter({$0.eventdateAsDate == date})
        let holiday = self.calendarVM.holidayArray.filter({$0.holidayAsDate == date})
        if events.count > 0 || holiday.count > 0{
            presentAllEvents(events: events, holiday: holiday.first)
        }
        /*if events.count > 1{
           presentAllEvents(events: events)
        }else if events.count == 1{
            self.goToEventPage(event: events.first!)
        }*/
        selectDate = date
        monthCalendarView.deselect(selectDate)
        print(date.toString(dateFormat: "dd-MM-yyyy"))
    }
    
    func presentAllEvents(events:[EventModal],holiday:HolidayModal?){
        let VC = self.getAllEventsVC()
        VC.eventsArray = events
        VC.holiday = holiday
        VC.delegate = self
        VC.modalPresentationStyle = .overFullScreen
        self.present(VC, animated: false, completion: nil)
    }
    
    //Calendar Event Title
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let events = getEventsForDate(date: date)
        if events.count > 0{
            //return isLockedDate(date: date) ? nil : getString(str: events.first!.eventTitle)
            return getString(str: events.first!.eventTitle)
        }
        return nil
    }
    
    func getString(str:String)->String{
        if str.count > 4{
           return str.substring(to: 4) + ".."
        }else{
           return str
        }
    }
    
    /*func colorForDate(date:Date,color:String)->UIColor?{
        for i in self.calendarVM.eventArray{
            let order = NSCalendar.current.compare(i.eventdateAsDate, to: date, toGranularity: .day)
            if order == .orderedSame{
                if i.isLocked{
                    return UIColor.init(hexString: color).withAlphaComponent(0.70)
                }else{
                    return UIColor.init(hexString: color)
                }
            }
        }
        return nil
    }*/
    
    func eventColorForDate(date: Date, color: String) -> UIColor? {
        // If not a holiday, check events
        for event in self.calendarVM.eventArray {
            if Calendar.current.compare(event.eventdateAsDate, to: date, toGranularity: .day) == .orderedSame {
                if event.isLocked {
                    return UIColor(hexString: color).withAlphaComponent(0.70)
                } else {
                    return UIColor(hexString: color)
                }
            }
        }
        return nil
    }
    
    func fillColorForDate(date: Date, color: String) -> UIColor? {
        //print(date.toString(dateFormat: "dd/MM/yyyy"))
        // Check if it's a holiday first
        for holiday in self.calendarVM.holidayArray {
            if Calendar.current.compare(holiday.holidayAsDate, to: date, toGranularity: .day) == .orderedSame {
                return UIColor(red: 230/255, green: 111/255, blue: 161/255, alpha: 1.0)
            }
        }
        
        // If not a holiday, check events
        for event in self.calendarVM.eventArray {
            
            if Calendar.current.isDate(event.eventdateAsDate, inSameDayAs: date) {
                let events = self.calendarVM.eventArray.filter { event in
                    event.eventdateAsDate == date &&
                    !event.customUserId.isEmpty &&
                    event.customUserId == UserModal.sharedInstance.userId
                }
                
                if event.isLocked {
                    if events.count > 0{
                        return UIColor(hexString: customEventFillColorCode).withAlphaComponent(0.70)
                    }
                    return UIColor(hexString: color).withAlphaComponent(0.70)
                } else {
                    //print("Event : \(event.customUserId) : date: \(date.toString(dateFormat: "dd/MM/yyyy"))")
                    /*if !event.customUserId.isEmpty && event.customUserId == UserModal.sharedInstance.userId{
                        return UIColor(hexString: customEventFillColorCode) //Custom Event approved by admin for the same user
                    }*/
                    if events.count > 0{
                        return UIColor(hexString: customEventFillColorCode)
                    }
                    return UIColor(hexString: color)
                }
            }
        }
        
        return nil
    }
    
    /*func titleColorForDate(date: Date,calendar:FSCalendar) -> UIColor? {
        
        let order = NSCalendar.current.compare(Date(), to: date, toGranularity: .day)
        if order == .orderedDescending {
            let components = Calendar.current.dateComponents([.year, .month], from: calendar.currentPage)
            guard let currentPageDate = Calendar.current.date(from: components) else {
                return nil
            }
            
            if Calendar.current.compare(date, to: currentPageDate, toGranularity: .month) != .orderedSame {
                return previousMonthAndFutureMonthDateColor // Custom color for out-of-month days
            } else {
                return titleColor // Default color for in-month days
            }
        }

        for event in self.calendarVM.eventArray {
            let order = NSCalendar.current.compare(event.eventdateAsDate, to: date, toGranularity: .day)
            if order == .orderedSame {
                if !randomE.isOn{
                   return titleColor
                }
                return event.isLocked ? previousMonthAndFutureMonthDateColor : titleColor
            }
        }

        if isDateInCurrentMonth(date, fsCalendar: calendar){
            return titleColor
        }else{
            return previousMonthAndFutureMonthDateColor
        }

    }*/
    
    /*func isDateInCurrentMonth(_ date: Date, fsCalendar: FSCalendar) -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let currentMonth = calendar.component(.month, from: currentDate)
        let dateMonth = calendar.component(.month, from: date)
        
        let components = Calendar.current.dateComponents([.year, .month], from: fsCalendar.currentPage)
        guard let currentPageDate = Calendar.current.date(from: components) else {
            return false
        }
        
        return currentMonth == dateMonth && calendar.isDate(date, equalTo: currentPageDate, toGranularity: .month)
    }*/
    
    func titleColorForDate(date: Date,calendar:FSCalendar) -> UIColor? {
        for event in self.calendarVM.eventArray {
            let order = NSCalendar.current.compare(event.eventdateAsDate, to: date, toGranularity: .day)
            if order == .orderedSame {
                if !randomE.isOn{
                   return titleColor
                }
                return event.isLocked ? previousMonthAndFutureMonthDateColor : titleColor
            }
        }
        guard let monthEnd = Date().kvkEndOfMonth else {
            return nil
        }
        let order = Calendar.current.compare(monthEnd, to: date, toGranularity: .day)
        let components = Calendar.current.dateComponents([.year, .month], from: calendar.currentPage)
        guard let currentPageDate = Calendar.current.date(from: components) else {
            return nil
        }
        if order != .orderedAscending && Calendar.current.isDate(date, equalTo: currentPageDate, toGranularity: .month){
           return titleColor
        }else{
            return previousMonthAndFutureMonthDateColor
        }
    }
    
    /*func borderColorForDate(date: Date) -> UIColor? {
        let calendar = Calendar.current
        let orderToday = calendar.compare(Date(), to: date, toGranularity: .day)
        
        // Holidays
        /*for holiday in self.calendarVM.holidayArray {
            if calendar.compare(holiday.holidayAsDate, to: date, toGranularity: .day) == .orderedSame {
                return orderToday == .orderedSame ? UIColor.green : UIColor.clear
            }
        }*/
        // Events
        for event in self.calendarVM.eventArray {
            if calendar.compare(event.eventdateAsDate, to: date, toGranularity: .day) == .orderedSame {
                return orderToday == .orderedSame ? UIColor.white : UIColor.clear
            }
        }

        return UIColor.clear
    }*/
    
    func borderColorForDate(date: Date) -> UIColor? {
        let calendar = Calendar.current
        let today = Date()
        let orderToday = calendar.compare(today, to: date, toGranularity: .day)

        // Holidays (Priority)
        /*for holiday in self.calendarVM.holidayArray {
            if calendar.isDate(holiday.holidayAsDate, inSameDayAs: date) {
                return UIColor.green
            }
        }
            */
        // Events
        for event in self.calendarVM.eventArray {
            if calendar.isDate(event.eventdateAsDate, inSameDayAs: date) {
                return orderToday == .orderedSame ? UIColor.white : UIColor.clear
            }
        }

        // Today
        
        if calendar.isDate(today, inSameDayAs: date) {
            return UIColor.white
        }

        // Default
        return UIColor.clear
    }

    
    func getEventsForDate(date:Date)->[EventModal]{
        let events = self.calendarVM.eventArray.filter({$0.eventdateAsDate == date})
        return events
    }
}

extension CalendarVC : AllEventsDelegate{
    func eventSelected(event: EventModal) {
        self.goToEventPage(event: event)
    }
}

extension CalendarVC{
    //Get Public Events
    func getActivityList(date:Date){
        let startDate = date.kvkStartOfMonth ?? Date()
        let endDate = date.kvkEndOfMonth ?? Date()
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true,
                              "date":["$gte":startDate.toString(dateFormat: "yyyy/MM/dd"),"$lte":endDate.toString(dateFormat: "yyyy/MM/dd")]]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        calendarVM.getCalendarActivityList(urlParams: param, param: nil, onSuccess: { message in
            //Get Holidays List
            self.getHolidayList(date: date) {
                AppDelegate.shared.showLoading(isShow: false)
                self.createCalendarEventArray()
                self.monthCalendarView.reloadData()
            }
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func createCalendarEventArray(){
        let orderMonth = NSCalendar.current.compare(monthCalendarView.currentPage, to: Date(), toGranularity: .month)
        if orderMonth == .orderedAscending || orderMonth == .orderedSame{
            _ = self.calendarVM.eventArray.map({$0.isLocked = false})
            print("Past Month or same Month")
            return
        }
        for i in self.calendarVM.eventArray{
            for j in self.calendarVM.openEventArray{
                let order = NSCalendar.current.compare(i.eventdateAsDate, to: j.eventdateAsDate, toGranularity: .day)
                if order == .orderedSame{
                    i.isLocked = false
                    continue
                }
            }
        }
        /*if self.calendarVM.openEventArray.count == 0{
            let order = NSCalendar.current.compare(monthCalendarView.currentPage, to: Date(), toGranularity: .month)
            //print(monthCalendarView.currentPage.toString(dateFormat: "dd/MM/yyyy"))
            if order == .orderedAscending || order == .orderedSame{
                _ = self.calendarVM.eventArray.map({$0.isLocked = false})
            }else{
                _ = self.calendarVM.eventArray.map({$0.isLocked = true})
            }
        }*/
    }
    
    func getCustomActivityList(date:Date){
        let startDate = date.kvkStartOfMonth ?? Date()
        let endDate = date.kvkEndOfMonth ?? Date()
        let param = ["offset":0,
                     "limit":-1,
                     "where":["user_id":Int(UserModal.sharedInstance.userId)!,"active":true,"date":["$gte":startDate.toString(dateFormat: "yyyy/MM/dd"),"$lte":endDate.toString(dateFormat: "yyyy/MM/dd")]],
                     "populate":["custom_request"]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        calendarVM.getCustomActivityList(urlParams: param, param: nil, onSuccess: { message in
            self.getHolidayList(date: date) {
                AppDelegate.shared.showLoading(isShow: false)
                self.monthCalendarView.reloadData()
            }
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func getConfigurationRequest(){
        //AppDelegate.shared.showLoading(isShow: true)
        LoginVM().getConfiguration(urlParams: nil, param: nil, onSuccess: { message in
            //AppDelegate.shared.showLoading(isShow: false)
              if newNotification != nil{
                if let userInfoDict = newNotification as? [String:Any]{
                        if let type = userInfoDict["type"] as? String{
                            if type == "public"{
                                if let event = self.getObject(userInfo: userInfoDict){
                                    let modal = EventModal()
                                    modal.createModal(dict: event)
                                    modal.eventType = .publicType
                                    self.getEventDetail(event: modal)
                                }
                            }else{
                                if let event = self.getObject(userInfo: userInfoDict){
                                   let modal = EventModal()
                                    modal.createModal(dict: event)
                                    modal.eventType = .custom
                                    self.getEventDetail(event: modal)
                                }
                           }
                      }
                  }
             }
            newNotification = nil
        }, onFailure: { error in
            //AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func getEventDetail(event:EventModal){
        let VC = self.getEventDetailVC()
        VC.event = event
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func getObject(userInfo:[AnyHashable: Any])->[String:Any]?{
        do {
            if let dd =  userInfo["event"] as? String{
                let con = try JSONSerialization.jsonObject(with: dd.data(using: .utf8)!, options: []) as! [String:Any]
                return con
            }
            return nil
        }catch {
           print(error)
            return nil
        }
    }
    
    func getUserThemes(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["$theme.active$":true,"applied":true,"user_id":Int(UserModal.sharedInstance.userId)!],
                     "populate":["theme"]] as [String : Any]
        //AppDelegate.shared.showLoading(isShow: true)
        unlockablesVM.getUserThemes(urlParams: param, param: nil, onSuccess: { message in
            //AppDelegate.shared.showLoading(isShow: false)
            self.previouslySelectedThemes.removeAll()
            self.setCalendarBackground(date: self.monthCalendarView.currentPage)
        }, onFailure: { error in
            //AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
    func getHolidayList(date: Date, completion: @escaping () -> Void) {
        let startDate = date.kvkStartOfMonth ?? Date()
        let endDate = date.kvkEndOfMonth ?? Date()
        let param = [
            "offset": 0,
            "limit": -1,
            "where": [
                "active": true,
                "date": [
                    "$gte": startDate.toString(dateFormat: "yyyy/MM/dd"),
                    "$lte": endDate.toString(dateFormat: "yyyy/MM/dd")
                ]
            ]
        ] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        calendarVM.getHolidayList(urlParams: param, param: nil, onSuccess: { message in
            completion()
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
            completion()
        })
    }

}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
