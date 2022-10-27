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
    
    var eventsArray = [EventModal]()
    var delegate : AllEventsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
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
        cell.typeLbl.isHidden = event.eventType != .custom
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.init(hexString: "#F9F5F5") : UIColor.white
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
