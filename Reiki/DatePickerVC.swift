//
//  DatePickerVC.swift
//  Showcase
//
//  Created by NewAgeSMB on 23/10/21.
//

import UIKit
import FSCalendar

protocol DatePickerDelegate {
    func dateSelected(date:Date?)
}

class DatePickerVC: UIViewController {

    @IBOutlet weak var calendarView: FSCalendar!
    
    var delegate : DatePickerDelegate?
    var selectedDate:Date?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        calendarView.dataSource = self
        if let selectedDate = selectedDate, selectedDate < Date() {
            // If the selected date is in the past, default to the current date
            calendarView.select(Date(), scrollToDate: false)
        } else {
            // Otherwise, select the provided date
            calendarView.select(selectedDate ?? Date(), scrollToDate: false)
        }
        calendarView.appearance.todayColor = UIColor.clear
        calendarView.appearance.titleTodayColor = UIColor.init(hexString: "#AA3270")
        calendarView.reloadData()
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func doneBtnClicked(_ sender: Any) {
        self.cancelBtnClicked(self)
        delegate?.dateSelected(date: calendarView.selectedDate ?? calendarView.today)
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

extension DatePickerVC : FSCalendarDataSource{
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
}
