//
//  EventCompletVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 29/09/22.
//

import UIKit

class EventCompletVC: UIViewController {

    @IBOutlet var messageLbl: UILabel!
    
    var xpPoint = ""
    open var doneBtnClick: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setUI()
    }
    
    func setUI(){
        if xpPoint.isEmpty{
            messageLbl.text = "You have successfully completed the Activity"
        }else{
            messageLbl.text = "You have successfully completed the Activity & gained \(xpPoint)xp points"
        }
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func doneBtnClicked(_ sender: Any) {
        self.dismiss(animated: false)
        doneBtnClick!()
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
