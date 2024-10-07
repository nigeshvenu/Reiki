//
//  AllEventsVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 27/09/22.
//

import UIKit

protocol AllEventsDelegate{
    func eventSelected(event:EventModal)
}

class AllEventsVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var eventsArray = [EventModal]()
    var holiday : HolidayModal?
    var delegate : AllEventsDelegate?
    let customEventFillColorCode = "#703FCC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        if let holiday = holiday {
            titleLbl.text = eventsArray.isEmpty ? "Holiday" : "Holiday and Events"
            let event = EventModal()
            event.eventTitle = holiday.title
            event.isHoliday = true
            eventsArray.insert(event, at: 0)
        }
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismiss(animated: false)
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

extension AllEventsVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventscell") as! AllEventsTVC
        let event = eventsArray[indexPath.row]
        cell.titleLbl.text = event.eventTitle
        print(event.eventTitle)
        cell.typeLbl.isHidden = event.eventType != .custom
        cell.isUserInteractionEnabled = !event.isHoliday && !event.isLocked
        if event.isHoliday{
            cell.contentView.backgroundColor = UIColor(red: 230/255, green: 111/255, blue: 161/255, alpha: 1.0)
            cell.titleLbl.textColor = UIColor.white
        }else if event.customUserId == UserModal.sharedInstance.userId{
            cell.contentView.backgroundColor = UIColor(hexString: self.customEventFillColorCode)
            cell.titleLbl.textColor = UIColor.white
        }else{
            cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.init(hexString: "#F9F5F5") : UIColor.white
            cell.titleLbl.textColor = UIColor(red: 22/255, green: 29/255, blue: 111/255, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.closeBtnClicked(self)
        self.delegate?.eventSelected(event: eventsArray[indexPath.row])
    }
}
