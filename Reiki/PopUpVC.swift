//
//  PopUpVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 14/09/22.
//

import UIKit

class PopUpVC: UIViewController {
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet var yesBtn: UIButton!
    @IBOutlet var noBtn: UIButton!
    
    
    var titleString = ""
    var messageString = ""
    open var noBtnClick: (() -> Void)?
    open var yesBtnClick: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        noBtn.layer.borderWidth = 1
        noBtn.layer.borderColor = UIColor.init(hexString: "#7F69A8").cgColor
        titleLbl.text = titleString
        messageLbl.text = messageString
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func noBtnClicked(_ sender: Any) {
        noBtnClick!()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func yesBtnClicked(_ sender: Any) {
        yesBtnClick!()
        self.dismiss(animated: false, completion: nil)
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
