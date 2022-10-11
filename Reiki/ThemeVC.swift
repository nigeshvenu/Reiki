//
//  ThemeVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 06/10/22.
//

import UIKit

class ThemeVC: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setCalendarBackground(date: Date())
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
